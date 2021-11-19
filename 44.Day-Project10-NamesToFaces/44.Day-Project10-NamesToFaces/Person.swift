//
//  Person.swift
//  42.Day-Project10-NamesToFaces
//
//  Created by Sabir Myrzaev on 19.11.2021.
//

import UIKit

class Person: NSObject {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
