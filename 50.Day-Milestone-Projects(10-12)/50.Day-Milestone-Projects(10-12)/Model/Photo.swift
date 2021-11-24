//
//  Photo.swift
//  50.Day-Milestone-Projects(10-12)
//
//  Created by Sabir Myrzaev on 24.11.2021.
//

import Foundation

class Photo: NSObject, Codable {
    
    var name: String
    var image: String
    
     init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
