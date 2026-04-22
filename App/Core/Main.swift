//
//  Main.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI
import Nuke

@main
struct Main: App {
    @State private var coordinator = Coordinator()
    @State private var errorHandler = ErrorHandler()
    @State private var analyticsLogger = AnalyticsLogger()

    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .environment(coordinator)
        .environment(errorHandler)
        .environment(analyticsLogger)
    }

    init() {
        initImagePipeline()
    }

    private func initImagePipeline() {
        ImagePipeline.shared = ImagePipeline(
            configuration: .withDataCache(
                name: EnvConfig.bundleId + ".ImageCache",
                sizeLimit: 200 * 1_024 * 1_024
            )
        )
    }
}
