//
//  NoteView.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 05.05.2026.
//

import SwiftUI
import CoreData

struct NoteView: View {
    
    let viewModel: NoteViewModel
    @State private var isShowingDetailsView: Bool = false
   
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.note.text ?? "")
                if let date = viewModel.note.timeStamp {
                    Text(date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if let iconCode = viewModel.note.weatherIcon,
               let iconURL = viewModel.iconURL(for: iconCode) {
                WeatherImageView(imageURL: iconURL, size: 40)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isShowingDetailsView = true
        }
        .sheet(
            isPresented: $isShowingDetailsView,
        ) {
            NavigationStack{
                NoteDetailsScreen(viewModel: viewModel)
            }.presentationDetents([.medium])
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
    let context = container.viewContext
    var note = NoteEntity(context: container.viewContext)
    note.text = "Test text"
    note.timeStamp = Date.now
    note.weatherCondition = "Rain"
    note.weatherIcon = "10d"
    try? context.save()
    return NavigationStack {
        List {
            NoteView(
                viewModel: NoteViewModel(
                    note: note,
                    weatherService: WeatherService.shared
                )
            )
                .environment(\.managedObjectContext, context)
        }
    }
}
