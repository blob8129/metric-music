//
//  MainViewModel.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 02/02/2024.
//

import SwiftUI
import Combine

struct ArtistRepository: RepositoryProtocol, ArtistRepositoryProtocol {
    typealias Entity = ArtistsContainer
    
    let networkService: BasicNetworkService
    let decoder: JSONDecoder
    
    init(networkService: BasicNetworkService = NetworkService(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.networkService = networkService
        self.decoder = decoder
    }
}

protocol ArtistRepositoryProtocol {
    func fetch(at url: URL) async throws -> ArtistsContainer
}

enum SuggestionsState {
    case input
    case loading
    case loaded(suggestions: [ArtistMB])
}

@Observable final class MainViewModel {
    
    var suggestionsState = SuggestionsState.input
    var artistPath = [ArtistMB]()
    var favoriteArtists = [ArtistMB]()
    
    private let subject = PassthroughSubject<String, Never>()
    private var allCancellables = Set<AnyCancellable>()
    private let repository: ArtistRepositoryProtocol
    private let baseURL = URL(string: "https://musicbrainz.org/ws/2/artist/")!
    private let storage: PersistentStorage<[ArtistMB]>
    
    var searchTerm = "" {
        didSet {
            debounce(searchTerm)
        }
    }
    
    @MainActor
    func start() async {
        favoriteArtists = storage.load() ?? []
        subject.debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { term in
                Task {
                    await self.loadArtists(searhTerm: term)
                }
            }.store(in: &allCancellables)
    }
    
    private func loadArtists(searhTerm: String) async {
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
            suggestionsState = .loaded(suggestions: artistSuggestions)
        } catch {
            // TODO: Handle error
            print(error)
        }
    }
    
    private func debounce(_ searchTerm: String) {
        subject.send(searchTerm)
    }
    
    func navigate(to artist: ArtistMB) {
        searchTerm = ""
        suggestionsState = .input
        artistPath.append(artist)
    }
    
    init(repository: ArtistRepositoryProtocol = ArtistRepository(),
         storage: PersistentStorage<[ArtistMB]> = PersistentStorage(storageKey: PersistentStorage.key())) {
        self.repository = repository
        self.storage = storage
    }
}
