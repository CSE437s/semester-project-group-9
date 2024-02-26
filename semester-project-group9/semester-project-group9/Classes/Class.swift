//
//  Class.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/26/24.
//

import Foundation

struct Class: Codable, Identifiable {
        
    let id = UUID()
    let classIdentifier: String
    let name: String
    let building_room: String
    let days: String
    let times: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case building_room = "building_room"
        case days = "days"
        case times = "times"
        case classIdentifier = "class-id"
    }
    
}

