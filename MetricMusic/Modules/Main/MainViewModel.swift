//
//  MainViewModel.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 02/02/2024.
//

import SwiftUI
import Combine

@Observable class MainViewModel {
    private let subject = PassthroughSubject<String, Never>()
    private var allCancellables = Set<AnyCancellable>()
    
    var searchTerm = "" {
        didSet {
            debounce(searchTerm)
        }
    }
    
    func start() {
        subject.debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { term in
                print("debounce term, \(term)")
            }.store(in: &allCancellables)
    }
    
    func debounce(_ searchTerm: String) {
        subject.send(searchTerm)
    }
}
