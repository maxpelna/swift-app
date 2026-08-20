//
//  OnboardingView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct OnboardingView: View, AnalyticsServiceInjectable {
    @State private var viewModel = OnboardingViewModel()

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
        analyticsService.log(AnalyticsEvent(name: .onFinishOnboardingTap))
        viewModel.finishOnboarding()
    }
}
