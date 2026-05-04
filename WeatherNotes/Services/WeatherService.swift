//
//  WeatherService.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 04.05.2026.
//

import Foundation

final class WeatherService {
    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String else {
            fatalError("WEATHER_API_KEY not found. Check Info setting and .xcconfig!")
        }
        return key
    }
    
    private func getUrlString(latitude: Double, longtitude: Double) -> String {
        "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longtitude)&units=metric&appid=\(apiKey)"
    }
    
     func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        let urlString = getUrlString(latitude: latitude, longtitude: longitude)
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(WeatherResponse.self, from: data)
    }
    
}
