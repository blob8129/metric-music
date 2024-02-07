//
//  ArtistDetailsViewModel.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 07/02/2024.
//

import Foundation

struct Album: Codable, Hashable, Identifiable {
    let id: UUID
    let title: String
}

struct AlbumsContainer: Codable {
    let recordings: [Album]
}

protocol AlbumsLoader {
    func fetch(at url: URL) async throws -> AlbumsContainer
}

final class AlbumsRepository: RepositoryProtocol, AlbumsLoader {
    let networkService: BasicNetworkService
    let decoder: JSONDecoder
    
    typealias Entity = AlbumsContainer
    
    init(networkService: BasicNetworkService = NetworkService(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.networkService = networkService
        self.decoder = decoder
    }
}

@Observable final class ArtistDetailsViewModel {
    
    let artist: ArtistMB
    let repository: AlbumsLoader
    var state: ArtisDetailsState
    
    private let baseURL = URL(string: "https://musicbrainz.org/ws/2/recording/")!
    
    @MainActor
    func loadAlbums() async {
        let url = baseURL.appending(queryItems: [
            URLQueryItem(name: "query", value: "arid:\(artist.id)"),
            URLQueryItem(name: "fmt", value: "json")
        ])
        print(url)
        do {
            let albums = try await repository.fetch(at: url).recordings
            state = .loaded(albums)
        } catch {
           print(error)
        }
    }
    
    init(artist: ArtistMB,
         repository: AlbumsLoader = AlbumsRepository(),
         state: ArtisDetailsState = .loading) {
        self.repository = repository
        self.artist = artist
        self.state = state
    }
}
