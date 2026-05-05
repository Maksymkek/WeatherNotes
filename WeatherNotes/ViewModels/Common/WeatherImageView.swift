//
//  WeatherImageView.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 05.05.2026.
//

import SwiftUI

struct WeatherImageView : View{
    let imageURL: URL
    let size : CGFloat
    let progressViewSize: CGFloat
    init(imageURL: URL, size: CGFloat, progressViewSize: CGFloat? = nil) {
        self.imageURL = imageURL
        self.size = size
        self.progressViewSize = progressViewSize ?? size > 40 ? 40 : size * 0.8
    }
    
    var body: some View{
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: progressViewSize, height: progressViewSize)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .shadow(radius: 3)
                
            case .failure:
                Image(systemName: "cloud.slash")
                    .frame(width: size, height: size)
            @unknown default:
                EmptyView()
            }
        }
    }
}
