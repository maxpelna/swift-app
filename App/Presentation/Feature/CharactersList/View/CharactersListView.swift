//
//  CharactersListView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct CharactersListView: View {

    @State private var viewModel = CharactersListViewModel()
    @State private var showFilters: Bool = false

    @StateObject private var debounceObserver = InputDebounceObserver()

    @Environment(\.coordinator) private var coordinator
    @Environment(\.errorHandler) private var errorHandler

    init() {
        viewModel.addEvent(.initialLoad)
    }

    var body: some View {
        NavigationView {
            LoadingOverlay(isLoading: viewModel.charactersResult.isInProgress) {
                if viewModel.isEmptyList {
                    CharactersEmptyView()
                } else {
                    List {
                        ForEach(viewModel.charactersResult.value ?? []) { character in
                            CharactersListItem(character: character)
                                .onAppear {
                                    tryToLoadMoreItems(character.id)
                                }
                        }

                        if viewModel.loadMoreResult.isInProgress {
                            ProgressView()
                                .id(viewModel.charactersResult.value?.count ?? 0)
                                .tint(.accentColor)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.backgroundPrimary)
            .navigationTitle(.charactersTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onFilterIconTap) {
                        Image(systemName: Icons.filter)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onSettingsIconTap) {
                        Image(systemName: Icons.settings)
                    }
                }
            }
            .searchable(text: $debounceObserver.input)
            .searchPresentationToolbarBehavior(.avoidHidingContent)
            .onChange(of: debounceObserver.output) { _, newValue in
                viewModel.addEvent(.setSearchQuery(newValue))
            }
            .onChange(of: viewModel.charactersResult.isError) { oldValue, newValue in
                guard let error = viewModel.charactersResult.error else { return }

                errorHandler.showErrorMessage(error)
            }
            .onChange(of: viewModel.loadMoreResult.isError) { oldValue, newValue in
                guard let error = viewModel.loadMoreResult.error else { return }

                errorHandler.showErrorMessage(error)
            }
        }
    }

    private func tryToLoadMoreItems(_ id: Int) {
        guard viewModel.canLoadMore(id) else { return }

        viewModel.addEvent(.loadMode)
    }

    private func onFilterIconTap() {
        coordinator.presentSheet(
            .charactersFilter(
                CharactersFilterViewConfig(
                    selectedGender: viewModel.selectedGender,
                    selectedStatus: viewModel.selectedStatus,
                    onApply: { selectedGender, selectedStatus in
                        coordinator.dismissSheet()
                        viewModel.addEvent(
                            .setFilters(
                                selectedGender,
                                selectedStatus
                            )
                        )
                    }
                )
            )
        )
    }

    private func onSettingsIconTap() {
        coordinator.pushPage(.settings)
    }
}
