//
//  WeatherServiceProtocol.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 04.05.2026.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse
    
    func iconURL(for iconCode: String) -> URL?
}
