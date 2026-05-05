//
//  ListScreenViewModel.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 05.05.2026.
//
internal import Combine
import Foundation

class ListScreenViewModel : ObservableObject {
    
     let storage: StorageServiceProtocol
     let weatherService: WeatherServiceProtocol
     let locationService: LocationService

    init(
        storage: StorageServiceProtocol,
        weatherService: WeatherServiceProtocol,
        locationService: LocationService
    ) {
        self.storage = storage
        self.weatherService = weatherService
        self.locationService = locationService
    }
}
