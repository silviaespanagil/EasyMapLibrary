//
//  MapView.swift
//  EasyMapLibrary
//
//  Created by Silvia España Gil on 19/6/24.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

public struct MapView: View {
    
    @ObservedObject private var mapManager: MapManager
    @State private var showSearchField: Bool
    @State private var showAddressSugestions: Bool = false
    @State private var selectedAddress: String = ""
    
    public init(mapManager: MapManager, showSearchField: Bool = false) {
        self.mapManager = mapManager
        self.showSearchField = showSearchField
    }
    
    public var body: some View {
        
        ZStack {
            
            MapReader { proxy in
                
                Map(position: $mapManager.mapCameraPosition) {
                    
                    if let selection = mapManager.selectedCoordinate {
                        
                        Annotation("", coordinate: selection) {
                            
                            Image(systemName: "mappin.and.ellipse")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            .foregroundColor(.blue) }
                        
                        MapCircle(center: selection, radius: CLLocationDistance(100))
                            .foregroundStyle(.pink.opacity(0.40))
                            .mapOverlayLevel(level: .aboveLabels)
                    }
                }.navigationBarTitleDisplayMode(.inline)
                    .onTapGesture { position in
                        
                        if let coordinate = proxy.convert(position, from: .local) {
                            
                            mapManager.updateSelectedCoordinate(coordinate)
                            mapManager.searchAddress(for: coordinate)
                        }
                    }
            }.mapControls {
                
                MapScaleView()
                MapCompass()
                MapUserLocationButton()
            }
        }
        .ignoresSafeArea(edges: .all)
        .toolbarBackground(.hidden)
        .onAppear {
            mapManager.requestLocationPermission()
        }
        .sheet(isPresented: $showAddressSugestions, onDismiss: {
            mapManager.address = selectedAddress
        }) {
            addressSuggestions
        }
    }
    
    @ViewBuilder
    private var searchField: some View {
        
        VStack {
            
            TextField("Busca la dirección a reportar", text: $mapManager.address)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 80)
                .onChange(of: mapManager.address) {
                    mapManager.updateSearchQuery(mapManager.address)
                    showAddressSugestions = true
                }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    var addressSuggestions: some View {
        
        VStack {
            
            List(mapManager.searchResults, id: \.self) { result in
                
                Button(action: {
                    mapManager.search(result)
                    mapManager.address = result.title
                    selectedAddress = result.title
                }) {
                    VStack(alignment: .leading) {
                        
                        Text(result.title)
                            .font(.body)
                            .foregroundColor(.primary)
                        Text(result.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }.listStyle(.plain)
                .presentationDetents([.fraction(0.25), .fraction(0.50)])
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(
                    .enabled
                )
        }
    }
}
