//
//  CharactersFilterViewConfig.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

struct CharactersFilterViewConfig {
    let selectedGender: CharacterGender?
    let selectedStatus: CharacterStatus?
    let onApply: (_ gender: CharacterGender?, _ status: CharacterStatus?) -> Void
}

extension CharactersFilterViewConfig: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(selectedGender)
        hasher.combine(selectedStatus)
    }
}

extension CharactersFilterViewConfig: Equatable {
    static func == (lhs: CharactersFilterViewConfig, rhs: CharactersFilterViewConfig) -> Bool {
        return lhs.selectedGender == rhs.selectedGender && lhs.selectedStatus == rhs.selectedStatus
    }
}
