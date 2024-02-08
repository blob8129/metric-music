//
//  ArtistInfoView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 08/02/2024.
//

import SwiftUI

struct ArtistInfoView: View {
    
    let artist: ArtistMB
    let isFavorite: Bool
    let addOrRemoveToFavorites: (() -> ())?
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(artist.name)
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.accentColor)
                    
                    HStack {
                        Text(artist.country ?? "-")
                            .font(.title2)
                            .foregroundStyle(Color.secondary)
                        
                        Text(artist.type ?? "-")
                            .font(.title2)
                            .foregroundStyle(Color.secondary)
                    }
                }
                Spacer()
                
                if let addOrRemoveToFavorites {
                    Button {
                        addOrRemoveToFavorites()
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .font(.title)
                    }
                }
            }
        }
        .padding()
    }
    
    init(artist: ArtistMB,
         isFavorite: Bool,
         addOrRemoveToFavorites: (() -> Void)? = nil) {
        self.artist = artist
        self.isFavorite = isFavorite
        self.addOrRemoveToFavorites = addOrRemoveToFavorites
    }
}
