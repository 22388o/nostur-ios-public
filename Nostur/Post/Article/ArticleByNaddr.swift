//
//  ArticleByNaddr.swift
//  Nostur
//
//  Created by Fabian Lachman on 20/06/2023.
//

import SwiftUI

struct ArticleByNaddr: View {
    let naddr1:String
    var navigationTitle:String? = nil
    @State var article:NRPost? = nil
    @State var backlog = Backlog(timeout: 15, auto: true)
    @State var error:String? = nil
    
    var body: some View {
        VStack {
            if let error  {
                Text(error)
            }
            else if let article {
                if article.kind == 30023 {
                    ArticleView(article, isDetail: true)
                }
                else {
                    PostDetailView(nrPost: article)
                }
            }
            else {
                ProgressView()
                    .onAppear {
                        DataProvider.shared().bg.perform {
                            if let naddr = try? ShareableIdentifier(naddr1),
                               let kind = naddr.kind,
                               let pubkey = naddr.pubkey,
                               let definition = naddr.eventId
                            {
                                if let article = Event.fetchReplacableEvent(kind,
                                                                                 pubkey: pubkey,
                                                                                 definition: definition,
                                                                                 context: DataProvider.shared().bg) {
                                    let article = NRPost(event: article)
                                    DispatchQueue.main.async {
                                        self.article = article
                                    }
                                }
                                else {
                                    let reqTask = ReqTask(
                                        prefix: "ARTICLE-",
                                        reqCommand: { taskId in
                                            req(RM.getArticle(pubkey: pubkey, kind:Int(kind), definition:definition, subscriptionId: taskId))
                                        },
                                        processResponseCommand: { taskId, _ in
                                            DataProvider.shared().bg.perform {
                                                if let article = Event.fetchReplacableEvent(kind,
                                                                                                 pubkey: pubkey,
                                                                                                 definition: definition,
                                                                                                 context: DataProvider.shared().bg) {
                                                    let article = NRPost(event: article)
                                                    DispatchQueue.main.async {
                                                        self.article = article
                                                    }
                                                    backlog.clear()
                                                }
                                            }
                                        },
                                        timeoutCommand: { taskId in
                                            DispatchQueue.main.async {
                                                self.error = "Could not find article"
                                            }
                                        })
                                    
                                    backlog.add(reqTask)
                                    reqTask.fetch()
                                }
                            }
                            else {
                                L.og.error("Could not decode all details from naddr1: \(naddr1)")
                            }
                        }
                    }
            }
        }
    }
}
