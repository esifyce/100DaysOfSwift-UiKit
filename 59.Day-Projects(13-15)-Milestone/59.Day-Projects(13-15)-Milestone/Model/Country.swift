//
//  Country.swift
//  59.Day-Milestone:-Projects(13-15)
//
//  Created by Sabir Myrzaev on 02.12.2021.
//

import Foundation

struct Country: Codable {
    let name: String
    let city: String
    let facts: String
    let image: String
}

struct Countries: Codable {
    var results: [Country]
}
