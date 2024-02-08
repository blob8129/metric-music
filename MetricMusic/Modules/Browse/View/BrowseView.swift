//
//  ContentView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 02/02/2024.
//

import SwiftUI

struct BrowseView: View {
    
    @Bindable var viewModel: BrowseViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.artistPath) {
            VStack(alignment: .leading) {
                if viewModel.favoriteArtists.isEmpty {
                    FavoritesEmptyStateView()
                } else {
                    Text("Favorites")
                        .foregroundStyle(.secondary)
                        .padding(.leading)
                    List() {
                        ForEach(viewModel.favoriteArtists) { artist in
                            Button {
                                viewModel.navigate(to: artist)
                            } label: {
                                ArtistInfoView(artist: artist, isFavorite: true)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Browse")
            .navigationDestination(for: ArtistMB.self) { artist in
                ArtistDetailsView(viewModel: .init(artist: artist))
            }
            .searchable(text: $viewModel.searchTerm)
            .searchSuggestions {
                SuggestionsView(suggestionsState: viewModel.suggestionsState) { artist in
                    viewModel.navigate(to: artist)
                }
            }
            .task {
                await viewModel.start()
            }
        }
        .padding()
    }
}


#Preview {
    BrowseView(viewModel: BrowseViewModel(repository: ArtistRepositoryStub()))
}

struct ArtistRepositoryStub: ArtistRepositoryProtocol {
    func fetch(at url: URL) async throws -> ArtistsContainer {
        ArtistsContainer(artists: [])
    }
}
