//
//  RecordingsContainer.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 08/02/2024.
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

struct RecordingsContainer: Codable {
    let recordings: [Recording]
}
