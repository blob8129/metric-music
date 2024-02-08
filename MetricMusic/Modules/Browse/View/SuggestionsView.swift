//
//  SuggestionsView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 08/02/2024.
//

import SwiftUI

struct SuggestionsView: View {
   
    let suggestionsState: SuggestionsState
    let suggestionSelectedAction: (ArtistMB) -> ()
    
    var body: some View {
        switch suggestionsState {
        case .input:
            Group {}
        case .loading:
            LoadingProgressIndicator()
        case .loaded(let suggestions):
            ForEach(suggestions) { artist in
                Button {
                    suggestionSelectedAction(artist)
                } label: {
                    AristSuggestionView(artist: artist)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
