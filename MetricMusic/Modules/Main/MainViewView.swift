//
//  ContentView.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 02/02/2024.
//

import SwiftUI

struct MainViewView: View {
    
    @Bindable var viewModel: MainViewModel
    
    var body: some View {
        NavigationStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear(perform: {
            viewModel.start()
        })
        .searchable(text: $viewModel.searchTerm)
    }
}

#Preview {
    MainViewView(viewModel: MainViewModel())
}
