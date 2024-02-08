//
//  ArtistDetailsViewModel.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 07/02/2024.
//

import Foundation

extension PersistentStorage where StoredItemType == [ArtistMB] {
    static func key() -> String {
        "ArtistMBPersistentStorageKey"
    }
}

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

enum ArtisDetailsState {
    case loading
    case loaded([Recording])
}

@Observable final class ArtistDetailsViewModel {
    
    let artist: ArtistMB
    let repository: AlbumsLoader
    var isFavorite = false
    var state: ArtisDetailsState
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
         state: ArtisDetailsState = .loading,
         storage: PersistentStorage<[ArtistMB]> = .init(storageKey: PersistentStorage.key())) {
        self.repository = repository
        self.artist = artist
        self.state = state
        self.storage = storage
    }
}
