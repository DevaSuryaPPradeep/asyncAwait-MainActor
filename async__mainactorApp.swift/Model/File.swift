//
//  File.swift
//  async__mainactorApp.swift
//
//  Created by Devasurya on 27/04/24.
//

import Foundation

struct ModelData: Codable {
    let main: Main
    let name: String
}
struct Main: Codable {
    let pressure: Int
    let humidity: Int
    let temp: Double
}

struct ModelStructure:Codable {
    let location: String
    let temperature: Double
}
