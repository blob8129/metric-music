//
//  ContentView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 02/02/2024.
//

import SwiftUI

struct MainView: View {
    
    @Bindable var viewModel: MainViewModel
   
    //@State private var artistPath = [ArtistMB]()
    
    var body: some View {
        NavigationStack(path: $viewModel.artistPath) {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(for: ArtistMB.self) { artist in
                ArtistDetailsView(viewModel: .init(artist: artist))
            }
            .searchable(text: $viewModel.searchTerm)
            .searchSuggestions {
                ForEach(viewModel.artists) { artist in
                    Button {
                        viewModel.navigate(to: artist)
                    } label: {
                        AristView(artist: artist)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .onAppear(perform: {
            Task {
                await viewModel.start()
            }
        })
    }
}


#Preview {
    MainView(viewModel: MainViewModel(repository: ArtistRepositoryStub()))
}

struct ArtistRepositoryStub: ArtistRepositoryProtocol {
    func fetch(at url: URL) async throws -> ArtistsContainer {
        ArtistsContainer(artists: [])
    }
}
