//
//  Repository.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 06/02/2024.
//

import Foundation

protocol RepositoryProtocol {
    associatedtype Entity: Decodable

    var networkService: BasicNetworkService { get }
    var decoder: JSONDecoder { get }

    func fetch(at url: URL) async throws -> Entity
}

extension RepositoryProtocol {
    func fetch(at url: URL) async throws -> Entity {
        let data = try await networkService.loadData(at: url)
        return try decoder.decode(Entity.self, from: data)
    }
}
