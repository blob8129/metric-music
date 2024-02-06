//
//  ContentView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 02/02/2024.
//

import SwiftUI

struct MainViewView: View {
    
    @Bindable var viewModel: MainViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
        .onAppear(perform: {
            Task {
                await viewModel.start()
            }
        })
        .searchable(text: $viewModel.searchTerm)
        .searchSuggestions {
            ForEach(viewModel.artists) { artist in
                HStack {
                    Text(artist.name)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }

    }
}

#Preview {
    MainViewView(viewModel: MainViewModel(repository: ArtistRepositoryStub()))
}

struct ArtistRepositoryStub: ArtistRepositoryProtocol {
    func fetch(at url: URL) async throws -> ArtistsContainer {
        ArtistsContainer(artists: [])
    }
}
