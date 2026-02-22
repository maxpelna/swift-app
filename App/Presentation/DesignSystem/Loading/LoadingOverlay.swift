//
//  LoadingOverlay.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct LoadingOverlay<Content: View>: View {
    let isLoading: Bool

    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .overlay {
                if isLoading {
                    ZStack {
                        Color.backgroundSecondary
                            .background(.ultraThinMaterial)
                            .opacity(Opacity.dim)
                            .edgesIgnoringSafeArea(.all)
                            .frame(
                                width: Sizes.containerSmall,
                                height: Sizes.containerSmall
                            )
                            .cornerRadius(Radius.large)

                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.accentColor)
                    }
                    .transition(
                        .scale.animation(.snappy(duration: Duration.transition))
                    )
                }
            }
    }
}
