//
//  LoggedInHomeViewModel.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/26/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

class LoggedInHomeViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case loaded([Class])
    }
    
    @Published private(set) var state = State.idle
    var userID = UserDefaults.standard.string(forKey: "uid")
    var userEmail = UserDefaults.standard.string(forKey: "email")
        
    func fetchClasses() {
        state = .loading
        
        var coursesList: [Class] = []
        let docRef = Firestore.firestore().collection("classes").document(userEmail!)
        
        docRef.getDocument(completion: { doc, error in
            if let error = error {
                print(error)
            }
            if let doc = doc {
                let decoder = JSONDecoder()
                if let data = try? JSONSerialization.data(withJSONObject: doc.data()![self.userID!]!) {
                    coursesList = try! decoder.decode([Class].self, from: data)
                }
                print(coursesList)
                self.state = .loaded(coursesList)
            }
        })
        
    }
    
    
}
