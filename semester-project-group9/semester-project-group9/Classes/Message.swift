//
//  Message.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 3/26/24.
//

import Foundation
import Firebase

struct UserMessage: Decodable, Identifiable {
    let text: String
    let photoURL: String
    let senderName: String
    let senderEmail: String
    var id: String?
    
    func isFromCurrentUser() -> Bool {
        return senderEmail == UserDefaults.standard.string(forKey: "email")!
    }
    
}

class MessageViewModel: ObservableObject {
    
    @Published var messages = [UserMessage]()
    private let db = Firestore.firestore()
    private let user = UserDefaults.standard.string(forKey: "email")
    
    func sendMessage(messageContent: String, sender: String, senderEmail: String, docId: String) {
        if user != nil {
            db.collection("channels").document(docId).collection("messages").addDocument(data: [
                "sentAt": Date(),
                "displayName": sender,
                "senderEmail": senderEmail,
                "content": messageContent
            ])
        }
    }
    
    func fetchData(docId: String) {
        if user != nil {
            
            db.collection("channels").document(docId).collection("messages").order(by: "sentAt", descending: false).addSnapshotListener({(snapshot, error) in
                            guard let documents = snapshot?.documents else {
                                print("no documents")
                                return
                            }
                            
                            self.messages = documents.map { docSnapshot -> UserMessage in
                                let data = docSnapshot.data()
                                let docId = docSnapshot.documentID
                                let content = data["content"] as? String ?? ""
                                let displayName = data["displayName"] as? String ?? ""
                                let senderEmail = data["senderEmail"] as? String ?? ""
                                return UserMessage(text: content, photoURL: "", senderName: displayName, senderEmail: senderEmail, id: docId)
                            }
                        })
        }
    }

    
}
