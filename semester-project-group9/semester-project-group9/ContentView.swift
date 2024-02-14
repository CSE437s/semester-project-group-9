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
    
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome! Sign up or log in using your @wustl.edu email below:")
                .padding()
                .frame(width: 350)
            
            TextField("WUSTL Email", text: $email)
                .frame(width: 350)
                .padding()
            
            SecureField("Password", text: $password)
                .frame(width: 350)
                .padding()
            
            Spacer()
            
            Button {
                //register action
                register()
            } label: {
                Text("Register")
                    .buttonStyle(.plain)
            }
            Button {
                //login action
                login()
            } label: {
                Text("Login")
                    .buttonStyle(.plain)
            }
            Spacer()
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("registered user")
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
