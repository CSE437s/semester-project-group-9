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
                } label: {
                    Text("Sign out")
                        .padding()
                        .background(.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .toolbar(.hidden)
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
