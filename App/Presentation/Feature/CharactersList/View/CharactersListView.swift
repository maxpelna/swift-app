//
//  CharactersListView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct CharactersListView: View {
    @State private var viewModel = CharactersListViewModel()

    @StateObject private var debounceObserver = InputDebouncerObserver()

    @Environment(Coordinator.self)
    private var coordinator

    @Environment(ErrorHandler.self)
    private var errorHandler

    var body: some View {
        LoadingOverlay(isLoading: viewModel.charactersResult.isInProgress || viewModel.charactersResult.isNone) {
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
                            .tint(.accentColor)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .id(viewModel.page)
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
                        .accessibilityLabel(Text(.filterTitle))
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onSettingsIconTap) {
                    Image(systemName: Icons.settings)
                        .accessibilityLabel(Text(.settingsTitle))
                }
            }
        }
        .searchable(text: $debounceObserver.input)
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .task {
            viewModel.addEvent(.initialLoad)
        }
        .onChange(of: debounceObserver.output) { _, newValue in
            viewModel.addEvent(.setSearchQuery(newValue))
        }
        .onChange(of: viewModel.charactersResult.isError) { _, newValue in
            guard newValue, let error = viewModel.charactersResult.error else { return }

            errorHandler.showErrorMessage(error)
        }
        .onChange(of: viewModel.loadMoreResult.isError) { _, newValue in
            guard newValue, let error = viewModel.loadMoreResult.error else { return }

            errorHandler.showErrorMessage(error)
        }
    }

    private func tryToLoadMoreItems(_ id: Int) {
        guard viewModel.canLoadMore(id) else { return }

        viewModel.addEvent(.loadMore)
    }

    private func onFilterIconTap() {
        coordinator.presentSheet(
            .charactersFilter(
                CharactersFilterViewConfig(
                    selectedGender: viewModel.selectedGender,
                    selectedStatus: viewModel.selectedStatus
                ) { selectedGender, selectedStatus in
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
    }

    private func onSettingsIconTap() {
        coordinator.pushPage(.settings)
    }
}
