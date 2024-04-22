//
//  LoggedInView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/25/24.
//

import ActivityIndicatorView
import SwiftUI
import Firebase
import FirebaseAuth

struct LoggedInView: View {
    @StateObject var viewModel: LoggedInHomeViewModel = LoggedInHomeViewModel()
    @State var showContentView: Bool = false
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            ActivityIndicatorView(isVisible: Binding.constant(true), type: .arcs(count: 5, lineWidth: 3))
                 .frame(width: 50.0, height: 50.0)
                 .foregroundColor(Color(hex: "32652F"))
                 .task {
                    viewModel.fetchClasses()
                }
                .toolbar(.hidden)
        case .loading:
            ActivityIndicatorView(isVisible: Binding.constant(true), type: .arcs(count: 5, lineWidth: 3))
                 .frame(width: 50.0, height: 50.0)
                 .foregroundColor(Color(hex: "32652F"))
                 .task {
                    viewModel.fetchClasses()
                }
                .toolbar(.hidden)
        case .loaded(let courseList):
            VStack {
                Text("Your Classes")
                    .font(.largeTitle) // Makes the font larger and more prominent
                    .fontWeight(.bold) // Makes the text bold
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5) // Adds some padding to the left to not stick to the edge
                    .foregroundStyle(Color(hex: "32652F"))
                    .padding()
                
                Spacer()
                
                ScrollView {
                    ForEach(courseList) { course in
                        NavigationLink {
                            ClassView(currentClass: course)
                        } label: {
                            
                            ClassCard(course: course)
                            
//                            VStack {
//                                Text(course.name)
//                                HStack {
//                                    Text(course.days)
//                                    Text(course.times)
//                                }
//                                Text(course.building_room)
//                            }
//                            .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12))
                        .foregroundColor(.white)
//                        .frame(width: UIScreen.main.bounds.width - 20)
                        .cornerRadius(12)

                    }
                }
                                
            }
            .toolbar(.hidden)
            .padding(.leading, 0)
        }
    }
        
}

struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView()
    }
}

