//
//  ImportClassesView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/25/24.
//

import SwiftUI

struct ImportClassesView: View {
    
    @State private var classText: String = ""
    @State private var presentHome: Bool = false
    @State private var validInput: Bool = true // TODO: change to false when input validation is implemented
    @ObservedObject var viewModel: ImportViewModel = ImportViewModel()
    
    var body: some View {
        
        VStack {
            Text("Paste WebSTAC output below:")
                .padding()
            TextField("Paste here...", text: $classText)
                .padding()
            Button {
                if validInput {
                    // import classes
                    viewModel.postClasses(userInput: classText)
                    presentHome = true
                }
            } label: {
                Text("Import classes!")
                    .padding()
                    .background(.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .navigationDestination(isPresented: $presentHome) {
                LoggedInView()
            }
        }
    }
}

struct ImportClassesView_Previews: PreviewProvider {
    static var previews: some View {
        ImportClassesView()
    }
}
