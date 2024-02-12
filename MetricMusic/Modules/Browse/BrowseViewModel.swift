//
//  MainViewModel.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 02/02/2024.
//

import SwiftUI
import Combine

enum SuggestionsState: Equatable {
    case input
    case loading
    case loaded(suggestions: [ArtistMB])
}

@Observable final class BrowseViewModel {
    
    var suggestionsState = SuggestionsState.input
    var artistPath = [ArtistMB]()
    var favoriteArtists = [ArtistMB]()
    
    private let repository: ArtistRepositoryProtocol
    private let baseURL = URL(string: "https://musicbrainz.org/ws/2/artist/")!
    private let storage: PersistentStorage<[ArtistMB]>
    private let debouncer: Debouncer
    
    var loadSuggestionsTask: Task<Void, Never>?
    
    var searchTerm = "" {
        willSet {
            debouncer.debounce {
                self.debouce(term: newValue)
            }
        }
    }
    
    @MainActor
    func start() async {
        favoriteArtists = storage.load() ?? []
    }
    
    @MainActor
    func loadSuggestions(searhTerm: String) async {
        guard !searhTerm.isEmpty else {
            suggestionsState = .input
            return
        }
        let url = baseURL.appending(queryItems: [
            .init(name: "query", value: "artist:\(searhTerm)"),
            .init(name: "fmt", value: "json")
        ])
        do {
            suggestionsState = .loading
            let artistSuggestions = try await repository.fetch(at: url).artists
            guard !Task.isCancelled else {
                return
            }
            suggestionsState = .loaded(suggestions: artistSuggestions)
        } catch {
            // TODO: Handle error
            print(error)
        }
    }
    
    func debouce(term: String) {
        loadSuggestionsTask?.cancel()
        loadSuggestionsTask = Task {
            await loadSuggestions(searhTerm: term)
        }
    }
    
    func navigate(to artist: ArtistMB) {
        searchTerm = ""
        suggestionsState = .input
        artistPath.append(artist)
    }
    
    init(repository: ArtistRepositoryProtocol = ArtistRepository(),
         storage: PersistentStorage<[ArtistMB]> = PersistentStorage(storageKey: PersistentStorage.key()),
         debouncer: Debouncer = Debouncer(debounceInterval: 1)) {
        self.repository = repository
        self.storage = storage
        self.debouncer = debouncer
    }
}
