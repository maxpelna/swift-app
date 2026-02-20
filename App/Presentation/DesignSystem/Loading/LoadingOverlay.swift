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
                            .opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: 80, height: 80)
                            .cornerRadius(20)

                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.accentColor)
                    }
                    .transition(
                        .scale
                            .combined(with: .opacity)
                            .animation(.snappy(duration: 0.3))
                    )
                }
            }
    }
}
