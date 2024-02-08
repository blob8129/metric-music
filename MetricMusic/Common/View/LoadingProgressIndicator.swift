//
//  LoadingProgressIndicator.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 08/02/2024.
//

import SwiftUI

struct LoadingProgressIndicator: View {
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                ProgressView()
                    .padding()
                    .progressViewStyle(.circular)
                Spacer()
            }
        }
    }
}
