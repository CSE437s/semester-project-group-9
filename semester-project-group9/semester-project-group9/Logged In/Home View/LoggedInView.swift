//
//  LoggedInView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/25/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoggedInView: View {
    @StateObject var viewModel: LoggedInHomeViewModel = LoggedInHomeViewModel()
    @State var showContentView: Bool = false
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            Text("Loading...")
                .task {
                    viewModel.fetchClasses()
                }
                .toolbar(.hidden)
        case .loading:
            Text("Loading...")
                .task {
                    viewModel.fetchClasses()
                }
                .toolbar(.hidden)
        case .loaded(let courseList):
            VStack {
                if showContentView {
                    ContentView()
                }
                Text("Classes")
                    .font(.largeTitle) // Makes the font larger and more prominent
                    .fontWeight(.bold) // Makes the text bold
                    .foregroundColor(.primary) // Uses the primary color, adaptable to light/dark mode
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5) // Adds some padding to the left to not stick to the edge
                     // Optionally, add vertical padding for spacing
                    .padding(.vertical, 10)
                List {
                    ForEach(courseList) { course in
                        NavigationLink {
                            ClassView(currentClass: course)
                        } label: {
                            VStack {
                                Text(course.name)
                                HStack {
                                    Text(course.days)
                                    Text(course.times)
                                }
                                Text(course.building_room)
                            }
                        }
                    }
                }
                Button {
                    signOut()
                    self.showContentView = true
                } label: {
                    Text("Sign out")
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .toolbar(.hidden)
            .padding(.leading, 0)
        }
    }
    
    private func signOut() {
        do  {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView()
    }
}

