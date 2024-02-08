//
//  ArtistRepository.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 08/02/2024.
//

import Foundation

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
