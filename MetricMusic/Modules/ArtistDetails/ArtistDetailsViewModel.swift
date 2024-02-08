//
//  ArtistDetailsViewModel.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 07/02/2024.
//

import Foundation

enum ArtisDetailsState: Equatable {
    case loading
    case loaded([Recording])
}

@Observable final class ArtistDetailsViewModel {
    
    let artist: ArtistMB
    let repository: AlbumsLoader
    var isFavorite = false
    var state = ArtisDetailsState.loading
    private let storage: PersistentStorage<[ArtistMB]>
    
    private let baseURL = URL(string: "https://musicbrainz.org/ws/2/recording/")!
    
    @MainActor
    func start() async {
        isFavorite = (storage.load() ?? []).contains(artist)
        
        let url = baseURL.appending(queryItems: [
            .init(name: "query", value: "arid:\(artist.id)"),
            .init(name: "fmt", value: "json"),
        ])
        do {
            let albums = try await repository.fetch(at: url).recordings
            state = .loaded(albums)
        } catch {
            // TODO: Add error state
            print(error)
        }
    }
    
    func addOrRemoveToFavorites() {
        var favorites = storage.load() ?? []
        if isFavorite {
            favorites.removeAll {
                $0 == artist
            }
            isFavorite = false
        } else {
            favorites.append(artist)
            isFavorite = true
        }
        storage.save(item: favorites)
    }
    
    init(artist: ArtistMB,
         repository: AlbumsLoader = AlbumsRepository(),
         storage: PersistentStorage<[ArtistMB]> = .init(storageKey: PersistentStorage.key())) {
        self.repository = repository
        self.artist = artist
        self.storage = storage
    }
}
