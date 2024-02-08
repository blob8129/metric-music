//
//  AlbumsRepository.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 08/02/2024.
//

import Foundation

protocol AlbumsLoader {
    func fetch(at url: URL) async throws -> RecordingsContainer
}

final class AlbumsRepository: RepositoryProtocol, AlbumsLoader {
    let networkService: BasicNetworkService
    let decoder: JSONDecoder
    
    typealias Entity = RecordingsContainer
    
    init(networkService: BasicNetworkService = NetworkService(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.networkService = networkService
        self.decoder = decoder
    }
}
