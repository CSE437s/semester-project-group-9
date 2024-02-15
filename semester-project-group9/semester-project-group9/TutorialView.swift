//
//  TutorialView.swift
//  semester-project-group9
//
//  Created by Adam Schwartz on 2/14/24.
//
//

import SwiftUI
import FirebaseAuth

struct TutorialView: View {
    
    
    var body: some View {
        VStack {
            Text("Welcome!").bold()
                
            Text("\n Open WebSTAC and copy your schedule")
                .multilineTextAlignment(.center)
                
            Image("screenshot")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(10)
            Spacer()
            
            Button(action: {
                            // Action for the button goes here
                            print("Next button tapped")
                        }) {
                            HStack {
                                Text("Next")
                                Image(systemName: "arrow.right")
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        .padding()
        }
        .padding()
    }
    
    
    
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
