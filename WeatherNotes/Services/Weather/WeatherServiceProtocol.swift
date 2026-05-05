//
//  WeatherServiceProtocol.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 04.05.2026.
//

import Foundation
enum WeatherImageScale: String{
    
    case medium = "2"
    case big = "4"
}
protocol WeatherServiceProtocol {
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse
    
    func iconURL(for iconCode: String, scale: WeatherImageScale) -> URL?
}
