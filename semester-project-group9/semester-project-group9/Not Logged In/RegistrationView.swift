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
    @State private var graduationYear: String = "2024"
    @State private var validInput: Bool = true  // change this to false when input validation is implemented
    @State private var presentImport: Bool = false
    @AppStorage("email") var userEmail: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let years = ["2024", "2025", "2026", "2027", "2028"]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            
            Group {
                Text("Register Account")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .font(.title)
                
                //Spacer()
                
                
                Text("First Name:")
                    .padding(.leading)
                    .font(.caption)
                
                TextField("First Name", text: $firstName)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5) // Defines the shape of the outline
                            .stroke(Color.gray, lineWidth: 1) // Sets the color and line width of the outline
                    )
                    .padding()
                
                
                Text("Last Name:")
                    .padding(.leading)
                    .font(.caption)
                TextField("Last Name", text: $lastName)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5) // Defines the shape of the outline
                            .stroke(Color.gray, lineWidth: 1) // Sets the color and line width of the outline
                    )
                    .padding()
                
                
                Text("Graduation year:")
                    .padding(.leading)
                    .font(.caption)
//                TextField("Graduation Year", text: $graduationYear)
//                    .padding()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5) // Defines the shape of the outline
//                            .stroke(Color.gray, lineWidth: 1) // Sets the color and line width of the outline
//                    )
//                    .padding()
                
                Picker("Graduation Year", selection: $graduationYear){
                    ForEach(years, id: \.self) {
                        Text($0)
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                .padding()
                
            }
            Text("Major:")
                .padding(.leading)
                .font(.caption)
            TextField("Major", text: $firstMajor)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5) // Defines the shape of the outline
                        .stroke(Color.gray, lineWidth: 1) // Sets the color and line width of the outline
                )
                .padding()
            
            Text("Second Major (if applicable):")
                .padding(.leading)
                .font(.caption)
            TextField("Second Major (if applicable)", text: $secondMajor)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5) // Defines the shape of the outline
                        .stroke(Color.gray, lineWidth: 1) // Sets the color and line width of the outline
                )
                .padding()
            
            
            
            
            VStack {
                Spacer()
                
                Button {
                    if validInput {
                        // create user profile data and upload to database
                        register()
                        //                    presentImport = true
                    }
                } label : {
                    Text("Proceed to Class Import")
                }
                .navigationDestination(isPresented: $presentImport) {
                    // tutorial/import view
                    TutorialView()
                    
                }
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                .background(Color.accentColor)
                .cornerRadius(12)
                .foregroundColor(.white)
                Spacer()
                
                
                // TODO: Input validation (if all inputs are valid [no fields empty, graduation year is somewhere between 2024-2030], set the validInput to be true)
                
                
                
                    .toolbar(.hidden)
                    .alert("Invalid Input", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                message: {
                    Text(alertMessage)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
    }
    
    private func storeUserInformation() {
        if !firstName.isEmpty && !lastName.isEmpty && !graduationYear.isEmpty && !firstMajor.isEmpty {
            if Int(graduationYear)! <= 2030 && Int(graduationYear)! >= 2024 {
                let userData = ["email" : userEmail, "firstname" : firstName, "lastname" : lastName, "firstmajor" : firstMajor, "secondmajor" : secondMajor, "graduationyear" : graduationYear]
                
                Firestore.firestore().collection("users").document(userEmail).setData(userData as [String : Any]) { err in
                    if let err = err {
                        print(err)
                        return
                    }
                    print("success")
                    let user = User(firstName: firstName, lastName: lastName, email: userEmail, firstMajor: firstMajor, secondMajor: secondMajor, graduationYear: graduationYear)
                    do {
                        let encoder = JSONEncoder()
                        
                        let data = try encoder.encode(user)
                        UserDefaults.standard.set(data, forKey: "currentUser")
                    } catch {
                        print("unable to encode: \(error)")
                    }
                    presentImport = true
                }
            }
            else {
                alertMessage = "Please enter a valid graduation year."
                showingAlert = true
            }
        }
        else {
            alertMessage = "Please enter all fields."
            showingAlert = true
        }
        
    }
    
    private func register() {
        let password = UserDefaults.standard.string(forKey: "pass")!
        Auth.auth().createUser(withEmail: userEmail, password: password) { result, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
            } else if let result = result {
                print(result.user.uid)
                UserDefaults.standard.set(result.user.uid, forKey: "uid")
                UserDefaults.standard.set(userEmail, forKey: "email")
                // Proceed with info storage only after successful registration
                DispatchQueue.main.async {
                    storeUserInformation()
                }
                
            }
        }

    }
    
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
