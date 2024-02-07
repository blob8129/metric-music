//
//  ArtistDetailsView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 07/02/2024.
//

import SwiftUI

enum ArtisDetailsState {
    case loading
    case loaded([Album])
}

struct ArtistDetailsView: View {
    
    @State var viewModel: ArtistDetailsViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.artist.name)
            
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .padding()
                    .progressViewStyle(.circular)
            case .loaded(let albums):
                ForEach(albums) { album in
                    Text(album.title)
                }
            }
        }
        .task {
            await viewModel.loadAlbums()
        }
    }
}
