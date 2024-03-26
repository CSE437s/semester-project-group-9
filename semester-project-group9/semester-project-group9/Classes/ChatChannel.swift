//
//  ChatChannel.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 3/26/24.
//

import Foundation
import Firebase

struct ChatChannel: Codable, Identifiable {
    var id: String
    var title: String
    var joinCode: String
}

class ChannelsViewModel: ObservableObject {
    
    @Published var chatrooms = [ChatChannel]()
    private let db = Firestore.firestore()
    private let user = UserDefaults.standard.string(forKey: "email")
    
    func fetchData() {
        if user != nil {
            db.collection("channels").whereField("users", arrayContains: user!).addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("no docs returned")
                    return
                }
                
                self.chatrooms = documents.map({docSnapshot -> ChatChannel in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let title = data["title"] as? String ?? ""
                    let joinCode = data["joinCode"] as? String ?? ""
                    return ChatChannel(id: docId, title: title, joinCode: joinCode)
                })
            })
        }
    }
    
    func createChannel(title: String, roomId: String) {
        if (user != nil) {
            db.collection("channels").addDocument(data: ["title" : title, "joinCode": roomId, "users" : [user]]) { err in
                if let err = err {
                    print("error adding document: \(err)")
                } else {
                    print("great success")
                }
            }
        }
    }
}
