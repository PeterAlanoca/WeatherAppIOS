//
//  Configuration.swift
//  Weather App
//
//  Created by Peter Alanoca on 2/1/23.
//

import Foundation

class Configuration {

    static let string = FromString()
    
    
    class FromString {
        func value(for key: String) -> String? {
            if let value = Bundle.main.infoDictionary?[key] as? String {
                return value
            } else {
                return nil
            }
        }
    }

}
