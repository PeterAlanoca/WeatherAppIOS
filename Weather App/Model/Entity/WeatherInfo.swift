//
//  WeatherInfo.swift
//  Weather App
//
//  Created by Peter Alanoca on 1/1/23.
//

import Foundation

class WeatherInfo: Codable {
    
    var temp: Float?
    var feelsLike: Float?
    var tempMin: Float?
    var tempMax: Float?
    var pressure: Float?
    var humidity: Float?

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
   
}
