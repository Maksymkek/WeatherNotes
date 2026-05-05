//
//  NoteViewModel.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 05.05.2026.
//

internal import Combine
import Foundation

class NoteViewModel: ObservableObject {

    var note: NoteEntity
    let weatherService: WeatherServiceProtocol

    init(
        note: NoteEntity,
        weatherService: WeatherServiceProtocol
    ) {
        self.note = note
        self.weatherService = weatherService
    }

    func iconURL(for iconCode: String, scale: WeatherImageScale = .medium)
        -> URL?
    {
        weatherService.iconURL(for: iconCode, scale: scale)
    }

}
