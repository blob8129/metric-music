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
        value = nil 
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

final class BrowseViewModelTests: XCTestCase {

    
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
    
    func testInputSuggestionsState() async throws {
        let viewModel = BrowseViewModel.build()
        
        await viewModel.start()
        await viewModel.loadSuggestions(searhTerm: "")
        
        XCTAssertEqual(viewModel.suggestionsState, .input)
    }
    
    func testLoadedSuggestions() async throws {
        let suggestions = [
            ArtistMB(id: UUID(), type: "test type 1", name: "test name 1", country: "test country 1"),
            .init(id: UUID(), type: "test type 2", name: "test name 2", country: "test country 2")
        ]
        let viewModel = BrowseViewModel.build(suggestions: suggestions)
        
        await viewModel.start()
        await viewModel.loadSuggestions(searhTerm: "123")
        
        XCTAssertEqual(viewModel.suggestionsState, .loaded(suggestions: suggestions))
    }
    
    func testNavagationToArtist() async throws {
        
        let viewModel = BrowseViewModel.build()
        await viewModel.start()
        
        let artistToNavigate = ArtistMB(id: UUID(), type: "test type 1", name: "test name 1", country: "test country 1")
        viewModel.navigate(to: artistToNavigate)
        
        XCTAssertEqual(viewModel.artistPath, [artistToNavigate])
    }
}

extension BrowseViewModel {
    static func build(suggestions: [ArtistMB]? = nil, favoriteArtists: [ArtistMB]? = nil) -> BrowseViewModel {
        let storageDefaults = ArtistStotageStub()
        storageDefaults.value = favoriteArtists
        let artistRepositorStub = ArtistRepositorStub()
        artistRepositorStub.value = suggestions.flatMap { ArtistsContainer(artists: $0) }
        return BrowseViewModel(repository: artistRepositorStub,
                               storage: PersistentStorage(storageKey: "", defaults: storageDefaults))
    }
}
