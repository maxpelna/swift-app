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

    @Environment(Coordinator.self)
    private var coordinator

    @Environment(AnalyticsLogger.self)
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
        coordinator.presentSheet(
            .appThemePicker(
                ThemePickerViewConfig(
                    selectedTheme: viewModel.selectedTheme
                ) { theme in
                    logger.log(
                        AnalyticsEvent(
                            name: AnalyticsEventName.onThemeSwitchTap,
                            parameters: [AnalyticsParameterEventName.theme.rawValue: theme.rawValue]
                        )
                    )
                    coordinator.dismissSheet()
                    triggerThemeChange(theme)
                    viewModel.addEvent(.changeTheme(theme))
                }
            )
        )
    }

    private func onResetAllTap() {
        logger.log(AnalyticsEvent(name: .onEraseTap))
        showResetAlert = true
    }

    private func onConfirmTap() {
        viewModel.addEvent(.resetStats)
        coordinator.popToRoot()
    }
}
