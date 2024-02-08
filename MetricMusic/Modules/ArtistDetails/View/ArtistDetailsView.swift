//
//  ArtistDetailsView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 07/02/2024.
//

import SwiftUI

struct ArtistDetailsView: View {
    
    @State var viewModel: ArtistDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ArtistInfoView(artist: viewModel.artist,
                           isFavorite: viewModel.isFavorite) {
                viewModel.addOrRemoveToFavorites()
            }
            switch viewModel.state {
            case .loading:
                LoadingProgressIndicator()
            case .loaded(let recordings):
                RecordingsView(recordings: recordings)
            }
            Spacer()
        }
        .navigationTitle("Artist")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.start()
        }
    }
}

#Preview {
    ArtistDetailsView(
        viewModel: .init(
            artist: ArtistMB(
                id: UUID(),
                type: "Band",
                name: "Nirvana",
                country: "US"
            ),
            repository: AlbumsLoaderStub(albums: [])
    ))
}

#Preview {
    ArtistDetailsView(
        viewModel: .init(
            artist: ArtistMB(
                id: UUID(),
                type: "Band",
                name: "Nirvana",
                country: "US"
            ),
            repository: AlbumsLoaderStub(albums: [
                .init(id: UUID(), title: "Nevermind", releases: [
                    .init(id: UUID(), releaseGroup: .init(primaryType: "Album"))
                ], firstReleaseDate: "1992"),
                .init(id: UUID(), title: "In Utero", releases: [
                    .init(id: UUID(), releaseGroup: .init(primaryType: "Single"))
                ], firstReleaseDate: "1994"),
            ])
    ))
}

struct AlbumsLoaderStub: AlbumsLoader {
    
    let albums: [Recording]
    
    func fetch(at url: URL) async throws -> RecordingsContainer {
        RecordingsContainer(recordings: albums)
    }
}
