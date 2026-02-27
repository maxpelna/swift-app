//
//  SecretView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct SecretView: View {
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()

            VStack(spacing: Spacing.xxLarge) {
                Image(systemName: Icons.secret)
                    .resizable()
                    .accessibilityHidden(true)
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.tint)
                    .frame(width: Sizes.iconHero, height: Sizes.iconHero)
                    .symbolEffect(.breathe.byLayer, options: .repeating)
                    .scaleEffect(appeared ? 1 : 0.3)
                    .animation(.spring(response: 0.6, dampingFraction: 0.45), value: appeared)
            }
        }
        .navigationTitle(String(localized: .secretTitle))
        .onAppear {
            appeared = true
        }
    }
}
