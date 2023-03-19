//
//  WeatherRepository.swift
//  Weather App
//
//  Created by Peter Alanoca on 1/1/23.
//

import RxSwift
import Moya
import RxCocoa

protocol WeatherRepositoryProtocol {
    func getCurrentData(latitude: Double, longitude: Double) -> BehaviorRelay<WeatherResponse?>
}

class WeatherRepository: WeatherRepositoryProtocol {
    
    let weatherService: WeatherServiceProtocol

    init (weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }

    func getCurrentData(latitude: Double, longitude: Double) -> BehaviorRelay<WeatherResponse?> {
        return weatherService.getCurrentData(latitude: latitude, longitude: longitude)
    }
}
