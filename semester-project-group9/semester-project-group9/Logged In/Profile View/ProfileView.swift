//
//  ProfileView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/26/24.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @State private var currentUser: User
    
    init(currentUser: User) {
        self.viewModel = ProfileViewModel(currentUser: currentUser)
        _currentUser = State(initialValue: currentUser)
    }
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            Text("Loading")
                .task {
                    viewModel.fecthUser()
                }
                .toolbar(.hidden)
        case .loading:
            Text("Loading...")
                .task {
                    viewModel.fecthUser()
                }
                .toolbar(.hidden)
        case .loaded(let user):
            VStack {
                Text(user.firstName + " " + user.lastName)
                Text("Graduation Year: " + user.graduationYear)
                Text("First Major: " + user.firstMajor)
                if user.secondMajor != "" {
                    Text("Second Major: " + user.secondMajor)
                }
                Button {
                    mailto(user.email)
                } label: {
                    Text("Email " + user.firstName + " " + user.lastName)
                }
            }
        }
    }
    
    func mailto(_ email: String) {
        let mailto = "mailto:\(email)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: mailto!)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
        }

    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
