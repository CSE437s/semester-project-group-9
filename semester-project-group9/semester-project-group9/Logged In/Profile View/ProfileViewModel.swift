//
//  ProfileViewModel.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/26/24.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case loaded(User)
    }
    
    @Published private(set) var state = State.idle
    private var currentUser: User
    init(currentUser: User) {
        self.currentUser = currentUser
    }
    
    func fecthUser() {
        state = .loading
        
        let docRef = Firestore.firestore().collection("users").document(currentUser.email)
        docRef.getDocument(completion: { doc, error in
            if let error = error {
                print(error)
            }
            if let doc = doc {
                let decoder = JSONDecoder()
                if let data = try? JSONSerialization.data(withJSONObject: doc.data()!) {
                    let result = try! decoder.decode(User.self, from: data)
                    self.state = .loaded(result)
                }
            }
        })
    }
    
    func updateUser(newData: [String : String], completion: @escaping () -> Void)  {
        let docRef = Firestore.firestore().collection("users").document(currentUser.email)
        docRef.updateData(newData) { error in
            if let error = error {
                print("error: \(error)")
            } else {
                completion()
                self.fecthUser()
            }
        }
    }
    
}
