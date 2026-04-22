//
//  InputDebouncerObserver.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Combine
import SwiftUI

final class InputDebouncerObserver: ObservableObject {
    @Published var input = ""
    @Published private(set) var output = ""

    init() {
        $input
            .debounce(for: .seconds(Duration.debounce), scheduler: RunLoop.main)
            .assign(to: &$output)
    }
}
