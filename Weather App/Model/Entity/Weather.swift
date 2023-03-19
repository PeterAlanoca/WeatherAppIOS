//
//  Weather.swift
//  Weather App
//
//  Created by Peter Alanoca on 1/1/23.
//

import Foundation

class Weather: Codable {
    
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
}

