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
    @StateObject var viewModel: ImportViewModel = ImportViewModel()
    let webView = WebView(url: URL(string: "https://acadinfo.wustl.edu/m/")!)
    
    var body: some View {
        
        VStack {
            
            Text("Paste WebSTAC output starting from 'Class Schedule' to the room number of your last class, and below:")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .frame(width: 350)
                .multilineTextAlignment(.center)
                .padding()
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $classText)
                    .padding(4)
                    .frame(height: 200)
                    .border(Color.gray, width: 1)
                    .cornerRadius(5)
                            
                if classText.isEmpty {
                    Text("Enter your classes here...")
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                        .padding(.top, 8)
                        .padding(.horizontal)
                }
                    }
                    .padding(.horizontal)
            Button {
                if validInput {
                    // import classes
                    viewModel.parseInput(classInput: classText)
                    presentHome = true
                }
            } label: {
                Text("Import classes!")
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .navigationDestination(isPresented: $presentHome) {
                ConfirmClassesView(viewModel: viewModel)
            }
        }
    }
}

struct ImportClassesView_Previews: PreviewProvider {
    static var previews: some View {
        ImportClassesView()
    }
}
