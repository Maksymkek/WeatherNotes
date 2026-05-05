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

    private let persistentContainer: NSPersistentContainer
    private let storage: StorageServiceProtocol
    private let weatherService: WeatherServiceProtocol
    private let locationService: LocationService

    init() {
        let container = NSPersistentContainer(name: "WeatherNotesDB")
        container.loadPersistentStores { _, error in
            if let error { fatalError(error.localizedDescription) }
        }
        persistentContainer = container

        storage = StorageService(context: container.viewContext)
        weatherService = WeatherService.shared
        locationService = LocationService()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ListScreen(
                    viewModel: ListScreenViewModel(
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
