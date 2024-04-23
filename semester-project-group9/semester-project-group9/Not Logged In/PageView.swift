//
//  PageView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 3/26/24.
//

import SwiftUI

struct PageView: View {
    
    @State private var classText: String = ""
    @State private var presentHome: Bool = false
    @State private var validInput: Bool = true // TODO: change to false when input validation is implemented
    @StateObject var viewModel: ImportViewModel = ImportViewModel()
    let webView = WebView(url: URL(string: "https://acadinfo.wustl.edu/m/")!)
    let urlString = "https://acadinfo.wustl.edu/m/"

    
    let page: PageData
    let imageWidth: CGFloat = 150
    let textWidth: CGFloat = 350
    
    var body: some View {
        
        if (page.content != "import") {
            return AnyView(VStack(alignment: .center, spacing: 50) {
                
                Text(page.title)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(page.textColor)
                    .frame(width: textWidth)
                    .multilineTextAlignment(.center)
                VStack(alignment: .center, spacing: 5) {
                    Text(page.header)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(page.textColor)
                        .frame(width: 300, alignment: .center)
                        .multilineTextAlignment(.center)
                    Text(page.content)
                        .font(Font.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(page.textColor)
                        .frame(width: 300, alignment: .center)
                        .multilineTextAlignment(.center)
                }
            })

        } else {
            return AnyView(VStack {
                
                Text(page.title)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(page.textColor)
                    .frame(width: textWidth)
                    .multilineTextAlignment(.center)
                
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
                        .foregroundColor(.white)
                        .bold()
                        .font(Font.system(size: 24))
                        .padding(12)
                        .background(Color(hex: "32652F"))
                        .cornerRadius(12)
                }
                .navigationDestination(isPresented: $presentHome) {
                    ConfirmClassesView(viewModel: viewModel)
                }
            })

        }
        
        
    }
}

