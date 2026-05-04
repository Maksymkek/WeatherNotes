//
//  WeatherAPITests.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 04.05.2026.
//

internal import Foundation
import Testing

@testable import WeatherNotes

struct WeatherAPITests {

    @Test("Fetch weather data via WetherService")
    func fetchWeather() async throws {
        do {
            let response = try await WeatherService().fetchWeather(
                latitude: 44,
                longitude: 44
            )
            print(response)
            #expect(response.name == "Sovetskaya")

        } catch {
            print(error)
        }
    }

}
