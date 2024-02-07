//
//  MetricMusicApp.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 02/02/2024.
//

import SwiftUI

@main
struct MetricMusicApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel(repository: ArtistRepository()))
                .tint(Color(.systemRed))
        }
    }
}
