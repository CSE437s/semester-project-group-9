//
//  ChannelCard.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 4/22/24.
//

import SwiftUI

struct ChannelCard: View {
    
    let channel: ChatChannel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                
                if (channel.title.contains("&") && channel.title.contains("@")) {
                    Text(parseDM(channel.title))
                                .font(Font.system(size: 24))
                                .bold()
                                .foregroundStyle(Color(hex: "32652F"))
                } else {
                    Text(channel.title)
                                .font(Font.system(size: 24))
                                .bold()
                                .foregroundStyle(Color(hex: "32652F"))
                }
                Spacer()
                    
                if (channel.title.contains("&") && channel.title.contains("@")) {
                    Text("Direct Message")
                        .bold()
                        .font(Font.system(size: 16))
                        .bold()
                        .foregroundStyle(Color(hex: "32652F"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color(hex: "C6DAC5"))
                        .cornerRadius(12)

                } else {
                    Text("Class Chat")
                        .bold()
                        .font(Font.system(size: 16))
                        .bold()
                        .foregroundStyle(Color(hex: "32652F"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color(hex: "C6DAC5"))
                        .cornerRadius(12)

                }
                
                    }
                }
                .padding()
                .foregroundColor(.black)
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
    }
    
    func parseDM(_ channelName: String) -> String {
        let trimmed = channelName.split(separator: " ")
        for part in trimmed {
            if (!part.contains("&") && !part.contains(UserDefaults.standard.string(forKey: "email")!)) {
                return String(part)
            }
        }
        return ""
    }
    
}

