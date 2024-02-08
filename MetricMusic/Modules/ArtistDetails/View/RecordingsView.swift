//
//  RecordingsView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 08/02/2024.
//

import SwiftUI

struct RecordingsView: View {
   
    let recordings: [Recording]
    
    var body: some View {
        List {
            Text("Recordings")
                .foregroundStyle(.secondary)
            ForEach(recordings) { recording in
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(recording.title)
                                .font(.headline)
                            Text(recording.firstReleaseDate ?? "")
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("release")
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                            Text(recording.firstReleasePrimaryType)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}
