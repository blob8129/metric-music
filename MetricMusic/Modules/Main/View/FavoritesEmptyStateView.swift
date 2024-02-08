//
//  FavoritesEmptyStateView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 08/02/2024.
//

import SwiftUI

struct FavoritesEmptyStateView: View {
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "star.fill")
                .font(.largeTitle)
                .foregroundStyle(.tint)
            Text("No favorite artists")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
