//
//  GoogleMapsView.swift
//  Weather App
//
//  Created by Peter Alanoca on 31/12/22.
//

import SwiftUI
import GoogleMaps

struct GoogleMapsView: UIViewRepresentable {
    
    @Binding var coordinate: CLLocationCoordinate2D
    @Binding var isSearch: Bool
    @State var selectedMarker: GMSMarker? = GMSMarker()

    var zoomMin: Float = 5.4
    var zoomMax: Float = 14.4
    let action: (Place) -> Void
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(
            parent: self,
            marker: $selectedMarker,
            coordinate: $coordinate) { place in
                action(place)
            }
    }
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(frame: CGRect.zero)
        mapView.camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: zoomMin)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        if isSearch {
            if let selectedMarker = selectedMarker {
                selectedMarker.map = mapView
                selectedMarker.position = coordinate
                mapView.animate(to: GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: zoomMax))
            }
        } else {
            if let selectedMarker = selectedMarker {
                selectedMarker.position = coordinate
                mapView.animate(toLocation: coordinate)
            }
        }
    }
    
}

class MapCoordinator: NSObject, GMSMapViewDelegate {
    
    @Binding var selectedMarker: GMSMarker?
    @Binding var selectedCoordinate: CLLocationCoordinate2D
    var parent: GoogleMapsView
    var action: (Place) -> Void
    
    init(parent: GoogleMapsView, marker: Binding<GMSMarker?>, coordinate: Binding<CLLocationCoordinate2D>, action: @escaping (Place) -> Void) {
        self.parent = parent
        _selectedMarker = marker
        _selectedCoordinate = coordinate
        self.action = action
    }
    
    func mapView(_ GMSMarker: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        selectedCoordinate = coordinate
        selectedMarker?.map = GMSMarker
        GMSMarker.animate(to: GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: parent.zoomMax))
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
                    }
                }
            }
        }
    }
    
}
