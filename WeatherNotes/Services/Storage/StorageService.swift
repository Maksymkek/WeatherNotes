//
//  StorageServicce.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 04.05.2026.
//

import CoreData

final class StorageService: StorageServiceProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveNote(text: String, weather: WeatherResponse?) throws {
        let note = NoteEntity(context: context)
        note.id = UUID()
        note.text = text
        note.timeStamp = Date.now
        if let safeWeather =  weather{
            note.location = safeWeather.name
            note.temperature = safeWeather.main.temp
            note.weatherCondition = safeWeather.weather.first?.description
            note.weatherIcon = safeWeather.weather.first?.icon
        }
        try context.save()
    }
}
