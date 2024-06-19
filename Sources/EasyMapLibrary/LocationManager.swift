//
//  LocationManager.swift
//  EasyMapLibrary
//
//  Created by Silvia España Gil on 19/6/24.
//

import Foundation
import CoreLocation
import Combine

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published public var coordinates: CLLocationCoordinate2D?
    @Published public var lastKnownLocation: CLLocation?
    @Published public var locationError: Error?
    
    private let locationManager = CLLocationManager()
    private var locationUpdateHandler: ((CLLocationCoordinate2D) -> Void)?
    
    public override init() {
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Public method to request location permission
    
    public func requestLocationPermission() {
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Public method to start updating location
    public func startUpdatingLocation() {
        
        locationManager.startUpdatingLocation()
    }
    
    // Public method to stop updating location
    public func stopUpdatingLocation() {
        
        locationManager.stopUpdatingLocation()
    }
    
    // Public method to provide a closure for location updates
    public func onLocationUpdate(handler: @escaping (CLLocationCoordinate2D) -> Void) {
        
        locationUpdateHandler = handler
    }
    
    // CLLocationManagerDelegate methods
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            
            startUpdatingLocation()
        } else {
            
            stopUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        coordinates = location.coordinate
        lastKnownLocation = location
        locationUpdateHandler?(location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        locationError = error
        print("Location update failed with error: \(error.localizedDescription)")
    }
}
