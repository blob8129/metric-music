//
//  ArtistDetailsViewModelTests.swift
//  MetricMusicTests
//
//  Created by Andrey Volobuev on 08/02/2024.
//

import XCTest
@testable import MetricMusic

class AlbumsLoaderStub: AlbumsLoader {
    
    var value: RecordingsContainer?
    
    func fetch(at url: URL) async throws -> RecordingsContainer {
        guard let value else {
            throw TestError.testError
        }
        return value
    }
}

final class ArtistDetailsViewModelTests: XCTestCase {

    let testArtist = ArtistMB(id: UUID(), type: "test type", name: "test name", country: "test country")
    
    func testisAlreadyFavorite() async throws {
        let viewModel = ArtistDetailsViewModel.build(artist: testArtist, favoriteArtists: [testArtist])

        await viewModel.start()
        
        XCTAssertTrue(viewModel.isFavorite)
    }
    
    func testAddToFavorites() async throws {
        let viewModel = ArtistDetailsViewModel.build(artist: testArtist)
        
        await viewModel.start()
        viewModel.addOrRemoveToFavorites()
        
        XCTAssertTrue(viewModel.isFavorite)
    }
    
    func testRemoveFromFavorites() async throws {
        let viewModel = ArtistDetailsViewModel.build(artist: testArtist, favoriteArtists: [testArtist])
        
        await viewModel.start()
        viewModel.addOrRemoveToFavorites()
        
        XCTAssertFalse(viewModel.isFavorite)
    }
    
    func testLoadingRecordings() async throws {
        let viewModel = ArtistDetailsViewModel.build(artist: testArtist)
        
        await viewModel.start()

        XCTAssertEqual(viewModel.state, .loading)
    }
    
    func testLoadedRecordings() async throws {
        let testRecordings = [
            Recording(id: UUID(), title: "Nevermind", releases: [
                .init(id: UUID(), releaseGroup: .init(primaryType: "Album"))
            ], firstReleaseDate: "1992"),
            .init(id: UUID(), title: "In Utero", releases: [
                .init(id: UUID(), releaseGroup: .init(primaryType: "Single"))
            ], firstReleaseDate: "1994"),
        ]
        let viewModel = ArtistDetailsViewModel.build(
            artist: testArtist,
            recordings: testRecordings
        )
        
        await viewModel.start()

        XCTAssertEqual(viewModel.state, .loaded(testRecordings))
    }
}

extension ArtistDetailsViewModel {
    static func build(artist: ArtistMB, favoriteArtists: [ArtistMB]? = nil, recordings: [Recording]? = nil) -> ArtistDetailsViewModel {
        let storageDefaults = ArtistStotageStub()
        storageDefaults.value = favoriteArtists
        let albumsLoaderStub = AlbumsLoaderStub()
        albumsLoaderStub.value = recordings.flatMap { RecordingsContainer(recordings: $0) }
        return ArtistDetailsViewModel(artist: artist,
                                      repository: albumsLoaderStub,
                                      storage: PersistentStorage(storageKey: "", defaults: storageDefaults))
        
    }
}
