//
//  ContentView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/6/24.
//

import SwiftUI
import FirebaseAuth
import Firebase

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
            ZStack {
                VStack {
                    Spacer()
                    
                    Text("WashU PeerLink")
                        .font(.largeTitle) // Makes the font larger and more prominent
                        .fontWeight(.bold) // Makes the text bold
                        .foregroundStyle(Color(hex: "32652F")) // Uses the primary color, adaptable to light/dark mode
                        .frame(width: 350)
                        .padding()
                    
                    Spacer()
                    
                    VStack {
                        Text("Welcome! Sign up or log in using your @wustl.edu email below:")
                            .padding()
                            .foregroundStyle(Color(hex: "32652F"))
                            .frame(width: 350)
                        
                        TextField("WUSTL Email", text: $email)
                            .textInputAutocapitalization(.never)
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
                        Button {
                            // Call register which includes validation, registration, and conditional navigation
                            register()
                        } label: {
                            Text("Register!")
                                .foregroundColor(.white)
                                .bold()
                                .font(Font.system(size: 24))
                                .padding()
                                .background(Color(hex: "32652F"))
                                .cornerRadius(12)
                            
                        }
                        .padding()
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .navigationDestination(isPresented: $presentRegistration) {
                            RegistrationView()
                        }
                        
                        
                        Button {
                            login()
                        } label : {
                            Text("Login!")
                                .foregroundColor(.white)
                                .bold()
                                .font(Font.system(size: 24))
                                .padding()
                                .background(Color(hex: "32652F"))
                                .cornerRadius(12)

                        }
                        .navigationDestination(isPresented: $presentLogin) {
                            //logged in view
                            MainView()
                        }
                        .padding()
                        .cornerRadius(12)
                        .foregroundColor(.white)

                    }
                    .padding()
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width * 0.95)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    

                    
                    Spacer()
                    
                    
                    
                    Spacer()
                    
                    // TODO: Implement input validation-- email/password not empty, email is valid (contains @wustl.edu)
                    
                }

            }
            .background(
                Image("washu")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .opacity(0.2)
            )

            
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
            
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(password, forKey: "pass")
            presentRegistration = true
            
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
                
                let docRef = Firestore.firestore().collection("users").whereField("email", isEqualTo: email)
                
                docRef.getDocuments { (result, err) in
                    if let err = err {
                        print(err.localizedDescription)
                    } else {
                        let document = result!.documents.first
                        let dataDescription = document!.data()
                        let firstName = dataDescription["firstname"] as? String ?? ""
                        let lastName = dataDescription["lastname"] as? String ?? ""
                        let email = dataDescription["email"] as? String ?? ""
                        let firstMajor = dataDescription["firstmajor"] as? String ?? ""
                        let secondMajor = dataDescription["secondmajor"] as? String ?? ""
                        let gradYear = dataDescription["graduationyear"] as? String ?? ""
                        let user = User(firstName: firstName, lastName: lastName, email: email, firstMajor: firstMajor, secondMajor: secondMajor, graduationYear: gradYear)
                        do {
                            let encoder = JSONEncoder()
                            
                            let data = try encoder.encode(user)
                            UserDefaults.standard.set(data, forKey: "currentUser")
                        } catch {
                            print("unable to encode: \(error)")
                        }
                        
                    }
                }
                
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
