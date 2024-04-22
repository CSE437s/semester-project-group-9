//
//  ClassView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/26/24.
//

import SwiftUI
import ActivityIndicatorView

struct ClassView: View {
    
    @ObservedObject var viewModel: ClassViewModel
    @State private var currentClass: Class
    
    init(currentClass: Class) {
        self.viewModel = ClassViewModel(currentClass: currentClass)
        _currentClass = State(initialValue: currentClass)
        viewModel.fetchChannel()
    }
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            ActivityIndicatorView(isVisible: Binding.constant(true), type: .arcs(count: 5, lineWidth: 3))
                 .frame(width: 50.0, height: 50.0)
                 .foregroundColor(Color(hex: "32652F"))
                 .task {
                    viewModel.fetchRoster()
                }
                .toolbar(.hidden)
        case .loading:
            ActivityIndicatorView(isVisible: Binding.constant(true), type: .arcs(count: 5, lineWidth: 3))
                 .frame(width: 50.0, height: 50.0)
                 .foregroundColor(Color(hex: "32652F"))
                 .task {
                    viewModel.fetchRoster()
                }
                .toolbar(.hidden)
        case .loaded(let roster):
            VStack {
                Text(currentClass.name)
                Text("Class Times: \(currentClass.days) \(currentClass.times)")
                Text("Location: \(currentClass.building_room)")
                NavigationLink {
                    ChatView(channel: viewModel.classChannel[0])
                } label: {
                    VStack {
                        Text("Class Chatroom")
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor))
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 20)
                .cornerRadius(12)
                
                List {
                    ForEach(roster) { classmate in
                        NavigationLink {
                            ProfileView(currentUser: classmate)
                        } label: {
                            Text(classmate.firstName + " " + classmate.lastName)
                        }
                    }
                }
            }
        }
    }
}
//
//struct ClassView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassView(currentClass: "test")
//    }
//}
