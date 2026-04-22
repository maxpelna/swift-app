//
//  OnboardingView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()

    @Environment(AnalyticsLogger.self)
    private var logger

    var body: some View {
        VStack {
            Spacer()

            Text(.onboardingDescription)

            Spacer()

            Button(action: onFinishTap) {
                Text(.generalFinish)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.extraLarge)
        }
        .padding()
    }

    private func onFinishTap() {
        logger.log(AnalyticsEvent(name: .onFinishOnboardingTap))
        viewModel.addEvent(.finishOnboarding)
    }
}
