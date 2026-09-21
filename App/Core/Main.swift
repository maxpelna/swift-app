//
//  Main.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

@main
struct Main: App {
    @State private var coordinator = Coordinator()
    @State private var errorHandler = ErrorHandler()

    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .environment(coordinator)
        .environment(errorHandler)
    }
}
