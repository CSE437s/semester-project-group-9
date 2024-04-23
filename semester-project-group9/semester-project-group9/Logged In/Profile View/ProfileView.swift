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
    @State var newGradYear = ""
    @State var editing = false
    @State var newFirstMajor = ""
    @State var newSecondMajor = ""
    //    @State var showChannelView = false
    
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
                    
                    if (UserDefaults.standard.string(forKey: "email") != user.email) {
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
                            
                            Button {
                                createDM(user: user)
                                //                                showChannelView = true
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
                            //                            .fullScreenCover(isPresented: $showChannelView, onDismiss: nil) {
                            //                                ChannelListView()
                            //                            }
                            .alert("Direct Message Created", isPresented: $showingAlert) {
                                Button("OK", role: .cancel) { }
                                NavigationLink("Go to Messages"){
                                    ChannelListView(navigatedFromProfile: true)
                                }
                            }
                        message: {
                            Text(alertMessage)
                        }
                            
                            Spacer()
                        }
                        
                    } else {
                        // viewing own profile, editable
                        VStack(spacing: 15) {
                            VStack(spacing: 5) {
                                Text("\(user.firstName) \(user.lastName)")
                                    .bold()
                                    .font(.title)
                                
                                if editing {
                                    Picker("Graduation Year", selection: $newGradYear){
                                        Text("Select graduation year")
                                        ForEach(ProfileView.years, id: \.self) {
                                            Text($0)
                                        }
                                        .pickerStyle(WheelPickerStyle())
                                    }
                                    .padding()
                                    
                                    Picker("First Major", selection: $newFirstMajor){
                                        Text("Select major")
                                        ForEach(ProfileView.majors, id: \.self) {
                                            Text($0)
                                        }
                                        .pickerStyle(WheelPickerStyle())
                                    }
                                    .padding()
                                    
                                    Text("Second major (if applicable):")
                                        .padding(.leading)
                                        .font(.caption)
                                    
                                    Picker("Second Major", selection: $newSecondMajor){
                                        Text("Select second major")
                                        ForEach(ProfileView.majors, id: \.self) {
                                            Text($0)
                                        }
                                        .pickerStyle(WheelPickerStyle())
                                    }
                                    .padding()
                                    
                                } else {
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
                                    
                                }
                                
                            }.padding()
                            
                            Button {
                                if (editing) {
                                    //find edited fields, pass them into updateUser
                                    var editedFields: [String : String] = [:]
                                    if (!newGradYear.isEmpty) {
                                        editedFields["graduationyear"] = newGradYear
                                    }
                                    if (!newFirstMajor.isEmpty) {
                                        editedFields["firstmajor"] = newFirstMajor
                                    }
                                    if (!newSecondMajor.isEmpty) {
                                        editedFields["secondmajor"] = newSecondMajor
                                    }
                                    viewModel.updateUser(newData: editedFields, completion: {
                                        editing = false
                                    })
                                } else {
                                    editing = true
                                }
                            } label: {
                                if editing {
                                    Text("Save Changes")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(Font.system(size: 24))
                                        .padding(12)
                                        .background(Color(hex: "32652F"))
                                        .cornerRadius(12)
                                } else {
                                    Text("Edit Profile")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(Font.system(size: 24))
                                        .padding(12)
                                        .background(Color(hex: "32652F"))
                                        .cornerRadius(12)
                                }
                            }
                            
                            if editing {
                                Button {
                                    editing = false
                                } label: {
                                    Text("Cancel Changes")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(Font.system(size: 24))
                                        .padding(12)
                                        .background(Color(hex: "32652F"))
                                        .cornerRadius(12)
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

extension ProfileView {
    static let years = ["2024", "2025", "2026", "2027", "2028"]
    
    static let majors = ["Accounting", "African and African-American Studies", "American Culture Studies", "Ancient Studies", "Anthropology", "Anthropology: Global Health and Environment", "Applied Mathematics", "Applied Science (Chemical Engineering)", "Applied Science (Electrical Engineering)", "Applied Science (Mechanical Engineering)", "Applied Science (Systems Science & Engineering)", "Arabic", "Archaeology", "Architecture", "Art", "Art (Painting)", "Art (Photography)", "Art (Printmaking)", "Art (Sculpture)", "Art (Time-Based + Media Art)", "Art History and Archaeology", "Astrophysics", "Biology", "Biology: Ecology and Evolution", "Biology: Genomics and Computational Biology", "Biology: Microbiology", "Biology: Molecular Biology and Biochemistry", "Biology: Neuroscience", "Biomedical Engineering", "Business and Computer Science", "Chemical Engineering", "Chemistry", "Chemistry: Biochemistry", "Chinese Language and Culture", "Classics", "Communication Design", "Comparative Arts", "Comparative Literature", "Computer Engineering", "Computer Science", "Computer Science + Economics", "Computer Science + Mathematics", "Dance", "Data Science", "Design", "Design (Communication)", "Design (Fashion)", "Development/Global Studies", "Double Majors and the Pre-Medical Program (EECE)", "Drama", "Earth, Environmental, and Planetary Sciences: Earth Science", "Earth, Environmental, and Planetary Sciences: Environmental Science", "Earth, Environmental, and Planetary Sciences: Planetary Science", "East Asian Languages and Cultures", "Economics", "Economics and Computer Science", "Economics and Mathematics", "Economics and Strategy", "Educational Studies", "Electrical Engineering", "Elementary Teacher Education", "English Literature", "English Literature: Creative Writing", "English Literature: Publishing", "Entrepreneurship", "Environmental Analysis", "Environmental Biology", "Environmental Engineering", "Environmental Policy", "Eurasian Studies/Global Studies", "European Studies/Global Studies", "Fashion Design", "Film and Media Studies", "Film and Media Studies: Film and Media Production", "Finance", "Financial Engineering", "French", "Germanic Languages and Literatures", "Global Asias/Global Studies", "Global Cultural Studies/Global Studies", "Global Studies", "Health Care Management", "Hebrew", "History", "Individually Designed Major (BS in Engineering)", "Interdisciplinary Project in the Humanities", "International Affairs/Global Studies", "Italian", "Japanese Language and Culture", "Jewish, Islamic, and Middle Eastern Studies: Comparative Jewish & Islamic Studies", "Jewish, Islamic, and Middle Eastern Studies: Modern Middle Eastern Studies", "K-12 Teacher Education", "Korean Language and Culture", "Latin American Studies", "Linguistics", "Marketing", "Mathematical Sciences", "Mathematics", "Mathematics and Computer Science", "Mathematics and Economics", "Mechanical Engineering", "Middle School Teacher Education", "Music", "Organization and Strategic Management", "Philosophy", "Philosophy: Law and Policy", "Philosophy: Philosophy of Science", "Philosophy: Philosophy Research", "Philosophy-Neuroscience-Psychology: Cognitive Neuroscience", "Philosophy-Neuroscience-Psychology: Language, Cognition and Culture", "Physics", "Political Science", "Psychological & Brain Sciences", "Psychological & Brain Sciences: Cognitive Neuroscience", "Religious Studies", "Romance Languages and Literatures", "Secondary Teacher Education", "Sociology", "Spanish", "Statistics", "Supply Chain, Operations, and Technology", "Systems Science & Engineering", "Urban Studies", "Women, Gender, and Sexuality Studies"]
    
}
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
