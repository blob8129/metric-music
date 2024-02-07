//
//  ArtistDetailsViewModel.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 07/02/2024.
//

import Foundation

struct Release: Codable, Equatable, Hashable, Identifiable {
    let id: UUID
    let releaseGroup: ReleaseGroup?
    
    enum CodingKeys: String, CodingKey {
        case id
        case releaseGroup = "release-group"
    }
}

struct ReleaseGroup: Codable, Hashable, Equatable {
    let primaryType: String?
    
    enum CodingKeys: String, CodingKey {
        case primaryType = "primary-type"
    }
}

struct Recording: Codable, Hashable, Identifiable {
    let id: UUID
    let title: String
    let releases: [Release]?
    let firstReleaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releases
        case firstReleaseDate = "first-release-date"
    }
    
    var firstReleasePrimaryType: String {
        releases?.first?.releaseGroup?.primaryType ?? "-"
    }
}

struct AlbumsContainer: Codable {
    let recordings: [Recording]
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
            URLQueryItem(name: "fmt", value: "json"),
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
