//
//  ClassViewModel.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/26/24.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class ClassViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case loaded([User])
    }
    
    @Published private(set) var state = State.idle
    @Published var classChannel = [ChatChannel]()
    
    private var currentClass: Class
    
    init(currentClass: Class) {
        self.currentClass = currentClass
    }
    
    func fetchChannel() {
        let db = Firestore.firestore()
        db.collection("channels").whereField("joinCode", isEqualTo: currentClass.classIdentifier).getDocuments{(snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("no docs returned")
                return
            }
            
            self.classChannel = documents.map({docSnapshot -> ChatChannel in
                let data = docSnapshot.data()
                let docId = docSnapshot.documentID
                let title = data["title"] as? String ?? ""
                let joinCode = data["joinCode"] as? String ?? ""
                return ChatChannel(id: docId, title: title, joinCode: joinCode)
            })
        }
    }
    
    func fetchRoster() {
        state = .loading
        
        var roster: [User] = []
        let docRef = Firestore.firestore().collection("rosters").document(currentClass.classIdentifier)
        docRef.getDocument(completion: { doc, error in
            if let error = error {
                print(error)
            }
            if let doc = doc?.data()!["roster"] as? [String] {
                for classmate in doc {
                    Firestore.firestore().collection("users").document(classmate).getDocument(completion:  { doc, error in
                        if let error = error {
                            print(error)
                        }
                        if let doc = doc {
                            let decoder = JSONDecoder()
                            if let data = try? JSONSerialization.data(withJSONObject: doc.data()!) {
                                
                                let result = try! decoder.decode(User.self, from: data)
                                roster.append(result)
                                self.state = .loaded(roster)
                            }
                        }
                    })
                }
            }
        })
    }
    
    
}
