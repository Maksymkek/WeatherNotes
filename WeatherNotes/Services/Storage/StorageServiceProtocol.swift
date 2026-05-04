//
//  StorageService.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 04.05.2026.
//

protocol StorageServiceProtocol {
    func saveNote(text: String, weather: WeatherResponse?) throws
    func fetchNotes() throws -> [NoteEntity]
}
