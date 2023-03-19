//
//  PlaceDao.swift
//  Weather App
//
//  Created by Peter Alanoca on 2/1/23.
//

import GRDB
import RxGRDB
import RxCocoa
import RxSwift

protocol PlaceDaoProtocol {
    func getAll() -> BehaviorRelay<[Place]?>
    func insert(place: Place) -> BehaviorRelay<Int?> 
}

class PlaceDao: PlaceDaoProtocol {

    var disposeBag = DisposeBag()

    func getAll() -> BehaviorRelay<[Place]?> {
        let result = BehaviorRelay<[Place]?>(value: nil)
        guard let dbQueue = dbQueue else { return result }
        dbQueue.rx.read { db in
            try Place.fetchAll(db, sql: "SELECT * FROM Place ORDER BY id DESC LIMIT 30")
        }.subscribe(
            onSuccess: { places in
                result.accept(places)
            },
            onFailure: { error in
                result.accept([])
                print(error)
            }
        ).disposed(by: disposeBag)
        return result
    }
    
    func insert(place: Place) -> BehaviorRelay<Int?> {
        let result = BehaviorRelay<Int?>(value: nil)
        guard let dbQueue = dbQueue else { return result }
        dbQueue.rx.write(
            updates: { db in
                try Place(latitude: place.latitude, longitude: place.longitude, country: place.country, address: place.address)
                    .insert(db)
            },
            thenRead: { db, _ in
                try Place.fetchCount(db)
            }
        ).subscribe(
            onSuccess: { count in
                result.accept(count)
            },
            onFailure: { error in
                result.accept(0)
                print(error)
            }
        ).disposed(by: disposeBag)
        return result
    }
    
}
