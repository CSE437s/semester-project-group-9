//
//  ChannelListView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 3/26/24.
//

import SwiftUI

struct ChannelListView: View {
    
    @ObservedObject var viewModel = ChannelsViewModel()
    let fromProfile: Bool
    
    init(navigatedFromProfile: Bool) {
        fromProfile = navigatedFromProfile
        viewModel.fetchData()
    }
    
    var body: some View {
        
        
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Class Channels")
                        .font(.largeTitle) // Makes the font larger and more prominent
                        .fontWeight(.bold) // Makes the text bold
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5) // Adds some padding to the left to not stick to the edge
                    // Optionally, add vertical padding for spacing
                        .foregroundStyle(Color(hex: "32652F"))
                        .padding()
                    
                    Spacer()
                    
                    ScrollView {
                        ForEach(viewModel.classChannels) { channel in
                            NavigationLink {
                                ChatView(channel: channel)
                            } label: {
                                ChannelCard(channel: channel)
                            }
                            .padding()
                            .foregroundColor(.white)
        //                        .frame(width: UIScreen.main.bounds.width - 20)
                            .cornerRadius(12)

                        }
                    }
                    
                    
                    
                    Text("Direct Messages")
                        .font(.largeTitle) // Makes the font larger and more prominent
                        .fontWeight(.bold) // Makes the text bold
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 5) // Adds some padding to the left to not stick to the edge
                    // Optionally, add vertical padding for spacing
                        .foregroundStyle(Color(hex: "32652F"))
                        .padding()
                    
                    Spacer()
                    
                    if (viewModel.dms.isEmpty) {
                        Text("No Direct Messages yet. Start one by finding someone in your class!")
                    } else {
                        ScrollView {
                            ForEach(viewModel.dms) { channel in
                                NavigationLink {
                                    ChatView(channel: channel)
                                } label: {
                                    ChannelCard(channel: channel)
                                }
                                .padding()
                                .foregroundColor(.white)
                                //                        .frame(width: UIScreen.main.bounds.width - 20)
                                .cornerRadius(12)
                                
                            }
                        }
                    }
                                    
                }
                .toolbar(fromProfile ? .visible : .hidden)
                .padding(.leading, 0)
            }

        }
        
    }
}

