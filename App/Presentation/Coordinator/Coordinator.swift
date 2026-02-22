//
//  Coordinator.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

@Observable
final class Coordinator {
    var path = NavigationPath()
    var sheet: SheetRoute?

    func pushPage(_ pageRoute: PageRoute) {
        path.append(pageRoute)
    }

    func popPage() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    func reload() {
        path = NavigationPath()
    }

    func presentSheet(_ sheetRoute: SheetRoute) {
        self.sheet = sheetRoute
    }

    func dismissSheet() {
        self.sheet = nil
    }

    func handleDeepLink(_ deepLink: DeepLink) {
        popToRoot()
        switch deepLink {
        case .secret:
            pushPage(.secret)
        }
    }

    @ViewBuilder
    func build(page: PageRoute) -> some View {
        switch page {
        case .splash:
            SplashView()
                .transition(.move(edge: .bottom).combined(with: .opacity))

        case .onboarding:
            OnboardingView()
                .transition(.move(edge: .bottom).combined(with: .opacity))

        case .charactersList:
            CharactersListView()
                .transition(.move(edge: .bottom).combined(with: .opacity))

        case .settings:
            SettingsView()

        case .secret:
            SecretView()
        }
    }

    @ViewBuilder
    func build(sheet: SheetRoute) -> some View {
        switch sheet {
        case .charactersFilter(let viewConfig):
            CharactersFilterSheet(viewConfig: viewConfig)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)

        case .appThemePicker(let viewConfig):
            ThemePickerSheet(viewConfig: viewConfig)
                .presentationDetents([.height(Sizes.sheetCompact)])
                .presentationDragIndicator(.visible)
        }
    }
}
