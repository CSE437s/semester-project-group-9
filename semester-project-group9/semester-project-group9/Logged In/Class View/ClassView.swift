//
//  ClassView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/26/24.
//

import SwiftUI

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
            Text("Loading...")
                .task {
                    viewModel.fetchRoster()
                }
                .toolbar(.hidden)
        case .loading:
            Text("Loading...")
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
