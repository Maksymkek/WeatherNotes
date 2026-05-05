//
//  NoteDetailsScreen.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 05.05.2026.
//

import SwiftUI

struct NoteDetailsScreen: View {
    @ObservedObject var viewModel: NoteViewModel
    @Environment(\.dismiss) private var dismiss

    private static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()

    private var formattedDateTime: String {
        guard let timeStamp = viewModel.note.timeStamp else {
            return "Date not available"
        }
        return Self.dateTimeFormatter.string(from: timeStamp)
    }

    var body: some View {
        VStack(alignment: .center) {
            Text(viewModel.note.text ?? "")
                .font(.title)
                .bold()

            Text(formattedDateTime)
                .font(.caption)
                .foregroundStyle(.secondary)

            if let iconCode = viewModel.note.weatherIcon,
               let iconURL = viewModel.iconURL(for: iconCode, scale: .big) {
                WeatherImageView(
                    imageURL: iconURL,
                    size: 200,
                    progressViewSize: 80
                )
            }

            Text("\(Int(viewModel.note.temperature))°C")
                .font(.title2)
            Text(viewModel.note.weatherCondition ?? "")
                .font(.title3)
        }
        .navigationTitle("Note details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close", systemImage: "xmark") {
                    dismiss()
                }
            }
        }
    }
}
