//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Peter Alanoca on 1/1/23.
//

import Foundation
import RxSwift

class WeatherViewModel: ObservableObject {

    let weatherRepository: WeatherRepositoryProtocol
    let placeRepository: PlaceRepositoryProtocol
    let disposeBag = DisposeBag()
    
    @Published var weatherResponse: WeatherResponse? = nil
    @Published var showSheet = false
    @Published var isLoading = false

    init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository(), placeRepository: PlaceRepositoryProtocol = PlaceRepository()) {
        self.weatherRepository = weatherRepository
        self.placeRepository = placeRepository
    }
    
    func getCurrentData(place: Place) {
        isLoading = true
        guard
            let latitude = place.latitude,
            let longitude = place.longitude
        else { return }
        weatherRepository.getCurrentData(latitude: latitude, longitude: longitude)
            .subscribe(onNext: { response in
                if let response = response {
                    self.weatherResponse = response
                    self.showSheet = true
                    self.isLoading = false
                }
            }).disposed(by: disposeBag)
    }
    
    func insertPlace(place: Place) {
        placeRepository.insert(place: place)
            .subscribe(onNext: { _ in
             
            }).disposed(by: disposeBag)
    }

}
