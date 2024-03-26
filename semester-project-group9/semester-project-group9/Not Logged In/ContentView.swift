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
    @State private var showingAlert = false
    @State private var alertMessage = "Please use your @wustl.edu email to register."

    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                                
                Text("WashU PeerLink")
                    .font(.largeTitle) // Makes the font larger and more prominent
                    .fontWeight(.bold) // Makes the text bold
                    .foregroundColor(.primary) // Uses the primary color, adaptable to light/dark mode
                    .frame(width: 350)
                    .padding()
                
                Spacer()
                
                Text("Welcome! Sign up or log in using your @wustl.edu email below:")
                    .padding()
                    .frame(width: 350)
                
                TextField("WUSTL Email", text: $email)
                    .frame(width: 300, height: 10)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 1)
                    )

                SecureField("Password", text: $password)
                    .frame(width: 300, height: 10)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 1)
                    )
                
                Spacer()
                
                Button {
                    // Call register which includes validation, registration, and conditional navigation
                    register()
                } label: {
                    Text("Register")
                }
                .padding()
                .background(Color.accentColor)
                .cornerRadius(12)
                .foregroundColor(.white)
                .navigationDestination(isPresented: $presentRegistration) {
                    RegistrationView()
                }


                Button {
                    login()
                } label : {
                    Text("Login")
                }
                    .navigationDestination(isPresented: $presentLogin) {
                        //logged in view
                        MainView()
                    }
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                Spacer()
                
                // TODO: Implement input validation-- email/password not empty, email is valid (contains @wustl.edu)
                
            }
            
        }
        .toolbar(.hidden)
        .alert("Invalid Input", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        message: {
            Text(alertMessage)
        }
        
    }
    
    func register() {
        if email.isEmpty{
            alertMessage = "Please enter an email."
            showingAlert = true
            return
        }
        if password.isEmpty{
            alertMessage = "Please enter a password."
            showingAlert = true
            return
        }
        if password.count < 6 {
            alertMessage = "Password must be more than 6 characters."
            showingAlert = true
            return
        }

        if email.hasSuffix("@wustl.edu") {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    alertMessage = error.localizedDescription
                    showingAlert = true
                } else if let result = result {
                    print(result.user.uid)
                    UserDefaults.standard.set(result.user.uid, forKey: "uid")
                    UserDefaults.standard.set(email, forKey: "email")
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
        if email.isEmpty{
            alertMessage = "Please enter an email."
            showingAlert = true
            return
        }
        
        if password.isEmpty{
            alertMessage = "Please enter a password."
            showingAlert = true
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                alertMessage = error!.localizedDescription
                showingAlert = true
            } else if let result = result {
                UserDefaults.standard.set(result.user.uid, forKey: "uid")
                UserDefaults.standard.set(email, forKey: "email")
                DispatchQueue.main.async {
                    presentLogin = true
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
