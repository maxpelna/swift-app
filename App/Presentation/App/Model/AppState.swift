//
//  AppState.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum AppState {
    case loading
    case clean
    case authorized

    func toRoute() -> PageRoute {
        switch self {
        case .loading: .splash
        case .clean: .onboarding
        case .authorized: .charactersList
        }
    }
}
