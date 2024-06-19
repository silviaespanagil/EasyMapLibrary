//
//  MapManager.swift
//  EasyMapLibrary
//
//  Created by Silvia España Gil on 19/6/24.
//

import Foundation
import MapKit
import SwiftUI
import Combine

public class MapManager: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published public var locationManager: LocationManager = LocationManager()
    
    @Published public var userLocation: CLLocationCoordinate2D?
    @Published public var selectedCoordinate: CLLocationCoordinate2D?
    
    @Published public var mapCameraPosition: MapCameraPosition
    
    @Published public var searchResults: [MKLocalSearchCompletion] = []
    
    @Published public var address: String = ""
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    public init(defaultLocation: CLLocationCoordinate2D) {
        
            self.mapCameraPosition = .userLocation(
                fallback: .camera(
                    MapCamera(centerCoordinate: defaultLocation, distance: 1000)
                )
            )
            super.init()
            configureSearchCompleter()
            setupLocationUpdates()
        }
    
    // MARK: - Configuration Methods
    
    private func configureSearchCompleter() {
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    private func setupLocationUpdates() {
        
        locationManager.onLocationUpdate { [weak self] coordinate in
            self?.updateUserLocation(coordinate)
        }
    }
    
    // MARK: - Update methods
    
    public func updateUserLocation(_ location: CLLocationCoordinate2D?) {
        
        userLocation = location
    }
    
    public func updateSelectedCoordinate(_ coordinate: CLLocationCoordinate2D?) {
        
        selectedCoordinate = coordinate
    }
    
    public func updateMapCameraPosition(_ position: MapCameraPosition) {
        
        mapCameraPosition = position
    }
    
    public func setDefaultLocation(to coordinate: CLLocationCoordinate2D) {
        
            mapCameraPosition = .camera(
                MapCamera(centerCoordinate: coordinate, distance: 1000)
            )
        }
    
    // MARK: - Location permission methods
    public func requestLocationPermission() {
        
        locationManager.requestLocationPermission()
    }
    
    // MARK: - Local Search methods
    public func updateSearchQuery(_ query: String) {
        
        address = query
        searchCompleter.queryFragment = query
    }
    
    public func search(_ completion: MKLocalSearchCompletion) {
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] response, error in
            guard let self = self, let response = response, let item = response.mapItems.first else {
                
                print("Search error: \(String(describing: error?.localizedDescription))")
                return
            }
            self.handleSearchResponse(item)
        }
    }
    
    public func searchAddress(for coordinate: CLLocationCoordinate2D) {
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                
                print("Reverse geocoding failed with error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let address = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.country ?? "")"
            self.address = address
        }
    }
    
    private func handleSearchResponse(_ item: MKMapItem) {
        
        let coordinate = item.placemark.coordinate
        selectedCoordinate = coordinate
        mapCameraPosition = .camera(
            MapCamera(centerCoordinate: coordinate, distance: 1000)
        )
    }
    
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        searchResults = completer.results
    }
    
    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        print("Autocomplete error: \(error.localizedDescription)")
    }
}
