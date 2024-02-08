//
//  Debouncer.swift
//  MetricMusic
//
//  Created by Andrey Volobuev on 08/02/2024.
//

import Foundation

final class Debouncer {

    private let debounceInterval: TimeInterval
    private var timer: Timer?
    
    func debounce(callback: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: debounceInterval, repeats: false) { _ in
            callback()
        }
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    init(debounceInterval: TimeInterval) {
        self.debounceInterval = debounceInterval
    }
}
