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
        
        
        NavigationStack {
            ScrollView {
                VStack {
                    Text("BearChat Class Channels")
                        .font(.largeTitle) // Makes the font larger and more prominent
                        .fontWeight(.bold) // Makes the text bold
                        .foregroundColor(.primary) // Uses the primary color, adaptable to light/dark mode
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5) // Adds some padding to the left to not stick to the edge
                    // Optionally, add vertical padding for spacing
                        .padding()
                    
                    Spacer()
                    
                    ScrollView {
                        ForEach(viewModel.classChannels) { channel in
                            NavigationLink {
                                ChatView(channel: channel)
                            } label: {
                                VStack {
                                    Text(channel.title)
                                }
                                .frame(width: UIScreen.main.bounds.width - 50)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor))
                            .foregroundColor(.white)
        //                        .frame(width: UIScreen.main.bounds.width - 20)
                            .cornerRadius(12)

                        }
                    }
                    
                    
                    
                    Text("BearChat Direct Messages")
                        .font(.largeTitle) // Makes the font larger and more prominent
                        .fontWeight(.bold) // Makes the text bold
                        .foregroundColor(.primary) // Uses the primary color, adaptable to light/dark mode
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5) // Adds some padding to the left to not stick to the edge
                    // Optionally, add vertical padding for spacing
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
                                    VStack {
                                        Text(channel.title)
                                    }
                                    .frame(width: UIScreen.main.bounds.width - 50)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor))
                                .foregroundColor(.white)
                                //                        .frame(width: UIScreen.main.bounds.width - 20)
                                .cornerRadius(12)
                                
                            }
                        }
                    }
                                    
                }
                .toolbar(.hidden)
                .padding(.leading, 0)

            }

        }
        
    }
}

#Preview {
    ChannelListView()
}
