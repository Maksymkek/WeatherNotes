//
//  WeatherResponse.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 04.05.2026.
//

nonisolated struct WeatherResponse: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
}
nonisolated struct Main: Codable {
    let temp: Double
    let pressure, humidity: Int
    let feelsLike, tempMin, tempMax: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

nonisolated struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}
