//
//  FeedSelector.swift
//  Nostur
//
//  Created by Fabian Lachman on 05/08/2023.
//

import SwiftUI

struct FeedSelector: View {
    let feeds:[NosturList]
    @Binding var selected:NosturList?
    
    var body: some View {
        Picker("Feed", selection: $selected) {
            Text("Choose feed")
            ForEach(feeds) { feed in
                Text(feed.name_)
                    .tag(Optional(feed))
            }
        }
        .pickerStyle(.menu)
    }
}

struct FeedSelectorTestur: View {
    @State var feeds = PreviewFetcher.fetchLists()
    @State var selected:NosturList? = nil
    
    var body: some View {
        FeedSelector(feeds: feeds, selected: $selected)
    }
}

struct FeedSelector_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer({ pe in
            pe.loadContacts()
            pe.loadNosturLists()
            pe.loadRelayNosturLists()
        }) {
            FeedSelectorTestur()
        }
    }
}
