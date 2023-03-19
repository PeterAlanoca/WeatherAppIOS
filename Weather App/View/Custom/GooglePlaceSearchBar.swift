//
//  GooglePlaceSearchBar.swift
//  Weather App
//
//  Created by Peter Alanoca on 31/12/22.
//

import SwiftUI
import GooglePlaces
import GoogleMaps

struct GooglePlaceSearchBar: UIViewControllerRepresentable {
    
    @Binding var isSearch: Bool

    let resultsViewController = GMSAutocompleteResultsViewController()
    let searchBarWrapperController =  SearchBarWrapperController()
    
    let action: (Place) -> Void
    
    func makeCoordinator() -> SearchBarCoordinator {
        return SearchBarCoordinator(parent: self) { place in
            action(place)
        }
    }
    
    func makeUIViewController(context: Context) -> SearchBarWrapperController {
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchBarWrapperController.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        searchController.searchBar.showsCancelButton = true
        searchBarWrapperController.searchController?.searchResultsUpdater = resultsViewController
        return searchBarWrapperController
    }
    
    func updateUIViewController(_ controller: SearchBarWrapperController, context: Context) {
        
    }
    
    class SearchBarCoordinator: NSObject, GMSAutocompleteResultsViewControllerDelegate {
        
        var parent: GooglePlaceSearchBar
        var action: (Place) -> Void

        init(parent: GooglePlaceSearchBar, action: @escaping (Place) -> Void) {
            self.parent = parent
            self.action = action
            super.init()
            self.parent.resultsViewController.delegate = self
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
            parent.searchBarWrapperController.searchController?.isActive = false
            return true
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
            let coordinate = place.coordinate
            GMSGeocoder().reverseGeocodeCoordinate(coordinate) { placemarks, error in
                if error != nil {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                } else {
                    if let places = placemarks?.results() {
                        if let selectedPlace = places.first, let address = selectedPlace.lines {
                            var place = Place()
                            place.latitude = coordinate.latitude
                            place.longitude = coordinate.longitude
                            place.country = selectedPlace.country
                            place.address = address.first ?? "SN"
                            self.action(place)
                            self.parent.isSearch = true
                        }
                    }
                }
            }
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
        }
        
    }
    
    class SearchBarWrapperController: UIViewController {
        
        var searchController: UISearchController? {
            didSet {
                self.parent?.navigationItem.searchController = searchController
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            self.parent?.navigationItem.searchController = searchController
        }
        override func viewDidAppear(_ animated: Bool) {
            self.parent?.navigationItem.searchController = searchController
        }
    }
}
