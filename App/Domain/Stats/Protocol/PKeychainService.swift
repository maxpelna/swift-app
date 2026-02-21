//
//  PKeychainService.swift
//  swift-app
//
//  Created by Maksims Pelna on 21/02/2026.
//

protocol PKeychainService {
    func isFirstInstall() -> Bool
    func markInstalled()
}
