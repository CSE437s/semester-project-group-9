//
//  MainView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 3/26/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            LoggedInView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            ChannelListView()
                .tabItem {
                    Label("BearChat", systemImage: "bubble.left.and.text.bubble.right.fill")
                }
        }
    }
}

/*#Preview {
    MainView()
}
*/
