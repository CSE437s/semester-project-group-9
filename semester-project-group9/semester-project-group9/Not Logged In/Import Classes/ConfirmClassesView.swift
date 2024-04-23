//
//  ConfirmClassesView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 4/2/24.
//

import SwiftUI

struct ConfirmClassesView: View {
    
    @ObservedObject var viewModel: ImportViewModel
    @State var presentHome = false
        
    var body: some View {
        VStack {
            Text("Are these your correct classes?")
                .font(.largeTitle) // Makes the font larger and more prominent
                .fontWeight(.bold) // Makes the text bold
                .foregroundColor(.primary) // Uses the primary color, adaptable to light/dark mode
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 5) // Adds some padding to the left to not stick to the edge
            // Optionally, add vertical padding for spacing
                .padding()
            Spacer()
            Text("If not, navigate back and re-input your course schedule")
                .font(.title)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 5)
                .padding()
            Spacer()
            
            ScrollView {
                ForEach(viewModel.classes) { course in
                    
                    ClassCard(course: course)
                    
//                    VStack {
//                        Text(course.name)
//                        HStack {
//                            Text(course.days)
//                            Text(course.times)
//                        }
//                        Text(course.building_room)
//                    }
//                    .frame(width: UIScreen.main.bounds.width - 50)
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor))
//                    .foregroundColor(.white)
////                        .frame(width: UIScreen.main.bounds.width - 20)
//                    .cornerRadius(12)

                }
            }
            
            Button {
                // import classes
                viewModel.postClasses()
                presentHome = true
            } label: {
                Text("Yes, these are my classes. Import now!")
                    .foregroundColor(.white)
                    .bold()
                    .font(Font.system(size: 24))
                    .padding(12)
                    .background(Color(hex: "32652F"))
                    .cornerRadius(12)
            }
            .navigationDestination(isPresented: $presentHome) {
                MainView()
            }

                            
        }
        .padding(.leading, 0)
    }
}

//#Preview {
//    ConfirmClassesView()
//}
