//
//  APIManager.swift
//  Weather App
//
//  Created by Peter Alanoca on 1/1/23.
//

import Foundation
import Moya
import RxSwift
import Alamofire

class APIManager<T>: NetworkManager<T> where T: TargetType {
    
    func build<T>(_ target: ProviderType) -> Observable<T> where T: Codable {
        return self.request(target)
            .map { (response: T) throws -> T in
                return response
        }
    }
    
}

extension TargetType {
    
    var baseURL: URL {
        guard let baseUrl = Configuration.string.value(for: "OPEN_WEATHER_API_URL")
        else { return URL(string: "")! }
        return URL(string: baseUrl)!
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        nil
    }
}

class NetworkManager<T>: ServiceManager where T: TargetType {
   
    typealias ProviderType = T
    var sharedProvider: MoyaProvider<T>!
    required init() {}
    
    var provider: MoyaProvider<T> {
        guard let provider = sharedProvider else {
            self.sharedProvider = MoyaProvider<T>(
                session: DefaultAlamofireManager.sharedManager,
                plugins: [
                    NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
                ]
            )
            return sharedProvider
        }
        return provider
    }
    
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    func request<T>(_ target: ProviderType, at keyPath: String? = nil) -> Observable<T> where T: Codable {
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map(T.self, atKeyPath: keyPath, using: jsonDecoder)
            .asObservable()
    }
}

protocol ServiceManager {
    associatedtype ProviderType: TargetType
    var provider: MoyaProvider<ProviderType> { get }
    var jsonDecoder: JSONDecoder { get }
}

class DefaultAlamofireManager: Alamofire.Session {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}


