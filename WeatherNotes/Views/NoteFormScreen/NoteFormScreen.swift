//
//  NoteFormScreen.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 04.05.2026.
//

import CoreData
import SwiftUI

struct NoteFormScreen: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: NoteFormViewModel

    init(viewModel: NoteFormViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            Section {
                TextField("Enter note text", text: $viewModel.noteText)
                    .textFieldStyle(.automatic)
            } footer: {
                weatherFooter
            }
        }
        .task {
            await viewModel.loadWeatherForCurrentLocation()
        }
        .navigationTitle("Create note")
        .navigationBarTitleDisplayMode(.inline)
        .contentMargins(.top, 0)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", systemImage: "checkmark") {
                    try? viewModel.saveNote()
                    dismiss()
                }.disabled(
                    viewModel.noteText.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty
                )
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", systemImage: "xmark") {
                    dismiss()
                }
            }
        }
    }

    @ViewBuilder
    private var weatherFooter: some View {
        switch viewModel.weatherState {
        case .idle, .loading:
            HStack(spacing: 8) {
                ProgressView()
                Text("Loading weather...")
            }
        case .loaded:
            if let weather = viewModel.weather {
                HStack(alignment: .center, spacing: 8) {
                    Text("\(weather.name): \(Int(weather.main.temp))°C").bold()
                    Spacer()

                    if let iconCode = weather.weather.first?.icon,
                        let iconURL = viewModel.iconURL(for: iconCode)
                    {
                        WeatherImageView(imageURL: iconURL, size: 40)
                    }
                    Text(weather.weather.first?.main ?? "")
                }
            } else {
                weatherRetryView
            }
        case .failed:
            weatherRetryView
        }
    }

    private var weatherRetryView: some View {
        HStack {
            Text("Weather not loaded")
            Spacer()
            Button("Retry") {
                Task {
                    await viewModel.loadWeatherForCurrentLocation()
                }
            }
        }
    }
}

#Preview {
    let container = NSPersistentContainer(name: "WeatherNotesDB")
    let description = NSPersistentStoreDescription()
    description.url = URL(fileURLWithPath: "/dev/null")
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { _, error in
        if let error { fatalError(error.localizedDescription) }
    }

    let storage = StorageService(context: container.viewContext)
    let locationService = LocationService()
    let viewModel = NoteFormViewModel(
        storage: storage,
        weatherService: WeatherService.shared,
        locationService: locationService
    )

    return NavigationStack {
        NoteFormScreen(viewModel: viewModel)
            .environment(\.managedObjectContext, container.viewContext)
    }
}
