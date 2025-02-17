//
//  TabButton.swift
//  Nostur
//
//  Created by Fabian Lachman on 26/02/2023.
//

import SwiftUI

struct TabButton: View {
    
    var action:() -> Void
    var title:String = ""
    var selected:Bool = false
    var unread:Int?
    
    var body: some View {
        Button { action() } label: {
            VStack(spacing:0) {
                HStack {
                    Text(title).lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        .padding(.bottom, 5)
                    if let unread, unread > 0 {
                        Text("\(unread)")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(.horizontal,6)
                            .background(Capsule().foregroundColor(.red))
                            .offset(x:-4, y: 0)
                    }
                }
                Rectangle()
                    .frame(height: 3)
                    .background(Color("AccentColor"))
                    .opacity(selected ? 1 : 0.15)
            }
        }
        .contentShape(Rectangle())
    }
}

struct TabButton_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer {
            HStack(spacing: 4) {
                TabButton(action: {
                    print("dede")
                }, title: "testing!")
                
                TabButton(action: {
                    print("dede")
                }, title: "testing!")
                
                TabButton(action: {
                    print("dede")
                }, title: "testing!", unread:3)
                
                TabButton(action: {
                    print("dede")
                }, title: "testing!")
                
                TabButton(action: {
                    print("dede")
                }, title: "testing!")
                
                TabButton(action: {
                    print("dede")
                }, title: "testing!", selected: true)
                          
            }
        }
    }
}
