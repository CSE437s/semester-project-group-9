//
//  ProfileView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/26/24.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @State private var currentUser: User
    @State var alertMessage = ""
    @State var showingAlert = false
    
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
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.largeTitle)
                
                Text("Graduation Year: " + user.graduationYear)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .font(.title3)
                
                Text("Majoring in " + user.firstMajor)
                if user.secondMajor != "" {
                    Text("Second Major: " + user.secondMajor)
                }
                
                HStack {
                    Image(systemName: "message")
                        .resizable() // Allows you to resize the image
                        .scaledToFit() // Ensures the image scales properly within its frame
                        .frame(width: 20, height: 20) // Adjust the size of the icon as needed
                    Button {
                        createDM(user: user)
                        alertMessage = "DM with \(user.firstName) \(user.lastName) created. Find it in your BearChat channel list!"
                        showingAlert = true
                    } label: {
                        Text("Direct Message " + user.firstName + " " + user.lastName)
                    }
                    .alert("Direct Message Created", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                message: {
                    Text(alertMessage)
                }
                }
            }
        }
    }
        
    func createDM(user: User) {
        let db = Firestore.firestore()
        
        db.collection("channels").addDocument(data: ["title" : "\(user.email) & \(UserDefaults.standard.string(forKey: "email")!)", "joinCode": "\(user.email)\(UserDefaults.standard.string(forKey: "email")!)", "users" : [user.email, UserDefaults.standard.string(forKey: "email")]]) { err in
            if let err = err {
                print("error adding document: \(err)")
            } else {
                print("great success")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(currentUser: User(firstName: "Jane",
                                      lastName: "Doe",
                                      email: "2024",
                                      firstMajor: "Computer Science",
                                      secondMajor: "Mathematics",
                                      graduationYear: "jane.doe@example.com"))
    }
}
