//
//  CharactersFiltersViewModelTests.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Testing
@testable import swift_app

extension ViewModelTestsSuite {
    struct CharactersFiltersViewModelTests {
        @Test
        func initialLoad_setsGenderAndStatus() {
            let vm = CharactersFiltersViewModel()

            vm.initialLoad(gender: .female, status: .alive)

            #expect(vm.selectedGender == .female)
            #expect(vm.selectedStatus == .alive)
        }

        @Test
        func initialLoad_nilValues_leavesSelectionsNil() {
            let vm = CharactersFiltersViewModel()

            vm.initialLoad(gender: nil, status: nil)

            #expect(vm.selectedGender == nil)
            #expect(vm.selectedStatus == nil)
        }

        @Test
        func setGender_updatesSelectedGender() {
            let vm = CharactersFiltersViewModel()

            vm.setGender(.male)

            #expect(vm.selectedGender == .male)
            #expect(vm.selectedStatus == nil)
        }

        @Test
        func setGender_nil_clearsGender() {
            let vm = CharactersFiltersViewModel()
            vm.setGender(.female)

            vm.setGender(nil)

            #expect(vm.selectedGender == nil)
        }

        @Test
        func setStatus_updatesSelectedStatus() {
            let vm = CharactersFiltersViewModel()

            vm.setStatus(.dead)

            #expect(vm.selectedStatus == .dead)
            #expect(vm.selectedGender == nil)
        }

        @Test
        func setStatus_nil_clearsStatus() {
            let vm = CharactersFiltersViewModel()
            vm.setStatus(.alive)

            vm.setStatus(nil)

            #expect(vm.selectedStatus == nil)
        }

        @Test
        func clearFilters_nilsBothSelections() {
            let vm = CharactersFiltersViewModel()
            vm.initialLoad(gender: .male, status: .dead)

            vm.clearFilters()

            #expect(vm.selectedGender == nil)
            #expect(vm.selectedStatus == nil)
        }
    }
}
