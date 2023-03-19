//
//  WeatherService.swift
//  Weather App
//
//  Created by Peter Alanoca on 1/1/23.
//

import RxSwift
import Moya
import RxCocoa

protocol WeatherServiceProtocol {
    func getCurrentData(latitude: Double, longitude: Double) -> BehaviorRelay<WeatherResponse?>
}

class WeatherService: APIManager<WeatherTarget>, WeatherServiceProtocol {
    
    let disposeBag = DisposeBag()

    func getCurrentData(latitude: Double, longitude: Double) -> BehaviorRelay<WeatherResponse?> {
        let result = BehaviorRelay<WeatherResponse?>(value: nil)
        build(WeatherTarget.getCurrentData(latitude: latitude, longitude: longitude))
        .subscribe(
            onNext: {(response: WeatherResponse) in
                if response.code == 200 {
                    result.accept(response)
                } else {
                    print(response.message as Any)
                }
            },
            onError: { error in
                print(error)
            }
        ).disposed(by: disposeBag)
        return result
    }
    
}

enum WeatherTarget {
    case getCurrentData(latitude: Double, longitude: Double)
}

extension WeatherTarget: TargetType {

    var method: Moya.Method {
        .get
    }

    var path: String {
        switch self {
        case .getCurrentData:
            return "weather"
        }
    }

    var task: Task {
        switch self {
        case .getCurrentData(let latitude, let longitude):
            guard let appid = Configuration.string.value(for: "OPEN_WEATHER_API_KEY")
            else { return .requestPlain }
            return .requestParameters(
                parameters: [
                    "lat": latitude,
                    "lon": longitude,
                    "units": "metric",
                    "lang": "es",
                    "appid": appid
                ],
                encoding:  URLEncoding.queryString
            )
        }
    }
    
}
