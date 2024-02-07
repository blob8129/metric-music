//
//  ArtistView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 07/02/2024.
//

import SwiftUI

struct AristView: View {
        
    let artist: ArtistMB
    
    var body: some View {
        HStack {
            Text(artist.name)
            Spacer()
        }
    }
}

#Preview {
    AristView(artist: ArtistMB(
        id: UUID(),
        type: "Band",
        name: "Nirvana",
        country: "US")
    )
}

