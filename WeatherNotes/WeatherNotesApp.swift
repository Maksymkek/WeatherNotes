//
//  WeatherNotesApp.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 04.05.2026.
//

import SwiftUI
import CoreData

@main
struct WeatherNotesApp: App {

    let persistentContainer: NSPersistentContainer
    let storage: StorageServiceProtocol
    let weatherService: WeatherServiceProtocol
    let locationService: LocationService

    init() {
        let container = NSPersistentContainer(name: "WeatherNotesDB")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data error: \(error), \(error.userInfo)")
            }
        }
        persistentContainer = container
        storage = StorageService(context: container.viewContext)
        weatherService = WeatherService.shared
        locationService = LocationService()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                NoteFormScreen(
                    viewModel: NoteFormViewModel(
                        storage: storage,
                        weatherService: weatherService,
                        locationService: locationService
                    )
                )
                .environment(\.managedObjectContext, persistentContainer.viewContext)
            }
        }
    }
    
    
}
