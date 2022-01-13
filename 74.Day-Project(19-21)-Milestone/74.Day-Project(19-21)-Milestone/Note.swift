//
//  Note.swift
//  74.Day-Project(19-21)-Milestone
//
//  Created by Sabir Myrzaev on 13.01.2022.
//

import Foundation

class Note: NSObject, Codable {
    
    var name: String
    var text: String
    
    init(name: String, text: String) {
        self.name = name
        self.text = text
    }
}
