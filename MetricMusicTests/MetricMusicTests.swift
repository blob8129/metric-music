//
//  MetricMusicTests.swift
//  MetricMusicTests
//
//  Created by Andrey Volobuev on 02/02/2024.
//

import XCTest
@testable import MetricMusic

class ArtistStotageStub: AnyStorage {
    
    var value: [ArtistMB]?
    var setValue: Any?
    
    func set(_ value: Any?, forKey defaultName: String) {
        setValue = value
    }
    
    func data(forKey defaultName: String) -> Data? {
        guard let value else {
            return nil
        }
        return try? JSONEncoder().encode(value)
    }
    
    func removeObject(forKey defaultName: String) {
        
    }
}

class ArtistRepositorStub: ArtistRepositoryProtocol {
    
    var value: ArtistsContainer?
    
    func fetch(at url: URL) async throws -> ArtistsContainer {
        guard let value else {
            throw TestError.testError
        }
        return value
    }
}

enum TestError: Error {
    case testError
}

final class MetricMusicTests: XCTestCase {

    
    func testFavoriteArtistsEmpty() async throws {
        
        let viewModel = BrowseViewModel.build()
        await viewModel.start()
        
        XCTAssertTrue(viewModel.favoriteArtists.isEmpty)
    }
    
    func testFavoriteArtistsSaved() async throws {
        let favoriteArtists = [
            ArtistMB(id: UUID(), type: "test type 1", name: "test name 1", country: "test country 1"),
            .init(id: UUID(), type: "test type 2", name: "test name 2", country: "test country 2")
        ]
        let viewModel = BrowseViewModel.build(favoriteArtists: favoriteArtists)
        await viewModel.start()

        XCTAssertEqual(viewModel.favoriteArtists, favoriteArtists)
    }
}


extension BrowseViewModel {
    static func build(favoriteArtists: [ArtistMB]? = nil) -> BrowseViewModel {
        var storageDefaults = ArtistStotageStub()
        storageDefaults.value = favoriteArtists
        return BrowseViewModel(repository: ArtistRepositorStub(),
                               storage: PersistentStorage(storageKey: "", defaults: storageDefaults))
    }
}
