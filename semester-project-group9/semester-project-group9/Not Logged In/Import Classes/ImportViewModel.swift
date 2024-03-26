//
//  ImportViewModel.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/25/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

class ImportViewModel: ObservableObject {
    
    @AppStorage("uid") var userID: String = ""
    @AppStorage("email") var userEmail: String = ""
    
    func parseInput(classInput: String) -> [[String : Any]] {
                
        let leadingWhitespace = classInput.prefix(while: {$0.isWhitespace})
        let trimmedStr = String(classInput[leadingWhitespace.endIndex...])
        let courseBlocks = trimmedStr.split(separator: "expand\t\n")
        
        print(courseBlocks)
        
        var courses: [[String : Any]] = []
        
        for block in courseBlocks {
            let parts = block.split(separator: "Days & Time\tBld. / Room")
            let courseName = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            if courseName != "Independent Study" {
                let details = parts[1].trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\t")
                
                print(details)
                
                let daysAndTime = details[0].split(separator: " ")
                let buildingRoom = details[1]
                
                let days = daysAndTime[0]
                let times = daysAndTime[1]
                
                let classIdentifier = String(courseName + days + times + buildingRoom)
                let id = classIdentifier.replacingOccurrences(of: "/", with: "")
                
                let courseDict: [String : String] = [
                    "name": String(courseName),
                    "days": String(days),
                    "times": String(times),
                    "building_room": String(buildingRoom),
                    "class-id": String(id)
                ]
                
                courses.append(courseDict)
                enrollClasses(course: courseDict)
            }
        }
        
        print(courses)
        
        return courses

    }
    
    func postClasses(userInput: String) {
        let data = parseInput(classInput: userInput)
        Firestore.firestore().collection("classes").document(userEmail).setData(["\(userID)" : data]) { err in
            if let err = err {
                print(err)
                return
            }
            print("success importing")
        }
    }
    
    func enrollClasses(course: [String : String]) {
        if course["name"]! != "Independent Study" {
            Firestore.firestore().collection("rosters").document(course["class-id"]!).setData(["roster": FieldValue.arrayUnion([userEmail])], merge: true) { err in
                if let err = err {
                    print(err)
                    return
                }
                print("success enrolling")
                self.joinClassChannel(channelId: course["class-id"]!, course: course["name"]!)
            }
        }
    }
    
    func joinClassChannel(channelId: String, course: String) {
        
        // try and add yourself to the users array
        // if it doesnt work, invoke createChannel
        let db = Firestore.firestore()
        
        db.collection("channels").whereField("joinCode", isEqualTo: channelId).getDocuments() { (snapshot, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                
                if snapshot!.documents.isEmpty {
                    let model = ChannelsViewModel()
                    model.createChannel(title: course, roomId: channelId)
                } else {
                    for document in snapshot!.documents {
                        db.collection("channels").document(document.documentID).updateData(["users" : FieldValue.arrayUnion([UserDefaults.standard.string(forKey: "email")!])])
                    }

                }
            }
        }
        
                
        
    }
    
    
    
}
