//
//  ContentView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/6/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var validInput: Bool = true // change this to false when input validation is implemented
    @State private var presentRegistration: Bool = false
    @State private var presentLogin: Bool = false
    @AppStorage("uid") var userID: String = ""
    @AppStorage("email") var userEmail: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Welcome! Sign up or log in using your @wustl.edu email below:")
                    .padding()
                    .frame(width: 350)
                
                TextField("WUSTL Email", text: $email)
                    .frame(width: 350)
                    .padding()
                
                // TODO: Input validation (check if empty)
                SecureField("Password", text: $password)
                    .frame(width: 350)
                    .padding()
                
                Spacer()
                
                Button {
                    if validInput {
                        presentRegistration = true
                        register()
                    }
                } label : {
                    Text("Register")
                }
                    .navigationDestination(isPresented: $presentRegistration) {
                        RegistrationView()
                    }
                    .padding()
                    .background(.gray)
                    .cornerRadius(12)
                    .foregroundColor(.white)

                Button {
                    if validInput {
                        presentLogin = true
                        login()
                    }
                } label : {
                    Text("Login")
                }
                    .navigationDestination(isPresented: $presentLogin) {
                        //logged in view
                        LoggedInView()
                    }
                    .padding()
                    .background(.gray)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                Spacer()
                
                // TODO: Implement input validation-- email/password not empty, email is valid (contains @wustl.edu)
                
            }
        }
        .toolbar(.hidden)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let result = result {
                print(result.user.uid)
                userID = result.user.uid
                userEmail = email
            }
            
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("logged in")
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
