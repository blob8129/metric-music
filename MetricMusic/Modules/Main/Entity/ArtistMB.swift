//
//  ArtistMB.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 06/02/2024.
//

import Foundation

struct ArtistMB: Codable, Identifiable, Hashable {
    let id: UUID
    let type: String?
    let name: String
    let country: String?
}

struct ArtistsContainer: Codable {
    let artists: [ArtistMB]
}
