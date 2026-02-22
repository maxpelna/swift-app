//
//  AppView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct AppView: View {
    @State private var coordinator = Coordinator()
    @State private var errorHandler = ErrorHandler()
    @State private var analyticsLogger = AnalyticsLogger()
    @State private var viewModel = AppViewModel()

    @Environment(\.scenePhase)
    private var scenePhase

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ErrorOverlay {
                ZStack {
                    coordinator.build(page: viewModel.appState.toRoute())
                        .animation(.smooth, value: viewModel.appState)

                    if !viewModel.isConnected {
                        NoConnectionView()
                    }
                }
            }
            .navigationDestination(for: PageRoute.self) { route in
                coordinator.build(page: route)
            }
            .sheet(item: $coordinator.sheet) { route in
                coordinator.build(sheet: route)
            }
        }
        .task {
            viewModel.addEvent(.startApp)
            viewModel.addEvent(.listenStats)
            viewModel.addEvent(.listenConnectivity)
        }
        .onChange(of: viewModel.appTheme) { _, newValue in
            triggerThemeChange(newValue)
        }
        .onOpenURL { url in
            guard let deepLink = DeepLink(url: url) else { return }
            coordinator.handleDeepLink(deepLink)
        }
        .overlay {
            if scenePhase != .active {
                SplashView()
                    .ignoresSafeArea()
            }
        }
        .environment(\.coordinator, coordinator)
        .environment(\.errorHandler, errorHandler)
        .environment(\.analyticsLogger, analyticsLogger)
    }
}
