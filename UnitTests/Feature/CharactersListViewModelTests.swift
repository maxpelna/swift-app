//
//  CharactersListViewModelTests.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Testing
@testable import swift_app

extension ViewModelTestsSuite {
    struct CharactersListViewModelTests {
        private func makeViewModel(service: MockPCharactersService) -> CharactersListViewModel {
            DIContainer.shared.charactersService = service
            return CharactersListViewModel()
        }

        // MARK: - reload

        @Test
        func reload_success_setsSuccessfulResult() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub()],
                hasNextPage: false
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()

            #expect(vm.charactersResult.isSuccessful)
            #expect(vm.characters.count == 1)
            #expect(mock.callCount == 1)
            #expect(mock.lastPage == 1)
        }

        @Test
        func reload_failure_setsErrorResult() async {
            let mock = MockPCharactersService()
            mock.stubbedError = AppError.noConnection

            let vm = makeViewModel(service: mock)
            await vm.reload()

            #expect(vm.charactersResult.isError)
            #expect(!vm.charactersResult.isSuccessful)
        }

        @Test
        func reload_cancellation_leavesStateToItsSuccessor() async {
            let mock = MockPCharactersService()
            mock.stubbedError = CancellationError()

            let vm = makeViewModel(service: mock)
            await vm.reload()

            #expect(!vm.charactersResult.isError)
            #expect(vm.charactersResult.isInProgress)
        }

        @Test
        func reload_resetsPaginationBackToFirstPage() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 1)],
                hasNextPage: true
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()

            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 2)],
                hasNextPage: true
            )
            await vm.loadMore()
            #expect(mock.lastPage == 2)

            mock.stubbedResult = CharactersResult(
                characters: [],
                hasNextPage: false
            )
            vm.setFilters(gender: .female, status: nil)
            await vm.reload()

            #expect(mock.lastPage == 1)
        }

        @Test
        func reload_whenQueryChangesDuringRequest_discardsResult() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 1)],
                hasNextPage: true
            )

            let vm = makeViewModel(service: mock)
            mock.onRequest = { vm.setFilters(gender: .female, status: nil) }

            await vm.reload()

            #expect(!vm.charactersResult.isSuccessful)
            #expect(vm.charactersResult.isInProgress)
        }

        @Test
        func reload_whenQueryUnchangedAndAlreadyLoaded_doesNotRefetch() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 1)],
                hasNextPage: true
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()

            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 2)],
                hasNextPage: true
            )
            await vm.loadMore()
            #expect(vm.characters.map(\.id) == [1, 2])

            await vm.reload()

            #expect(mock.callCount == 2)
            #expect(vm.characters.map(\.id) == [1, 2])
        }

        @Test
        func reload_whenQueryChanged_refetches() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 1)],
                hasNextPage: false
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()

            vm.setFilters(gender: .female, status: nil)
            await vm.reload()

            #expect(mock.callCount == 2)
        }

        @Test
        func reload_afterError_refetches() async {
            let mock = MockPCharactersService()
            mock.stubbedError = AppError.noConnection

            let vm = makeViewModel(service: mock)
            await vm.reload()
            #expect(vm.charactersResult.isError)

            mock.stubbedError = nil
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 1)],
                hasNextPage: false
            )
            await vm.reload()

            #expect(vm.charactersResult.isSuccessful)
            #expect(mock.callCount == 2)
        }

        @Test
        func reload_afterCancellation_refetches() async {
            let mock = MockPCharactersService()
            mock.stubbedError = CancellationError()

            let vm = makeViewModel(service: mock)
            await vm.reload()
            #expect(vm.charactersResult.isInProgress)

            mock.stubbedError = nil
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 1)],
                hasNextPage: false
            )
            await vm.reload()

            #expect(vm.charactersResult.isSuccessful)
        }

        // MARK: - loadMore

        @Test
        func loadMore_noopWhenCannotLoadMore() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub()],
                hasNextPage: false
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()
            await vm.loadMore()

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
            await vm.reload()

            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 2)],
                hasNextPage: false
            )
            await vm.loadMore()

            #expect(vm.characters.count == 2)
            #expect(vm.loadMoreResult.isNone)
            #expect(mock.callCount == 2)
            #expect(mock.lastPage == 2)
        }

        @Test
        func loadMore_skipsCharactersAlreadyLoaded() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 1)],
                hasNextPage: true
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()

            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 1), .stub(id: 2), .stub(id: 2)],
                hasNextPage: false
            )
            await vm.loadMore()

            #expect(vm.characters.map(\.id) == [1, 2])
        }

        @Test
        func loadMore_onError_setsLoadMoreError() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub()],
                hasNextPage: true
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()

            mock.stubbedError = AppError.noConnection
            await vm.loadMore()

            #expect(vm.loadMoreResult.isError)
            #expect(vm.characters.count == 1)
        }

        @Test
        func loadMore_cancellation_leavesNoError() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub()],
                hasNextPage: true
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()

            mock.stubbedError = CancellationError()
            await vm.loadMore()

            #expect(vm.loadMoreResult.isNone)
        }

        @Test
        func loadMore_whenQueryChangesDuringRequest_discardsResult() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 1)],
                hasNextPage: true
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()

            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 2)],
                hasNextPage: true
            )

            mock.onRequest = { vm.setFilters(gender: .female, status: nil) }

            await vm.loadMore()

            #expect(vm.characters.map(\.id) == [1])
            #expect(vm.loadMoreResult.isNone)
        }

        @Test
        func loadMore_passesCurrentSearchAndFiltersToService() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 1)],
                hasNextPage: true
            )

            let vm = makeViewModel(service: mock)
            vm.setFilters(gender: .female, status: .alive)
            vm.searchInput = "Rick"
            await vm.debounceSearchInput()
            await vm.reload()

            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 2)],
                hasNextPage: false
            )
            await vm.loadMore()

            #expect(mock.lastName == "Rick")
            #expect(mock.lastGender == .female)
            #expect(mock.lastStatus == .alive)
        }

        @Test
        func loadMore_whenPageAddsNothingNew_keepsTheListUnchanged() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 1)],
                hasNextPage: true
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()

            await vm.loadMore()

            #expect(vm.characters.map(\.id) == [1])
            #expect(vm.loadMoreResult.isNone)
        }

        // MARK: - debounceSearchInput

        @Test
        func debounceSearchInput_commitsInputIntoQuery() async {
            let mock = MockPCharactersService()

            let vm = makeViewModel(service: mock)
            vm.searchInput = "Rick"
            await vm.debounceSearchInput()

            #expect(vm.query.searchQuery == "Rick")
        }

        @Test
        func debounceSearchInput_sameInput_leavesQueryUntouched() async {
            let mock = MockPCharactersService()

            let vm = makeViewModel(service: mock)
            vm.searchInput = "Rick"
            await vm.debounceSearchInput()

            let queryAfterFirstCommit = vm.query
            await vm.debounceSearchInput()

            #expect(vm.query == queryAfterFirstCommit)
        }

        // MARK: - setFilters

        @Test
        func setFilters_updatesQueryWithoutFetching() {
            let mock = MockPCharactersService()

            let vm = makeViewModel(service: mock)
            vm.setFilters(gender: .female, status: .alive)

            #expect(vm.query.gender == .female)
            #expect(vm.query.status == .alive)
            #expect(mock.callCount == 0)
        }

        @Test
        func setFilters_clearFilters_nilsSelection() {
            let mock = MockPCharactersService()

            let vm = makeViewModel(service: mock)
            vm.setFilters(gender: .male, status: .dead)
            vm.setFilters(gender: nil, status: nil)

            #expect(vm.query.gender == nil)
            #expect(vm.query.status == nil)
        }

        @Test
        func setFilters_sameSelection_leavesQueryUnchanged() {
            let mock = MockPCharactersService()

            let vm = makeViewModel(service: mock)
            vm.setFilters(gender: .male, status: .dead)

            let queryAfterFirstApply = vm.query
            vm.setFilters(gender: .male, status: .dead)

            #expect(vm.query == queryAfterFirstApply)
        }

        @Test
        func loadMore_afterFailedPage_retriesSuccessfully() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 99)],
                hasNextPage: true
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()

            mock.stubbedError = AppError.caught(APIError.server(statusCode: 429, description: nil))
            await vm.loadMore()
            #expect(vm.loadMoreResult.isError)

            mock.stubbedError = nil
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 100)],
                hasNextPage: false
            )
            await vm.loadMore()

            #expect(vm.characters.map(\.id) == [99, 100])
            #expect(vm.loadMoreResult.isNone)
        }

        // MARK: - loadMoreIfNeeded

        @Test
        func loadMoreIfNeeded_onlyLoadsForTheLastLoadedItem() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [.stub(id: 1), .stub(id: 99)],
                hasNextPage: true
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()

            await vm.loadMoreIfNeeded(after: 1)
            #expect(mock.callCount == 1)

            await vm.loadMoreIfNeeded(after: 99)
            #expect(mock.callCount == 2)
        }

        @Test
        func loadMoreIfNeeded_ignoredWhenNothingIsLoaded() async {
            let mock = MockPCharactersService()

            let vm = makeViewModel(service: mock)
            await vm.loadMoreIfNeeded(after: 1)

            #expect(mock.callCount == 0)
        }

        // MARK: - isEmptyList

        @Test
        func isEmptyList_trueAfterSuccessfulEmptyLoad() async {
            let mock = MockPCharactersService()
            mock.stubbedResult = CharactersResult(
                characters: [],
                hasNextPage: false
            )

            let vm = makeViewModel(service: mock)
            await vm.reload()

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
            await vm.reload()

            #expect(!vm.isEmptyList)
        }
    }
}
