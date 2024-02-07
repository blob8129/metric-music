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

@Observable final class MainViewModel {
    
    var artists = [ArtistMB]()
    var artistPath = [ArtistMB]()
    
    private let subject = PassthroughSubject<String, Never>()
    private var allCancellables = Set<AnyCancellable>()
    private let repository: ArtistRepositoryProtocol
    private let baseURL = URL(string: "https://musicbrainz.org/ws/2/artist/")!
    
    var searchTerm = "" {
        didSet {
            debounce(searchTerm)
        }
    }
    
    func start() async {
        subject.debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { term in
                Task {
                    await self.loadArtists(searhTerm: term)
                }
            }.store(in: &allCancellables)
    }
    
    private func loadArtists(searhTerm: String) async {
        guard !searhTerm.isEmpty else {
            artists = []
            return
        }
        let url = baseURL.appending(queryItems: [
            URLQueryItem(name: "query", value: "artist:\(searhTerm)"),
            URLQueryItem(name: "fmt", value: "json")
        ])
        do {
            artists = try await repository.fetch(at: url).artists
            print(artists)
        } catch {
           print(error)
        }
    }
    
    private func debounce(_ searchTerm: String) {
        subject.send(searchTerm)
    }
    
    func navigate(to artist: ArtistMB) {
        searchTerm = ""
        artists = []
        artistPath.append(artist)
    }
    
    init(repository: ArtistRepositoryProtocol) {
        self.repository = repository
    }
}
