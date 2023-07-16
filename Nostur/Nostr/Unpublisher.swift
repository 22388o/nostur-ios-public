//
//  Unpublisher.swift
//  Nostur
//
//  Created by Fabian Lachman on 10/02/2023.
//

import Foundation
import CoreData
import UIKit

/**
 Publish events after 9 seconds, gives time to undo before sending. (accidental likes etc)
 also immediatly publishes all when app goes to background
 
 To publish:
 let cancellationId = up.publish(nEvent)
 event.liked = true
 
 To cancel:
 if cancellationId != nil && up.cancel(cancellationId) {
 event.liked = false
 }
 
 */
class Unpublisher {
    
    enum type {
        case other
        case contactList
    }
    
    let PUBLISH_DELAY:Double = 9.0 // SECONDS
    var timer:Timer?
    var viewContext:NSManagedObjectContext
    var queue:[Unpublished] = []
    let sp:SocketPool = .shared
    
    static var shared = Unpublisher()
    
    init() {
        self.viewContext = DataProvider.shared().viewContext
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(onNextTick), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    // Removes any existing ofType from the queue, before adding this one
    // For example after rapid follow/unfollow, creates new clEvents, only publish the last one
    func publishLast(_ nEvent:NEvent, ofType: Unpublisher.type) -> UUID {
        queue.removeAll(where: { $0.type == ofType })
        let cancellationId = UUID()
        queue.append(Unpublished(type: ofType, cancellationId: cancellationId, nEvent: nEvent, createdAt: Date.now))
        return cancellationId
    }
    
    func publish(_ nEvent:NEvent, cancellationId:UUID? = nil) -> UUID {
        L.og.info("Going to publish")
        let cancellationId = cancellationId ?? UUID()
        queue.append(Unpublished(type:.other, cancellationId: cancellationId, nEvent: nEvent, createdAt: Date.now))
        return cancellationId
    }
    
    func publishNow(_ nEvent:NEvent) {
        sendToRelays(nEvent)
    }
    
    func cancel(_ cancellationId:UUID) -> Bool {
        let beforeCount = queue.count
        queue.removeAll(where: { $0.cancellationId == cancellationId })
        return beforeCount != queue.count
    }
    
    @objc func onNextTick(notification: NSNotification) {
        guard !queue.isEmpty else { return }
        
        queue
            .filter { $0.createdAt < Date.now.addingTimeInterval(-(PUBLISH_DELAY)) }
            .forEach({ item in
                sendToRelays(item.nEvent)
                queue.removeAll { q in
                    q.cancellationId == item.cancellationId
                }
            })
    }
    
    @objc func appMovedToBackground(notification: NSNotification) {
        guard !queue.isEmpty else { return }
        queue.forEach({ sendToRelays($0.nEvent) })
        queue.removeAll()
        
        // lets also save context here...
        DataProvider.shared().save()
    }
    
    private func sendToRelays(_ nEvent:NEvent) {
        if nEvent.kind == .nwcRequest {
            L.og.info("⚡️ Sending .nwcRequest to NWC relay")
            sp.sendMessage(ClientMessage(onlyForNWCRelay: true, message: nEvent.wrappedEventJson()))
            return
        }
//        Disabled: Don't go through Unpublisher, not needed for NC messages
//        if nEvent.kind == .ncMessage {
//            L.og.info("⚡️ Sending .ncMessage to NC relay")
//            sp.sendMessage(ClientMessage(onlyForNCRelay: true, message: nEvent.wrappedEventJson()))
//            return
//        }
        // Always save event first
        if try! Event.fetchEvent(id: nEvent.id, context: viewContext) == nil {
            let bgContext = DataProvider.shared().bg
            
            bgContext.perform {
                let savedEvent = Event.saveEvent(event: nEvent)
                // UPDATE THINGS THAT THIS EVENT RELATES TO. LIKES CACHE ETC (REACTIONS)
                if nEvent.kind == .reaction {
                    do {
                        try Event.updateReactionTo(savedEvent, context: bgContext)
                    } catch {
                        L.og.error("🦋🦋🔴🔴🔴 problem updating Like relation .id \(nEvent.id)")
                    }
                }
                Importer.shared.existingIds.insert(savedEvent.id)
                DataProvider.shared().bgSave()
                if ([1,6,9802,30023].contains(savedEvent.kind)) {
                    DispatchQueue.main.async {
                        sendNotification(.newPostSaved, savedEvent)
                    }
                }
                self.sp.sendMessage(ClientMessage(message: savedEvent.toNEvent().wrappedEventJson()))
            }
        }
        else {
            Importer.shared.existingIds.insert(nEvent.id)
            sp.sendMessage(ClientMessage(message: nEvent.wrappedEventJson()))
        }
    }
}

extension Unpublisher {
    struct Unpublished {
        var type:Unpublisher.type
        var cancellationId:UUID
        var nEvent:NEvent
        var createdAt:Date
    }
}
