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
