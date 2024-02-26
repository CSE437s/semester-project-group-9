//
//  User.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/26/24.
//

import Foundation

struct User: Codable, Identifiable {
    
    let id = UUID()
    let firstName: String
    let lastName: String
    let email: String
    let firstMajor: String
    let secondMajor: String
    let graduationYear: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "firstname"
        case lastName = "lastname"
        case email = "email"
        case graduationYear = "graduationyear"
        case firstMajor = "firstmajor"
        case secondMajor = "secondmajor"
    }
    
}
