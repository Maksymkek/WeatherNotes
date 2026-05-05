//
//  NoteFormViewModel.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 05.05.2026.
//

internal import Combine
import Foundation
internal import _LocationEssentials

@MainActor
class NoteFormViewModel: ObservableObject {

    enum WeatherState {
        case idle
        case loading
        case loaded
        case failed
    }

    @Published var noteText: String = ""
    @Published var weather: WeatherResponse?
    @Published var weatherState: WeatherState = .idle

    private let storage: StorageServiceProtocol
    private let weatherService: WeatherServiceProtocol
    private let locationService: LocationService

    init(
        storage: StorageServiceProtocol,
        weatherService: WeatherServiceProtocol,
        locationService: LocationService
    ) {
        self.storage = storage
        self.weatherService = weatherService
        self.locationService = locationService
    }

    func saveNote() throws {
        try storage.saveNote(text: noteText, weather: weather)
    }

    func loadWeatherForCurrentLocation() async {
        weatherState = .loading
        do {
            let coordinate = try await locationService.getCurrentLocation()
            weather = try await weatherService.fetchWeather(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            weatherState = .loaded
        } catch {
            weather = nil
            weatherState = .failed
        }
    }

    func iconURL(for iconCode: String) -> URL? {
        weatherService.iconURL(for: iconCode)
    }
}
