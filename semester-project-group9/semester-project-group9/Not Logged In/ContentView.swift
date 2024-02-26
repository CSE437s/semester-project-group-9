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
    @State private var showingAlert = false
    @State private var alertMessage = "Please use your @wustl.edu email to register."

    
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
                    // Call register which includes validation, registration, and conditional navigation
                    register()
                } label: {
                    Text("Register")
                }
                .padding()
                .background(.gray)
                .cornerRadius(12)
                .foregroundColor(.white)
                .navigationDestination(isPresented: $presentRegistration) {
                    RegistrationView()
                }


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
        .alert("Invalid Email", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        message: {
            Text(alertMessage)
        }
        
    }
    
    func register() {
        if email.hasSuffix("@wustl.edu") {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    alertMessage = error.localizedDescription
                    showingAlert = true
                } else if let result = result {
                    print(result.user.uid)
                    userID = result.user.uid
                    userEmail = email
                    // Proceed with navigation only after successful registration
                    DispatchQueue.main.async {
                        presentRegistration = true
                        
                    }
                    
                }
            }
        } else {
            alertMessage = "Please use your @wustl.edu email to register."
            showingAlert = true
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
