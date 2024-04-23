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
import ActivityIndicatorView

struct RegistrationView: View {
    
    enum loadingState {
        case loading
        case loaded
    }

    @State private var currentLoadingState: loadingState = .loaded
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var firstMajor: String = ""
    @State private var secondMajor: String = ""
    @State private var graduationYear: String = ""
    @State private var validInput: Bool = true  // change this to false when input validation is implemented
    @State private var presentImport: Bool = false
    @AppStorage("email") var userEmail: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let years = ["2024", "2025", "2026", "2027", "2028"]
    
    let majors = ["Accounting", "African and African-American Studies", "American Culture Studies", "Ancient Studies", "Anthropology", "Anthropology: Global Health and Environment", "Applied Mathematics", "Applied Science (Chemical Engineering)", "Applied Science (Electrical Engineering)", "Applied Science (Mechanical Engineering)", "Applied Science (Systems Science & Engineering)", "Arabic", "Archaeology", "Architecture", "Art", "Art (Painting)", "Art (Photography)", "Art (Printmaking)", "Art (Sculpture)", "Art (Time-Based + Media Art)", "Art History and Archaeology", "Astrophysics", "Biology", "Biology: Ecology and Evolution", "Biology: Genomics and Computational Biology", "Biology: Microbiology", "Biology: Molecular Biology and Biochemistry", "Biology: Neuroscience", "Biomedical Engineering", "Business and Computer Science", "Chemical Engineering", "Chemistry", "Chemistry: Biochemistry", "Chinese Language and Culture", "Classics", "Communication Design", "Comparative Arts", "Comparative Literature", "Computer Engineering", "Computer Science", "Computer Science + Economics", "Computer Science + Mathematics", "Dance", "Data Science", "Design", "Design (Communication)", "Design (Fashion)", "Development/Global Studies", "Double Majors and the Pre-Medical Program (EECE)", "Drama", "Earth, Environmental, and Planetary Sciences: Earth Science", "Earth, Environmental, and Planetary Sciences: Environmental Science", "Earth, Environmental, and Planetary Sciences: Planetary Science", "East Asian Languages and Cultures", "Economics", "Economics and Computer Science", "Economics and Mathematics", "Economics and Strategy", "Educational Studies", "Electrical Engineering", "Elementary Teacher Education", "English Literature", "English Literature: Creative Writing", "English Literature: Publishing", "Entrepreneurship", "Environmental Analysis", "Environmental Biology", "Environmental Engineering", "Environmental Policy", "Eurasian Studies/Global Studies", "European Studies/Global Studies", "Fashion Design", "Film and Media Studies", "Film and Media Studies: Film and Media Production", "Finance", "Financial Engineering", "French", "Germanic Languages and Literatures", "Global Asias/Global Studies", "Global Cultural Studies/Global Studies", "Global Studies", "Health Care Management", "Hebrew", "History", "Individually Designed Major (BS in Engineering)", "Interdisciplinary Project in the Humanities", "International Affairs/Global Studies", "Italian", "Japanese Language and Culture", "Jewish, Islamic, and Middle Eastern Studies: Comparative Jewish & Islamic Studies", "Jewish, Islamic, and Middle Eastern Studies: Modern Middle Eastern Studies", "K-12 Teacher Education", "Korean Language and Culture", "Latin American Studies", "Linguistics", "Marketing", "Mathematical Sciences", "Mathematics", "Mathematics and Computer Science", "Mathematics and Economics", "Mechanical Engineering", "Middle School Teacher Education", "Music", "Organization and Strategic Management", "Philosophy", "Philosophy: Law and Policy", "Philosophy: Philosophy of Science", "Philosophy: Philosophy Research", "Philosophy-Neuroscience-Psychology: Cognitive Neuroscience", "Philosophy-Neuroscience-Psychology: Language, Cognition and Culture", "Physics", "Political Science", "Psychological & Brain Sciences", "Psychological & Brain Sciences: Cognitive Neuroscience", "Religious Studies", "Romance Languages and Literatures", "Secondary Teacher Education", "Sociology", "Spanish", "Statistics", "Supply Chain, Operations, and Technology", "Systems Science & Engineering", "Urban Studies", "Women, Gender, and Sexuality Studies"]
        
    
    var body: some View {
        
        switch currentLoadingState {
        case .loading:
            ActivityIndicatorView(isVisible: Binding.constant(true), type: .arcs(count: 5, lineWidth: 3))
                 .frame(width: 50.0, height: 50.0)
                 .foregroundColor(Color(hex: "32652F"))
                .toolbar(.hidden)
        case .loaded:
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
                        Text("Select graduation year")
                        ForEach(years, id: \.self) {
                            Text($0)
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    .padding()
                    
                    Text("Major:")
                        .padding(.leading)
                        .font(.caption)
                    
                    Picker("First Major", selection: $firstMajor){
                        Text("Select major")
                        ForEach(majors, id: \.self) {
                            Text($0)
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    .padding()
                    
                    Text("Second major (if applicable):")
                        .padding(.leading)
                        .font(.caption)
                    
                    Picker("Second Major", selection: $secondMajor){
                        Text("Select second major")
                        ForEach(majors, id: \.self) {
                            Text($0)
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    .padding()
                    
                }
                
                
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
                            .foregroundColor(.white)
                            .bold()
                            .font(Font.system(size: 24))
                            .padding(12)
                            .background(Color(hex: "32652F"))
                            .cornerRadius(12)

                    }
                    .navigationDestination(isPresented: $presentImport) {
                        // tutorial/import view
                        TutorialView()
                        
                    }
                    .padding()
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
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
                    currentLoadingState = .loaded
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
        currentLoadingState = .loading
        let password = UserDefaults.standard.string(forKey: "pass")!
        Auth.auth().createUser(withEmail: userEmail, password: password) { result, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
            } else if let result = result {
                print(result.user.uid)
                UserDefaults.standard.set(result.user.uid, forKey: "uid")
                UserDefaults.standard.set(userEmail, forKey: "email")
                UserDefaults.standard.set(firstName, forKey: "firstNme")
                UserDefaults.standard.synchronize()
                
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
