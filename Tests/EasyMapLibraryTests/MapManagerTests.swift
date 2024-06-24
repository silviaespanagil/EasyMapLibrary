//
//  MapManagerTests.swift
//
//
//  Created by Silvia España Gil on 24/6/24.
//

import XCTest
import CoreLocation
import Combine
import MapKit
import SwiftUI
@testable import EasyMapLibrary

final class MapManagerTests: XCTestCase {
    
    var mapManager: MapManager!
    var defaultLocation: CLLocationCoordinate2D!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        
        super.setUp()
        
        defaultLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        mapManager = MapManager(defaultLocation: defaultLocation)
        cancellables = []
    }
    
    override func tearDown() {
        
        mapManager = nil
        defaultLocation = nil
        cancellables = nil
        
        super.tearDown()
    }
    
    func testUpdateUserLocation() {
        
        // Given
        let newLocation = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        
        // When
        mapManager.updateUserLocation(newLocation)
        
        // Then
        XCTAssertEqual(mapManager.userLocation?.latitude, newLocation.latitude)
        XCTAssertEqual(mapManager.userLocation?.longitude, newLocation.longitude)
    }
    
    func testUpdateSelectedCoordinate() {
        
        // Given
        let newCoordinate = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
        
        // When
        mapManager.updateSelectedCoordinate(newCoordinate)
        
        // Then
        XCTAssertEqual(mapManager.selectedCoordinate?.latitude, newCoordinate.latitude)
        XCTAssertEqual(mapManager.selectedCoordinate?.longitude, newCoordinate.longitude)
    }
    
    func testUpdateMapCameraPosition() {
        
        // Given
        let newPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: defaultLocation, distance: 2000))
        
        // When
        mapManager.updateMapCameraPosition(newPosition)
        
        // Then
        XCTAssertEqual(mapManager.mapCameraPosition, newPosition)
    }
    
    func testSetDefaultLocation() {
        
        // Given
        let newDefaultLocation = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
        
        // When
        mapManager.setDefaultLocation(to: newDefaultLocation)
        
        // Then
        XCTAssertEqual(mapManager.mapCameraPosition.camera, MapCamera(centerCoordinate: newDefaultLocation, distance: 1000))
    }
    
    func testSearch() {
        
        // Given
        let mapManager = MapManager(defaultLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
        let mockCompletion = MKLocalSearchCompletion()
        mapManager.address = "San Francisco"
        
        // When
        mapManager.search(mockCompletion)
        
        // Then
        XCTAssertNotNil(mapManager.searchResults)
    }
    
    func testSearchAddressSuccess() {
        
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 37.7689, longitude: -122.4830)
        let expectation = self.expectation(description: "Search address completed")
        
        // When
        mapManager.searchAddress(for: coordinate)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertFalse(self.mapManager.address.isEmpty)
            XCTAssertEqual(self.mapManager.address, "Golden Gate Park, San Francisco, United States")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testSearchAddressEmtpyStrings() {
        
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let expectation = self.expectation(description: "Search address failed")
        
        // When
        mapManager.searchAddress(for: coordinate)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertFalse(self.mapManager.address.isEmpty)
            XCTAssertEqual(self.mapManager.address, "North Atlantic Ocean, , ")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testSearchAddressFailure() {
        
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 100.0, longitude: -200.0)
        let expectation = self.expectation(description: "Search address failed")
        
        // When
        mapManager.searchAddress(for: coordinate)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.mapManager.address.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testHandleSearchResponse() {
        
        // Given
        let mapManager = MapManager(defaultLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
        
        let mockMapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)))
        
        // When
        mapManager.handleSearchResponse(mockMapItem)
        
        // Then
        XCTAssertEqual(mapManager.selectedCoordinate?.latitude, 37.7749)
        XCTAssertEqual(mapManager.selectedCoordinate?.longitude, -122.4194)
        XCTAssertEqual(mapManager.mapCameraPosition.camera?.centerCoordinate.latitude, 37.7749)
        XCTAssertEqual(mapManager.mapCameraPosition.camera?.centerCoordinate.longitude, -122.4194)
    }
    
    func testCompleterDidUpdateResults() {
        
        // Given
        let mapManager = MapManager(defaultLocation: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        
        let mockCompleter = MKLocalSearchCompleter()
        mockCompleter.delegate = mapManager
    
        let expectation = XCTestExpectation(description: "Completer did update results")
        
        // When
        mapManager.completerDidUpdateResults(mockCompleter)
        
        // Then
        expectation.fulfill()
        XCTAssertNotNil(mapManager.searchResults)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCompleterWithError() {
        
        // Given
        let mapManager = MapManager(defaultLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
        
        let mockCompleter = MKLocalSearchCompleter()
        let mockError = NSError(domain: "TestErrorDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        
        // When
        mapManager.completer(mockCompleter, didFailWithError: mockError)
        
        // Then
        XCTAssertEqual(mapManager.searchResults.count, 0)
    }
    
    
    func testUpdateSearchQuery() {
        
        // Given
        let query = "1600 Amphitheatre Parkway"
        
        // When
        mapManager.updateSearchQuery(query)
        
        // Then
        XCTAssertEqual(mapManager.address, query)
    }
}
