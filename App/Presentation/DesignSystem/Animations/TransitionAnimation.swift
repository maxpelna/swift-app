//
//  TransitionAnimation.swift
//  swift-app
//
//  Created by Maksims Pelna on 22/02/2026.
//

import SwiftUI

extension View {
    func slideFromBottom() -> some View {
        self.transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
