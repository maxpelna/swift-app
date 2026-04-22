//
//  AppView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct AppView: View {
    @State private var viewModel = AppViewModel(splashDurationInMilliseconds: 1_000)

    @Environment(\.scenePhase)
    private var scenePhase

    @Environment(Coordinator.self)
    private var coordinator

    var body: some View {
        @Bindable var coordinator = coordinator

        Group {
            switch viewModel.appState {
            case .loading:
                SplashView()
                    .slideFromBottom()

            case .clean:
                OnboardingView()
                    .slideFromBottom()

            case .authorized:
                NavigationStack(path: $coordinator.path) {
                    ErrorOverlay {
                        CharactersListView()
                    }
                    .navigationDestination(for: PageRoute.self) { route in
                        coordinator.build(page: route)
                    }
                    .sheet(item: $coordinator.sheet) { route in
                        coordinator.build(sheet: route)
                    }
                }
                .slideFromBottom()
            }
        }
        .animation(.smooth, value: viewModel.appState)
        .task {
            viewModel.addEvent(.startApp)
        }
        .onChange(of: viewModel.appTheme) { _, newValue in
            triggerThemeChange(newValue)
        }
        .onOpenURL { url in
            guard let deepLink = DeepLink(url: url) else { return }
            coordinator.handleDeepLink(deepLink)
        }
        .overlay {
            if !viewModel.isConnected {
                NoConnectionView()
            }

            if scenePhase != .active {
                SplashView()
                    .ignoresSafeArea()
            }
        }
    }
}
