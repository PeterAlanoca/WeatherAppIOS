//
//  WeatherResponse.swift
//  Weather App
//
//  Created by Peter Alanoca on 1/1/23.
//

import Foundation

class WeatherResponse: Codable {
    
    let code: Int?
    let message: String?
    let name: String?
    let weather: [Weather]?
    let info: WeatherInfo?
    
    enum CodingKeys: String, CodingKey {
        case code = "cod"
        case message = "message"
        case name = "name"
        case weather = "weather"
        case info = "main"
    }
}
