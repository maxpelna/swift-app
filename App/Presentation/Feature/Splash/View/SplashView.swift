//
//  SplashView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = true

    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()

            VStack {
                Image(systemName: Icons.splash)
                    .resizable()
                    .accessibilityHidden(true)
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.tint)
                    .symbolEffect(
                        .drawOff.byLayer,
                        options: .speed(Duration.micro),
                        isActive: isAnimating
                    )
                    .padding(Spacing.massive)
            }
            .frame(maxHeight: .infinity, alignment: .center)
        }
        .task {
            isAnimating = false
        }
    }
}
