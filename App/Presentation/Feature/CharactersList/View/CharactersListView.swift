//
//  CharactersListView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct CharactersListView: View {
    @State private var viewModel = CharactersListViewModel()

    @Environment(Coordinator.self)
    private var coordinator

    @Environment(ErrorHandler.self)
    private var errorHandler

    var body: some View {
        LoadingOverlay(isLoading: viewModel.isLoading) {
            if viewModel.isEmptyList {
                CharactersEmptyView()
            } else {
                List {
                    ForEach(viewModel.characters) { character in
                        CharactersListItem(character: character)
                            .task {
                                await viewModel.loadMoreIfNeeded(after: character.id)
                            }
                    }

                    if viewModel.loadMoreResult.isInProgress {
                        ProgressView()
                            .id(UUID())
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
        .searchable(text: $viewModel.searchInput)
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .task(id: viewModel.searchInput) {
            await viewModel.debounceSearchInput()
        }
        .task(id: viewModel.query) {
            await viewModel.reload()
        }
        .onChange(of: viewModel.charactersResult.isError) { _, isError in
            guard isError else { return }

            errorHandler.showErrorMessage(viewModel.charactersResult.error)
        }
        .onChange(of: viewModel.loadMoreResult.isError) { _, isError in
            guard isError else { return }

            errorHandler.showErrorMessage(viewModel.loadMoreResult.error)
        }
    }

    private func onFilterIconTap() {
        coordinator.presentSheet(
            .charactersFilter(
                CharactersFilterViewConfig(
                    selectedGender: viewModel.query.gender,
                    selectedStatus: viewModel.query.status
                ) { selectedGender, selectedStatus in
                    coordinator.dismissSheet()
                    viewModel.setFilters(
                        gender: selectedGender,
                        status: selectedStatus
                    )
                }
            )
        )
    }

    private func onSettingsIconTap() {
        coordinator.pushPage(.settings)
    }
}
