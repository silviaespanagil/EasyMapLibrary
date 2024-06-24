//
//  LocationManagerTests.swift
//
//
//  Created by Silvia España Gil on 24/6/24.
//

import XCTest
import CoreLocation
import Combine
@testable import EasyMapLibrary

final class LocationManagerTests: XCTestCase {
    
    var locationManager: LocationManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        
        super.setUp()
        locationManager = LocationManager()
        cancellables = []
    }
    
    override func tearDown() {
        
        locationManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testRequestLocationPermission() {
        
        // When
        locationManager.requestLocationPermission()
        
        // Then
        XCTAssertEqual(CLLocationManager.locationServicesEnabled(), true)
    }
    
    func testStartUpdatingLocation() {
        
        // When
        locationManager.startUpdatingLocation()
        
        // Then
        XCTAssertTrue(locationManager.isUpdatingLocation)
    }
    
    func testStopUpdatingLocation() {
        
        // When
        locationManager.stopUpdatingLocation()
        
        // Then
        XCTAssertFalse(locationManager.isUpdatingLocation)
    }
    
    func testLocationUpdateHandler() {
        
        // Given
        let expectation = self.expectation(description: "Location update received")
        var receivedCoordinate: CLLocationCoordinate2D?
        
        // When Then
        locationManager.onLocationUpdate { coordinate in
            
            receivedCoordinate = coordinate
            expectation.fulfill()
        }
        
        let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        locationManager.locationManager(CLLocationManager(), didUpdateLocations: [mockLocation])
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNotNil(receivedCoordinate)
        XCTAssertEqual(receivedCoordinate?.latitude, mockLocation.coordinate.latitude)
        XCTAssertEqual(receivedCoordinate?.longitude, mockLocation.coordinate.longitude)
    }
    
    func testLocationManagerDidChangeAuthorizationAuthorizedInUse() {
        
        // Given
        let mockLocationManager = CLLocationManager()
        
        // When
        locationManager.locationManagerDidChangeAuthorization(mockLocationManager)
        locationManager.authorizationStatus = .authorizedWhenInUse
        
        // Then
        XCTAssertEqual(locationManager.authorizationStatus, .authorizedWhenInUse)
    }
    
    func testLocationManagerDidChangeAuthorizationAuthorizedAlways() {
        
        // Given
        let mockLocationManager = CLLocationManager()
        
        // When
        locationManager.locationManagerDidChangeAuthorization(mockLocationManager)
        locationManager.authorizationStatus = .authorizedAlways
        
        // Then
        XCTAssertEqual(locationManager.authorizationStatus, .authorizedAlways)
    }
    
    func testLocationManagerDidChangeAuthorizationDenied() {
        
        // Given
        let mockLocationManager = CLLocationManager()
        
        // When
        locationManager.locationManagerDidChangeAuthorization(mockLocationManager)
        locationManager.authorizationStatus = .denied
        
        // Then
        XCTAssertEqual(locationManager.authorizationStatus, .denied)
        XCTAssertFalse(locationManager.isUpdatingLocation)
    }
    
    func testLocationManagerDidFailWithError() {
        
        // Given
        let mockError = NSError(domain: "LocationError", code: 1, userInfo: nil)
        
        // When
        locationManager.locationManager(CLLocationManager(), didFailWithError: mockError)
        
        // Then
        XCTAssertNotNil(locationManager.locationError)
    }
}
