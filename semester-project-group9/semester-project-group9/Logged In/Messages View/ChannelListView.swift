//
//  ChannelListView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 3/26/24.
//

import SwiftUI

struct ChannelListView: View {
    
    @ObservedObject var viewModel = ChannelsViewModel()
    
    init() {
        viewModel.fetchData()
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.chatrooms) { channel in
                NavigationLink(destination: ChatView(channel: channel)) {
                    HStack {
                        Text(channel.title)
                        Spacer()
                    }

                }
            }
            .navigationTitle("BearChat")
        }
    }
}

#Preview {
    ChannelListView()
}
