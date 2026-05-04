//
//  WeatherServiceProtocol.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 04.05.2026.
//

protocol WeatherServiceProtocol {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse
}
