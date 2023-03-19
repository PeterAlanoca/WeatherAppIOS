//
//  DatabaseManager.swift
//  Weather App
//
//  Created by Peter Alanoca on 1/1/23.
//

import GRDB

var dbQueue: DatabaseQueue?

class DatabaseManager {

    static func setup(_ application: UIApplication) {
        do {
            let databaseURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("db.sqlite")
            
            dbQueue = try DatabaseQueue(path: databaseURL.path)
        
            if let dbQueue = dbQueue {
                try migrator.migrate(dbQueue)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        migrator.registerMigration("v1.0") { db in
            try db.create(table: Place.tableName) { table in
                table.autoIncrementedPrimaryKey(Place.CodingKeys.id.rawValue)
                table.column(Place.CodingKeys.latitude.rawValue, .double)
                table.column(Place.CodingKeys.longitude.rawValue, .double)
                table.column(Place.CodingKeys.country.rawValue, .text)
                table.column(Place.CodingKeys.address.rawValue, .text)
            }
        }
        return migrator
    }
}
