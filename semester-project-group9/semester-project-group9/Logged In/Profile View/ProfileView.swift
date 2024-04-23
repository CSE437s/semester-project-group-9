//
//  ProfileView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/26/24.
//

import SwiftUI
import Firebase
import ActivityIndicatorView

struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @State private var currentUser: User
    @State var alertMessage = ""
    @State var showingAlert = false
    @State var showContentView = false
    
    init(currentUser: User) {
        self.viewModel = ProfileViewModel(currentUser: currentUser)
        _currentUser = State(initialValue: currentUser)
    }
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            ActivityIndicatorView(isVisible: Binding.constant(true), type: .arcs(count: 5, lineWidth: 3))
                 .frame(width: 50.0, height: 50.0)
                 .foregroundColor(Color(hex: "32652F"))
                 .task {
                    viewModel.fecthUser()
                }
                .toolbar(.hidden)
        case .loading:
            ActivityIndicatorView(isVisible: Binding.constant(true), type: .arcs(count: 5, lineWidth: 3))
                 .frame(width: 50.0, height: 50.0)
                 .foregroundColor(Color(hex: "32652F"))
                 .task {
                    viewModel.fecthUser()
                }
                .toolbar(.hidden)
        case .loaded(let user):
            VStack {
                VStack {
                    Rectangle()
                        .foregroundColor(Color(hex: "32652F"))
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 100)
                    VStack(spacing: 15) {
                                VStack(spacing: 5) {
                                    Text("\(user.firstName) \(user.lastName)")
                                        .bold()
                                        .font(.title)
                                    Text("\(user.graduationYear)")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                    Text("First Major: \(user.firstMajor)")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                    if user.secondMajor != "" {
                                        Text("Second Major: \(user.secondMajor)")
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                    }

                                }.padding()
                        
                        if (UserDefaults.standard.string(forKey: "email") != user.email) {
                            Button {
                                createDM(user: user)
                                alertMessage = "DM with \(user.firstName) \(user.lastName) created. Find it in your BearChat channel list!"
                                showingAlert = true
                            } label: {
                                Text("Direct Message " + user.firstName + " " + user.lastName)
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(Font.system(size: 24))
                                    .padding(12)
                                    .background(Color(hex: "32652F"))
                                    .cornerRadius(12)

                            }
                            .alert("Direct Message Created", isPresented: $showingAlert) {
                                Button("OK", role: .cancel) { }
                            }
                            message: {
                                Text(alertMessage)
                            }
                        } else {
  
                            Button {
                                signOut()
                            } label: {
                                Text("Sign out")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(Font.system(size: 24))
                                    .padding(12)
                                    .background(Color(hex: "32652F"))
                                    .cornerRadius(12)
                            }
                            .fullScreenCover(isPresented: $showContentView, onDismiss: nil) {
                                ContentView()
                            }
                        }
                                
                                Spacer()
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
    
    func signOut() {
        do  {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "uid")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "currentUser")
            DispatchQueue.main.async {
                showContentView = true
            }

        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
