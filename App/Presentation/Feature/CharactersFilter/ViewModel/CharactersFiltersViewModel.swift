//
//  CharactersFiltersViewModel.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Observation

@MainActor
@Observable
final class CharactersFiltersViewModel {
    // MARK: - Event

    enum Event {
        case initialLoad(CharacterGender?, CharacterStatus?)
        case setGender(CharacterGender?)
        case setStatus(CharacterStatus?)
        case clearFilters
    }

    // MARK: - State

    private(set) var selectedGender: CharacterGender?
    private(set) var selectedStatus: CharacterStatus?

    // MARK: - Handlers

    func addEvent(_ event: Event) {
        switch event {
        case let .initialLoad(gender, status): initialLoad(gender: gender, status: status)
        case let .setGender(gender): setGender(gender)
        case let .setStatus(status): setStatus(status)
        case .clearFilters: clearFilters()
        }
    }

    private func initialLoad(gender: CharacterGender?, status: CharacterStatus?) {
        self.selectedGender = gender
        self.selectedStatus = status
    }

    private func setGender(_ gender: CharacterGender?) {
        self.selectedGender = gender
    }

    private func setStatus(_ status: CharacterStatus?) {
        self.selectedStatus = status
    }

    private func clearFilters() {
        selectedGender = nil
        selectedStatus = nil
    }
}
