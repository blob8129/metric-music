//
//  ArtistView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 07/02/2024.
//

import SwiftUI

struct AristSuggestionView: View {
        
    let artist: ArtistMB
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(artist.name)
                Text("\(artist.country ?? "-") \(artist.type ?? "-")")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}

#Preview {
    AristSuggestionView(artist: ArtistMB(
        id: UUID(),
        type: "Band",
        name: "Nirvana",
        country: "US")
    )
}

