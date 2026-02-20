//
//  SettingsView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    @State private var showResetAlert: Bool = false

    @Environment(\.coordinator)
    private var coordinator

    @Environment(\.analyticsLogger)
    private var logger

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
        .task {
            viewModel.addEvent(.initialLoad)
        }
        .onChange(of: viewModel.selectedTheme) { _, newValue in
            triggerThemeChange(newValue)
        }
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
        logger.log(AnalyticsEvent(name: .onLanguageTap))
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    private func onThemeTap() {
        logger.log(AnalyticsEvent(name: .onThemeSwitchTap))
        coordinator.presentSheet(
            .appThemePicker(
                ThemePickerViewConfig(
                    selectedTheme: viewModel.selectedTheme
                ) { theme in
                    coordinator.dismissSheet()
                    triggerThemeChange(theme)
                    viewModel.addEvent(.changeTheme(theme))
                }
            )
        )
    }

    private func onResetAllTap() {
        logger.log(AnalyticsEvent(name: .onEraseTap))
        showResetAlert.toggle()
    }

    private func onConfirmTap() {
        viewModel.addEvent(.resetStats)
        coordinator.popToRoot()
    }
}
