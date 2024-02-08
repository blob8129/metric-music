//
//  PersistentStorage.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 08/02/2024.
//

import Foundation

extension UserDefaults: AnyStorage {}

protocol AnyStorage {
    func set(_ value: Any?, forKey defaultName: String)
    func data(forKey defaultName: String) -> Data?
    func removeObject(forKey defaultName: String)
}

struct PersistentStorage<StoredItemType: Codable> {

    private let defaults: AnyStorage
    private let storageKey: String

    func save(item: StoredItemType) {
        guard let data = try? JSONEncoder().encode(item) else { return }
        defaults.set(data, forKey: storageKey)
    }

    func load() -> StoredItemType? {
        guard let data = defaults.data(forKey: storageKey) else { return nil }
        return try? JSONDecoder().decode(StoredItemType.self, from: data)
    }

    func reset() {
        defaults.removeObject(forKey: storageKey)
    }

    init(storageKey: String, defaults: AnyStorage = UserDefaults.standard) {
        self.storageKey = storageKey
        self.defaults = defaults
    }
}

extension PersistentStorage where StoredItemType == [ArtistMB] {
    static func key() -> String {
        "ArtistMBPersistentStorageKey"
    }
}

