//
//  CharactersFiltersViewModel.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Observation

@Observable
final class CharactersFiltersViewModel {
    // MARK: - State

    private(set) var selectedGender: CharacterGender?
    private(set) var selectedStatus: CharacterStatus?

    // MARK: - Handlers

    func initialLoad(gender: CharacterGender?, status: CharacterStatus?) {
        self.selectedGender = gender
        self.selectedStatus = status
    }

    func setGender(_ gender: CharacterGender?) {
        self.selectedGender = gender
    }

    func setStatus(_ status: CharacterStatus?) {
        self.selectedStatus = status
    }

    func clearFilters() {
        selectedGender = nil
        selectedStatus = nil
    }
}
