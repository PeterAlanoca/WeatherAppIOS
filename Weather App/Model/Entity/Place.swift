//
//  Place.swift
//  Weather App
//
//  Created by Peter Alanoca on 1/1/23.
//

import Foundation
import GRDB

struct Place: Codable, Identifiable, Equatable, FetchableRecord, PersistableRecord {
    
    var id: Int64?
    var latitude: Double?
    var longitude: Double?
    var country: String?
    var address: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case latitude = "latitude"
        case longitude = "longitude"
        case country = "country"
        case address = "address"
    }
    
    static var tableName: String {
        return String(describing: self)
    }
}

extension Place: MutablePersistableRecord {
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
}
