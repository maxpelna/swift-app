//
//  ErrorOverlay.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct ErrorOverlay<Content: View>: View {

    @ViewBuilder var content: () -> Content

    @Environment(\.errorHandler) private var errorHandler

    var body: some View {
        content()
            .overlay {
                if let message = errorHandler.errorMessage {
                    VStack {
                        Spacer()

                        HStack {
                            Image(systemName: Icons.warning)
                                .font(.system(size: 16))

                            Spacer().frame(width: 8)

                            Text(message)
                                .captionPrimary()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.backgroundDanger)
                        .clipShape(Capsule())
                        .padding()
                        .padding(.bottom, 60)
                    }
                    .transition(
                        .opacity
                            .animation(.spring(duration: 0.3))
                    )
                }
            }
    }
}
