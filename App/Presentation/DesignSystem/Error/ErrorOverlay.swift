//
//  ErrorOverlay.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct ErrorOverlay<Content: View>: View {
    @ViewBuilder var content: () -> Content

    @Environment(\.errorHandler)
    private var errorHandler

    var body: some View {
        content()
            .overlay {
                if let message = errorHandler.errorMessage {
                    VStack {
                        Spacer()

                        HStack {
                            Image(systemName: Icons.warning)
                                .font(.system(size: Sizes.iconSmall))
                                .accessibilityHidden(true)

                            Spacer().frame(width: Spacing.small)

                            Text(message)
                                .captionPrimary()
                        }
                        .padding(.vertical, Spacing.small)
                        .padding(.horizontal, Spacing.medium)
                        .background(Color.backgroundDanger)
                        .clipShape(Capsule())
                        .padding()
                    }
                    .transition(
                        .opacity
                            .animation(.spring(duration: Duration.transition))
                    )
                }
            }
    }
}
