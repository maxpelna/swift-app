//
//  SettingsView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct SettingsView: View, AnalyticsServiceInjectable {
    @State private var viewModel = SettingsViewModel()
    @State private var showResetAlert: Bool = false

    @Environment(Coordinator.self)
    private var coordinator

    var body: some View {
        List {
            Button {
                onLanguageTap()
            } label: {
                Text(.settingsLanguage)
                    .bodyRegular()
            }

            Button {
                onThemeTap()
            } label: {
                Text(.settingsAppearance)
                    .bodyRegular()
            }

            Button {
                onResetAllTap()
            } label: {
                Text(.settingsResetAll)
                    .bodyRegular()
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary)
        .navigationTitle(.settingsTitle)
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text(.settingsResetAlertTitle),
                message: Text(.settingsResetAlertDescription),
                primaryButton: .destructive(Text(.settingsResetAlertButton), action: onConfirmTap),
                secondaryButton: .default(Text(.generalCancel))
            )
        }
    }

    private func onLanguageTap() {
        analyticsService.log(AnalyticsEvent(name: .onLanguageTap))
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    private func onThemeTap() {
        coordinator.presentSheet(
            .appThemePicker(
                ThemePickerViewConfig(
                    selectedTheme: viewModel.selectedTheme
                ) { theme in
                    analyticsService.log(
                        AnalyticsEvent(
                            name: AnalyticsEventName.onThemeSwitchTap,
                            parameters: [AnalyticsParameterEventName.theme.rawValue: theme.rawValue]
                        )
                    )
                    coordinator.dismissSheet()
                    viewModel.changeTheme(theme)
                }
            )
        )
    }

    private func onResetAllTap() {
        analyticsService.log(AnalyticsEvent(name: .onEraseTap))
        showResetAlert = true
    }

    private func onConfirmTap() {
        viewModel.resetStats()
        coordinator.popToRoot()
    }
}
