//
//  RegistrationView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/25/24.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

struct RegistrationView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var firstMajor: String = ""
    @State private var secondMajor: String = ""
    @State private var graduationYear: String = ""
    @State private var validInput: Bool = true  // change this to false when input validation is implemented
    @State private var presentImport: Bool = false
    @AppStorage("uid") var userID: String = ""
    @AppStorage("email") var userEmail: String = ""
    
    
    var body: some View {
        
        VStack {
            
            
            Text("Register Account")
                .padding()
            
            Spacer()
            
            TextField("First Name", text: $firstName)
                .padding()
            TextField("Last Name", text: $lastName)
                .padding()
            
            TextField("Graduation Year", text: $graduationYear)
                .padding()
            
            TextField("Major", text: $firstMajor)
                .padding()
            
            TextField("Second Major (if applicable)", text: $secondMajor)
                .padding()
            
            
            Spacer()
            
            Button {
                if validInput {
                    // create user profile data and upload to database
                    storeUserInformation()
                    presentImport = true
                }
            } label : {
                Text("Proceed to Class Import")
            }
            .navigationDestination(isPresented: $presentImport) {
                // tutorial/import view
                TutorialView()
            }
            .padding()
            .background(.gray)
            .cornerRadius(12)
            .foregroundColor(.white)
            
            // TODO: Input validation (if all inputs are valid [no fields empty, graduation year is somewhere between 2024-2030], set the validInput to be true)
            
            
        }
        .toolbar(.hidden)
    }
    
    private func storeUserInformation() {
        let userData = ["email" : userEmail, "uid" : userID, "firstname" : firstName, "lastname" : lastName, "firstmajor" : firstMajor, "secondmajor" : secondMajor, "graduationyear" : graduationYear]
        
        Firestore.firestore().collection("users").document(userEmail).setData(userData as [String : Any]) { err in
            if let err = err {
                print(err)
                return
            }
            print("success")
        }
    }
    
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
