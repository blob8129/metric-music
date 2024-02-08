//
//  ArtistDetailsView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 07/02/2024.
//

import SwiftUI

enum ArtisDetailsState {
    case loading
    case loaded([Recording])
}

struct ArtistDetailsView: View {
    
    @State var viewModel: ArtistDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.artist.name)
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.accentColor)
                    
                    HStack {
                        Text(viewModel.artist.country ?? "-")
                            .font(.title2)
                            .foregroundStyle(Color.secondary)
                        
                        Text(viewModel.artist.type ?? "-")
                            .font(.title2)
                            .foregroundStyle(Color.secondary)
                    }
                }
                Spacer()

                Button {
                    viewModel.addOrRemoveToFavorites()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .font(.title)
                }
            }
            .padding()
            
            switch viewModel.state {
            case .loading:
                LoadingProgressIndicator()
            case .loaded(let albums):
                List {
                    Text("Recordings")
                        .foregroundStyle(.secondary)
                    ForEach(albums) { album in
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(album.title)
                                        .font(.headline)
                                    Text(album.firstReleaseDate ?? "")
                                        .font(.caption)
                                        .foregroundStyle(Color.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("release")
                                        .font(.caption)
                                        .foregroundStyle(Color.secondary)
                                    Text(album.firstReleasePrimaryType)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
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
    
    func fetch(at url: URL) async throws -> AlbumsContainer {
        AlbumsContainer(recordings: albums)
    }
}
