//
//  NetworkingService.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 06/02/2024.
//

import Foundation

protocol BasicNetworkService {
    func loadData(at url: URL) async throws -> Data
}

protocol URLSessionProtocol {
    func data(from url: URL, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

final class NetworkService: BasicNetworkService {
    
    private let session: URLSessionProtocol
    
    func loadData(at url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url, delegate: nil)
        return data
    }
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}
