//
//  CharactersListViewModel.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Observation

@Observable
final class CharactersListViewModel: CharactersServiceInjectable {

    // MARK: - Private variables

    private var page: Int = 1
    private var canLoadMore: Bool = false

    // MARK: - State

    private(set) var charactersResult: DelayedResult<[CharacterEntity]> = DelayedResult.none()
    private(set) var loadMoreResult: DelayedResult<Void> = DelayedResult.none()
    private(set) var searchQuery: String = ""
    private(set) var selectedGender: CharacterGender? = nil
    private(set) var selectedStatus: CharacterStatus? = nil

    func canLoadMore(_ id: Int) -> Bool {
        !loadMoreResult.isInProgress && charactersResult.value?.last?.id == id
    }

    var hasAppliedFilters: Bool {
        selectedGender != nil || selectedStatus != nil
    }

    var isEmptyList: Bool {
        !charactersResult.isInProgress && (charactersResult.value ?? []).isEmpty
    }

    // MARK: - Event

    enum Event {
        case initialLoad
        case loadMode
        case clearLoadMore
        case setSearchQuery(String)
        case setFilters(CharacterGender?, CharacterStatus?)
    }

    // MARK: - Handlers

    func addEvent(_ event: Event) {
        Task {
            switch event {
            case .initialLoad: await initialLoad()
            case .loadMode: await loadMore()
            case .clearLoadMore: clearLoadMoreResult()
            case .setSearchQuery(let query): await setSearchQuery(query: query)
            case .setFilters(let gender, let status): await setFilters(gender: gender, status: status)
            }
        }
    }

    private func initialLoad() async {
        charactersResult = .inProgress()
        page = 1

        do {
            let result = try await charactersService.charactersResult(
                page: page,
                name: searchQuery,
                status: selectedStatus,
                gender: selectedGender
            )

            charactersResult = .fromValue(result.characters)
            canLoadMore = result.hasNextPage
        } catch {
            charactersResult = .fromError(error)
        }
    }

    private func loadMore() async {
        guard !loadMoreResult.isInProgress && canLoadMore else { return }

        loadMoreResult = .inProgress()
        page += 1

        do {
            let result = try await charactersService.charactersResult(
                page: page,
                name: searchQuery,
                status: selectedStatus,
                gender: selectedGender
            )

            var updatedCharactersList = [CharacterEntity]()
            updatedCharactersList.append(
                contentsOf: charactersResult.value ?? []
            )
            updatedCharactersList.append(contentsOf: result.characters)

            charactersResult = .fromValue(updatedCharactersList)
            canLoadMore = result.hasNextPage
            loadMoreResult = .none()
        } catch {
            loadMoreResult = .fromError(error)
        }
    }

    private func clearLoadMoreResult() {
        loadMoreResult = .none()
    }

    private func setSearchQuery(query: String) async {
        guard searchQuery != query else { return }

        charactersResult = .inProgress()
        page = 1
        searchQuery = query

        do {
            let result = try await charactersService.charactersResult(
                page: page,
                name: searchQuery,
                status: selectedStatus,
                gender: selectedGender
            )

            charactersResult = .fromValue(result.characters)
            canLoadMore = result.hasNextPage
        } catch {
            charactersResult = .fromError(error)
        }
    }

    private func setFilters(
        gender: CharacterGender?,
        status: CharacterStatus?
    ) async {
        charactersResult = .inProgress()
        page = 1
        selectedGender = gender
        selectedStatus = status

        do {
            let result = try await charactersService.charactersResult(
                page: page,
                name: searchQuery,
                status: selectedStatus,
                gender: selectedGender
            )

            charactersResult = .fromValue(result.characters)
            canLoadMore = result.hasNextPage
        } catch {
            charactersResult = .fromError(error)
        }
    }
}
