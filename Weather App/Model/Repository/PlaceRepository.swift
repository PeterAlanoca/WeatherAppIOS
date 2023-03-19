//
//  PlaceRepository.swift
//  Weather App
//
//  Created by Peter Alanoca on 2/1/23.
//

import RxSwift
import Moya
import RxCocoa

protocol PlaceRepositoryProtocol {
    func getAll() -> BehaviorRelay<[Place]?>
    func insert(place: Place) -> BehaviorRelay<Int?>
}

class PlaceRepository: PlaceRepositoryProtocol {
    
    let placeDao: PlaceDaoProtocol

    init (placeDao: PlaceDaoProtocol = PlaceDao()) {
        self.placeDao = placeDao
    }

    func getAll() -> BehaviorRelay<[Place]?> {
        return placeDao.getAll()
    }
    
    func insert(place: Place) -> BehaviorRelay<Int?> {
        return placeDao.insert(place: place)
    }
    
}
