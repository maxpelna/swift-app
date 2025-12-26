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

            VStack(spacing: 20) {
                Text(.noNetworkConnectionTitle)
                    .headerPrimary()
                    .bold()

                Image(systemName: Icons.noNetworkConnection)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.tint)
                    .symbolEffect(.breathe, options: .repeat(.continuous))
                    .padding(100)
            }
            .frame(maxHeight: .infinity, alignment: .center)
        }
    }
}
