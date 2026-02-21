//
//  CharactersListViewModelTests.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Testing
@testable import swift_app

@MainActor
@Suite(.serialized)
struct CharactersListViewModelTests {
    private func makeViewModel(service: MockPCharactersService) -> CharactersListViewModel {
        DIContainer.shared.charactersService = service
        return CharactersListViewModel()
    }

    @Test
    func initialLoad_success_setsSuccessfulResult() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [.stub()],
            hasNextPage: false
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        #expect(vm.charactersResult.isSuccessful)
        #expect(vm.charactersResult.value?.count == 1)
        #expect(mock.callCount == 1)
        #expect(mock.lastPage == 1)
    }

    @Test
    func initialLoad_failure_setsErrorResult() async {
        let mock = MockPCharactersService()
        mock.stubbedError = AppError.networkUnavailable

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        #expect(vm.charactersResult.isError)
        #expect(!vm.charactersResult.isSuccessful)
    }

    @Test
    func initialLoad_noopWhenAlreadySuccessful() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [.stub()],
            hasNextPage: false
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        #expect(mock.callCount == 1)
    }

    @Test
    func loadMore_noopWhenCannotLoadMore() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [.stub()],
            hasNextPage: false
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        vm.addEvent(.loadMore)
        await vm.currentTask?.value

        #expect(mock.callCount == 1)
    }

    @Test
    func loadMore_appendsResultsWhenCanLoadMore() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [.stub(id: 1)],
            hasNextPage: true
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        mock.stubbedResult = CharactersResult(
            characters: [.stub(id: 2)],
            hasNextPage: false
        )
        vm.addEvent(.loadMore)
        await vm.currentTask?.value

        #expect(vm.charactersResult.value?.count == 2)
        #expect(vm.loadMoreResult.isNone)
        #expect(mock.callCount == 2)
        #expect(mock.lastPage == 2)
    }

    @Test
    func loadMore_onError_setsLoadMoreError() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [.stub()],
            hasNextPage: true
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        mock.stubbedError = AppError.networkUnavailable
        vm.addEvent(.loadMore)
        await vm.currentTask?.value

        #expect(vm.loadMoreResult.isError)
        #expect(vm.charactersResult.value?.count == 1)
    }

    @Test
    func clearLoadMore_resetsLoadMoreResultToNone() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [.stub()],
            hasNextPage: true
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        mock.stubbedError = AppError.networkUnavailable
        vm.addEvent(.loadMore)
        await vm.currentTask?.value

        #expect(vm.loadMoreResult.isError)

        vm.addEvent(.clearLoadMore)
        await vm.currentTask?.value

        #expect(vm.loadMoreResult.isNone)
    }

    @Test
    func setSearchQuery_sameQuery_doesNotFetchAgain() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [],
            hasNextPage: false
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        vm.addEvent(.setSearchQuery("Rick"))
        await vm.currentTask?.value
        let callsAfterFirstQuery = mock.callCount

        vm.addEvent(.setSearchQuery("Rick"))
        await vm.currentTask?.value

        #expect(mock.callCount == callsAfterFirstQuery)
    }

    @Test
    func setSearchQuery_differentQuery_fetchesAgain() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [],
            hasNextPage: false
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        vm.addEvent(.setSearchQuery("Rick"))
        await vm.currentTask?.value

        vm.addEvent(.setSearchQuery("Morty"))
        await vm.currentTask?.value

        #expect(mock.callCount == 3)
        #expect(mock.lastName == "Morty")
    }

    @Test
    func setSearchQuery_resetsPageToOne() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [.stub()],
            hasNextPage: true
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        mock.stubbedResult = CharactersResult(
            characters: [.stub(id: 2)],
            hasNextPage: false
        )
        vm.addEvent(.loadMore)
        await vm.currentTask?.value

        vm.addEvent(.setSearchQuery("Rick"))
        await vm.currentTask?.value

        #expect(mock.lastPage == 1)
    }

    @Test
    func setFilters_updatesSelectedFiltersAndFetches() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [],
            hasNextPage: false
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        vm.addEvent(.setFilters(.female, .alive))
        await vm.currentTask?.value

        #expect(vm.selectedGender == .female)
        #expect(vm.selectedStatus == .alive)
        #expect(mock.lastGender == .female)
        #expect(mock.lastStatus == .alive)
        #expect(mock.lastPage == 1)
    }

    @Test
    func setFilters_clearFilters_nilsSelection() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [],
            hasNextPage: false
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.setFilters(.male, .dead))
        await vm.currentTask?.value

        vm.addEvent(.setFilters(nil, nil))
        await vm.currentTask?.value

        #expect(vm.selectedGender == nil)
        #expect(vm.selectedStatus == nil)
    }

    @Test
    func hasAppliedFilters_falseWhenNoneSet() async {
        let mock = MockPCharactersService()
        let vm = makeViewModel(service: mock)

        #expect(!vm.hasAppliedFilters)
    }

    @Test
    func hasAppliedFilters_trueWhenGenderSet() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [],
            hasNextPage: false
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.setFilters(.female, nil))
        await vm.currentTask?.value

        #expect(vm.hasAppliedFilters)
    }

    @Test
    func hasAppliedFilters_trueWhenStatusSet() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [],
            hasNextPage: false
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.setFilters(nil, .alive))
        await vm.currentTask?.value

        #expect(vm.hasAppliedFilters)
    }

    @Test
    func isEmptyList_trueAfterSuccessfulEmptyLoad() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [],
            hasNextPage: false
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        #expect(vm.isEmptyList)
    }

    @Test
    func isEmptyList_falseWhenCharactersLoaded() async {
        let mock = MockPCharactersService()
        mock.stubbedResult = CharactersResult(
            characters: [.stub()],
            hasNextPage: false
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        #expect(!vm.isEmptyList)
    }

    @Test
    func canLoadMore_trueForLastItemWhenPageAvailable() async {
        let mock = MockPCharactersService()
        let character = CharacterEntity.stub(id: 99)
        mock.stubbedResult = CharactersResult(
            characters: [character],
            hasNextPage: true
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        #expect(vm.canLoadMore(99))
        #expect(!vm.canLoadMore(1))
    }

    @Test
    func canLoadMore_falseIfNextPageIsNotAvailable() async {
        let mock = MockPCharactersService()
        let character = CharacterEntity.stub(id: 99)
        mock.stubbedResult = CharactersResult(
            characters: [character],
            hasNextPage: false
        )

        let vm = makeViewModel(service: mock)
        vm.addEvent(.initialLoad)
        await vm.currentTask?.value

        #expect(!vm.canLoadMore(99))
        #expect(!vm.canLoadMore(1))
    }
}
