//
//  MessageView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 3/26/24.
//

import SwiftUI

struct MessageView: View {
    var message: UserMessage
    
    var body: some View {
        if message.isFromCurrentUser() {
            HStack {
                HStack {
                    Text(message.text)
                        .padding()
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: 260, alignment: .topLeading)
                .background(Color(.systemBlue))
                .cornerRadius(20)
            }
            .frame(maxWidth: 360, alignment: .trailing)
        } else {
            VStack(spacing: 2) {
                Text(message.senderName)
                    .frame(maxWidth: 360, alignment: .leading)
                    .padding(.top, 8)
                    .padding(.bottom, 0)
                    .padding(.leading, 15)
                HStack {
                        HStack {
                            Text(message.text)
                                .padding()
                        }
                    .frame(maxWidth: 260, alignment: .leading)
                    .background(Color(uiColor: .lightGray))
                    .cornerRadius(20)
                }
                .frame(maxWidth: 360, alignment: .leading)

            }
        }
    }
}

//#Preview {
//    MessageView()
//}
