//
//  NoConnectionView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct NoConnectionView: View {
    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()

            VStack(spacing: Spacing.xLarge) {
                Text(.noNetworkConnectionTitle)
                    .headerPrimary()
                    .bold()

                Image(systemName: Icons.noNetworkConnection)
                    .resizable()
                    .accessibilityHidden(true)
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.tint)
                    .symbolEffect(.breathe, options: .repeat(.continuous))
                    .padding(Spacing.huge)
            }
            .frame(maxHeight: .infinity, alignment: .center)
        }
    }
}
