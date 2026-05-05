//
//  ListScreen.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 05.05.2026.
//

import CoreData
import SwiftUI

struct ListScreen: View {
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \NoteEntity.timeStamp, ascending: false)
        ],
        animation: .default
    )
    private var notes: FetchedResults<NoteEntity>
    @StateObject var viewModel: ListScreenViewModel
    @State private var isShowingNoteForm: Bool = false

    var body: some View {
        List(notes, id: \.objectID) { note in
            NoteView(
                viewModel: NoteViewModel(
                    note: note,
                    weatherService: viewModel.weatherService
                )
            )
        }
        .navigationTitle("WeatherNotes")
        .toolbar {
            ToolbarSpacer(placement: .bottomBar)
            ToolbarItem(placement: .bottomBar) {
                Button("New record", systemImage: "plus") {
                    isShowingNoteForm = true
                }.buttonStyle(.borderedProminent).tint(.blue)
            }
        }
        .sheet(
            isPresented: $isShowingNoteForm,
        ) {
            NavigationStack {
                NoteFormScreen(
                    viewModel: NoteFormViewModel(
                        storage: viewModel.storage,
                        weatherService: viewModel.weatherService,
                        locationService: viewModel.locationService
                    )
                ).presentationDetents([.medium])
            }
        }
    }
}
