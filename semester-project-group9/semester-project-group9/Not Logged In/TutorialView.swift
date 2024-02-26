//
//  TutorialView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/25/24.
//

import SwiftUI

struct TutorialView: View {
    var body: some View {
        TabView {
            
            //log into webstac and navigate to class schedule
            VStack {
                Text("Log into WebSTAC and navigate to your Class Schedule")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            //select all text and paste into box
            
            VStack {
                Text("Select all text starting from the name of your first class to the room number of your last class, copy and paste it into the text field and hit 'Submit'")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            //import view
            ImportClassesView()
            
            
        }
        .tabViewStyle(.page)
        .toolbar(.hidden)

    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
