//
//  InputDebounceObserver.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Combine
import SwiftUI

@MainActor
final class InputDebounceObserver: ObservableObject {
    
    @Published var input = ""
    @Published private(set) var output = ""

    init() {
        $input
            .debounce(for: .seconds(0.25), scheduler: RunLoop.main)
            .assign(to: &$output)
    }
}
