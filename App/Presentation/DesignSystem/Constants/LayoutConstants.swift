//
//  LayoutConstants.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import CoreFoundation

enum Spacing {
    static let extraSmall: CGFloat = 2
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xLarge: CGFloat = 20
    static let xxLarge: CGFloat = 24
    static let huge: CGFloat = 100
    static let massive: CGFloat = 120
}

enum Size {
    static let iconSmall: CGFloat = 16
    static let iconLarge: CGFloat = 40
    static let avatarMedium: CGFloat = 64
    static let containerSmall: CGFloat = 80
    static let sheetCompact: CGFloat = 320
}

enum Radius {
    static let small: CGFloat = 10
    static let large: CGFloat = 20
    static let xLarge: CGFloat = 26
    static let xxLarge: CGFloat = 32
}

enum Opacity {
    static let subtle: Double = 0.3
    static let dim: Double = 0.5
}

enum Duration {
    static let micro: Double = 0.05
    static let debounce: Double = 0.25
    static let transition: Double = 0.3
    static let toast: Double = 3
}
