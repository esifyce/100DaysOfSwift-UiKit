//
//  Petition.swift
//  33.Day-Project7-WhitehousePetitions
//
//  Created by Sabir Myrzaev on 02.11.2021.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
