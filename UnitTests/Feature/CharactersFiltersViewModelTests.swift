//
//  CharactersFiltersViewModelTests.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Testing
@testable import swift_app

extension ViewModelTestsSuite {
    @MainActor
    struct CharactersFiltersViewModelTests {
        @Test
        func initialLoad_setsGenderAndStatus() {
            let vm = CharactersFiltersViewModel()
            
            vm.addEvent(.initialLoad(.female, .alive))
            
            #expect(vm.selectedGender == .female)
            #expect(vm.selectedStatus == .alive)
        }
        
        @Test
        func initialLoad_nilValues_leavesSelectionsNil() {
            let vm = CharactersFiltersViewModel()
            
            vm.addEvent(.initialLoad(nil, nil))
            
            #expect(vm.selectedGender == nil)
            #expect(vm.selectedStatus == nil)
        }
        
        @Test
        func setGender_updatesSelectedGender() {
            let vm = CharactersFiltersViewModel()
            
            vm.addEvent(.setGender(.male))
            
            #expect(vm.selectedGender == .male)
            #expect(vm.selectedStatus == nil)
        }
        
        @Test
        func setGender_nil_clearsGender() {
            let vm = CharactersFiltersViewModel()
            vm.addEvent(.setGender(.female))
            
            vm.addEvent(.setGender(nil))
            
            #expect(vm.selectedGender == nil)
        }
        
        @Test
        func setStatus_updatesSelectedStatus() {
            let vm = CharactersFiltersViewModel()
            
            vm.addEvent(.setStatus(.dead))
            
            #expect(vm.selectedStatus == .dead)
            #expect(vm.selectedGender == nil)
        }
        
        @Test
        func setStatus_nil_clearsStatus() {
            let vm = CharactersFiltersViewModel()
            vm.addEvent(.setStatus(.alive))
            
            vm.addEvent(.setStatus(nil))
            
            #expect(vm.selectedStatus == nil)
        }
        
        @Test
        func clearFilters_nilsBothSelections() {
            let vm = CharactersFiltersViewModel()
            vm.addEvent(.initialLoad(.male, .dead))
            
            vm.addEvent(.clearFilters)
            
            #expect(vm.selectedGender == nil)
            #expect(vm.selectedStatus == nil)
        }
    }
}
