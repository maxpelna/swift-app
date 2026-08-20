//
//  CharactersListViewModel.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Observation

@Observable
final class CharactersListViewModel: CharactersServiceInjectable {
    // MARK: - State

    var searchInput: String = ""

    private(set) var query = CharactersQuery()
    private(set) var charactersResult: DelayedResult<[CharacterEntity]> = .none
    private(set) var loadMoreResult: DelayedResult<Void> = .none

    var characters: [CharacterEntity] {
        charactersResult.value ?? []
    }

    var isLoading: Bool {
        charactersResult.isInProgress || charactersResult.isNone
    }

    var isEmptyList: Bool {
        !charactersResult.isInProgress && characters.isEmpty
    }

    private var page: Int = 1
    private var canLoadMore = false
    private var loadedQuery: CharactersQuery?

    // MARK: - Handlers

    func debounceSearchInput() async {
        guard searchInput != query.searchQuery else { return }

        try? await Task.sleep(for: .seconds(Duration.debounce))
        guard !Task.isCancelled else { return }

        query.searchQuery = searchInput
    }

    func loadMoreIfNeeded(after id: Int) async {
        guard id == charactersResult.value?.last?.id else { return }

        await loadMore()
    }

    func setFilters(gender: CharacterGender?, status: CharacterStatus?) {
        query.gender = gender
        query.status = status
    }

    func reload() async {
        // Re-appearing with results already on screen must not throw away pagination.
        // Anything else — a new query, an error, a run that never finished — reloads.
        guard !(charactersResult.isSuccessful && loadedQuery == query) else { return }

        charactersResult = .inProgress
        loadMoreResult = .none
        canLoadMore = false
        page = 1

        let requestedQuery = query

        do {
            let result = try await fetchCharacters(page: page)

            guard requestedQuery == query else { return }

            charactersResult = .success(result.characters)
            canLoadMore = result.hasNextPage
            loadedQuery = requestedQuery
        } catch {
            guard !error.isCancellation else { return }

            charactersResult = .failure(error)
        }
    }

    func loadMore() async {
        guard canLoadMore, !loadMoreResult.isInProgress else { return }

        let requestedQuery = query
        loadMoreResult = .inProgress

        do {
            let result = try await fetchCharacters(page: page + 1)

            // A newer query already reset `page` — appending here would desync it.
            guard requestedQuery == query else {
                loadMoreResult = .none
                return
            }

            let existing = characters
            var knownIds = Set(existing.map(\.id))
            let newCharacters = result.characters.filter { knownIds.insert($0.id).inserted }

            page += 1
            canLoadMore = result.hasNextPage
            charactersResult = .success(existing + newCharacters)
            loadMoreResult = .none
        } catch {
            loadMoreResult = error.isCancellation ? .none : .failure(error)
        }
    }

    private func fetchCharacters(page: Int) async throws -> CharactersResult {
        try await charactersService.charactersResult(
            page: page,
            name: query.searchQuery,
            status: query.status,
            gender: query.gender
        )
    }
}
