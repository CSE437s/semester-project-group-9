//
//  ChatView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 3/26/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = MessageViewModel()
    @State var text = ""
    let channel: ChatChannel
    
    init(channel: ChatChannel) {
        self.channel = channel
        viewModel.fetchData(docId: channel.id)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(viewModel.messages) { message in
                        MessageView(message: message)
                    }
                }
            }
            HStack {
                TextField("Write a message...", text: $text, axis: .vertical)
                    .padding()
                
                Button {
                    if text.count > 0 {
                        viewModel.sendMessage(messageContent: text, sender: UserDefaults.standard.string(forKey: "firstNme")!
                                              , senderEmail: UserDefaults.standard.string(forKey: "email") ?? "no-email@example.com", docId: channel.id)
                        text = ""
                    }
                } label: {
                    if text.count > 0 {
                        Text("Send")
                            .padding()
                            .foregroundStyle(.white)
                            .background(.green)
                            .cornerRadius(50)
                            .padding()

                    } else {
                        Text("Send")
                            .padding()
                            .foregroundStyle(.white)
                            .background(.gray)
                            .cornerRadius(50)
                            .padding()

                    }
                }
            }.background(Color(.systemGray5))
        }
        .navigationTitle(channel.title)
    }
}

//#Preview {
//    ChatView()
//}
