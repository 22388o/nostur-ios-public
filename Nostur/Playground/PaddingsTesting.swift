import SwiftUI

// Need to test
// 1: Image in POST
// 2: Image in PostDetail
// 3: Image in PostDetail-parent-row
// 4: Image in PostDetail-reply-row

// Same but in FULL WIDTH:
// 1: Image in POST row
// 2: Image in PostDetail
// 3: Image in PostDetail-parent-row
// 4: Image in PostDetail-reply-row

// Article:
// 1: Image in Article row
// 2: Image in Aritcle detail - main image
// 3: Image in Aritcle detail - content image
// 3: Image in Article detail comment row

// In iPhone 14 and tabbed detail container

struct PaddingsTesting_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer({ pe in
            pe.loadMedia()
            pe.loadContacts()
            pe.loadPosts()
            pe.loadReposts()
            pe.loadHighlights()
            pe.loadKind1063()
            pe.parseMessages([
                ###"["EVENT","ARTICLE",{"pubkey":"2edbcea694d164629854a52583458fd6d965b161e3c48b57d3aff01940558884","content":"By nostr:npub1xy54p83r6wnpyhs52xjeztd7qyyeu9ghymz8v66yu8kt3jzx75rqhf3urc \n\nOak Node just released version 0.3.7 which adds Nip-47 Nostr Wallet Connect to your Umbrel LND node. You can find it now on the [Umbrel Store](https://apps.umbrel.com/app/oak-node)\n\nBesides NWC, Oak Node also allows you to:\n* Create email bots to monitor your node, create, and pay LN invoices\n* Create Nostr bots to do the same using Nostr DMs which are E2EE\n* Mine vanity keypairs \n\nFor more I for check out [Oak Node](https://oak-node.net/doc/trunk/README.md) and follow nostr:npub1zg69v7z7u7q4w5wzsqzwdnh58x8py4hef2fm750eqqvw9zkvh76q4yjdwv on Nostr. \n\n### Stay Classy, Nostr. ","id":"d9af49548ae6445368315c2c01338334337027d89f8db133d1d92e2202fb0bb6","created_at":1687484978,"sig":"d55b3ae3dfaf02f9d3c47963543ee6dd6b239247b54485b133776305307ac26a7d4fa3ba8d3b16298476b24fb315ef85484890b436cfc3b9bd5c7a782dbd0f63","kind":30023,"tags":[["d","1687460066013"],["title","OAK NODE ADDS NWC TO YOUR UMBREL"],["summary","Add Nip 47 Nostr Wallet Connect to your Unbrel using Oak Node "],["published_at","1687460623"],["t","Nostr"],["t","Lightning"],["t","Bitcoin"],["t","Lightning Node"],["image","https://nostr.build/i/f5f4716abce7ee42709a4126b870ce6a1374d58e861b7e13da5cf8bc794ed445.jpg"],["p","3129509e23d3a6125e1451a5912dbe01099e151726c4766b44e1ecb8c846f506"],["p","123456785ee7815751c28004e6cef4398e1256f94a93bf51f90018e28accbfb4"]]}]"###
            ])
        }) {
            ScrollView {
                LazyVStack(spacing:0) {
                    if let p = PreviewFetcher.fetchNRPost("ac0c2960db29828ee4a818337ea56df990d9ddd9278341b96c9fb530b4c4dce8") {
                        // A NIP-94 IMAGE (FILE META DATA) (KIND 1063)
                        PostRowDeletable(nrPost: p, fullWidth: true)
                            .roundedBoxShadow()
                            .padding(.horizontal, 0) // NORMAL
                            .padding(.vertical, 10)
                        
                        PostRowDeletable(nrPost: p)
                            .roundedBoxShadow()
                            .padding(.horizontal, DIMENSIONS.POST_ROW_HPADDING) // FULL WIDTH
                            .padding(.vertical, 10)
                    }
                    
                    if let p = PreviewFetcher.fetchNRPost("71a965d8e8546f8927cea23ad865a429dbec0215f36c5e0edad2323eb00f4851") {
                        // A POST EMBEDDING A NIP-94 IMAGE (FILE META DATA) (KIND 1063) WITH nostr:nevent1...
                        PostRowDeletable(nrPost: p, fullWidth: true)
                            .roundedBoxShadow()
                            .padding(.horizontal, 0) // FULL WIDTH
                            .padding(.vertical, 10)
                        
                        PostRowDeletable(nrPost: p)
                            .roundedBoxShadow()
                            .padding(.horizontal, DIMENSIONS.POST_ROW_HPADDING) // NORMAL
                            .padding(.vertical, 10)
                    }
                    
//                    if let p = PreviewFetcher.fetchNRPost("d9af49548ae6445368315c2c01338334337027d89f8db133d1d92e2202fb0bb6") {
//                        PostRowDeletable(nrPost: p, fullWidth: true)
//                            .roundedBoxShadow()
//                            .padding(.horizontal, 0) // FULL WIDTH
//                            .padding(.vertical, 10)
//                        
//                        
//                        PostRowDeletable(nrPost: p)
//                            .roundedBoxShadow()
//                            .padding(.horizontal, DIMENSIONS.POST_ROW_HPADDING) // DEFAULT
//                            .padding(.vertical, 10)
//                    }
                    if let p = PreviewFetcher.fetchNRPost("fdf989cbe5d26d874a4afaf8a78861fcd3267619e7db467a549a6b33c6dbeeab") {
                        // REPOST POST WITH IMAGE
                        PostRowDeletable(nrPost: p)
                            .roundedBoxShadow()
                            .padding(.horizontal, DIMENSIONS.POST_ROW_HPADDING) // NORMAL
                            .padding(.vertical, 10)
                        
                        PostRowDeletable(nrPost: p, fullWidth: true)
                            .roundedBoxShadow()
                            .padding(.horizontal, 0) // FULL WIDTH
                            .padding(.vertical, 10)
                    }
                    
                    if let gif = PreviewFetcher.fetchNRPost("8d49bc0204aad2c0e8bb292b9c99b7dc1bdd6c520a877d908724c27eb5ab8ce8") {
                        PostRowDeletable(nrPost: gif, fullWidth: true)
                            .roundedBoxShadow()
                            .padding(.horizontal, 0) // FULL WIDTH
                            .padding(.vertical, 10)
                    }
                    if let gif = PreviewFetcher.fetchNRPost("1c0ba51ba48e5228e763f72c5c936d610088959fe44535f9c861627287fe8f6d") {
                        PostRowDeletable(nrPost: gif)
                            .roundedBoxShadow()
                            .padding(.horizontal, DIMENSIONS.POST_ROW_HPADDING) // DEFAULT
                            .padding(.vertical, 10)
                    }
                    
                    if let p = PreviewFetcher.fetchNRPost("d3b581761bab06fbe727b12b22c33c7b8768d7d9681b45cb6b1f4ad798496e14") {
                        // A POST WITH LINK PREVIEW WITH IMAGE
                        PostRowDeletable(nrPost: p, fullWidth: true)
                            .roundedBoxShadow()
                            .padding(.horizontal, 0) // FULL WIDTH
                            .padding(.vertical, 10)
                        
                        // A POST WITH LINK PREVIEW WITH IMAGE
                        PostRowDeletable(nrPost: p)
                            .roundedBoxShadow()
                            .padding(.horizontal, DIMENSIONS.POST_ROW_HPADDING) // DEFAULT
                            .padding(.vertical, 10)
                    }
                }
            }
        }
    }
}
