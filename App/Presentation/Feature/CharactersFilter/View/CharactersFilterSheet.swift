//
//  CharactersFilterModal.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct CharactersFilterSheet: View {
    let viewConfig: CharactersFilterViewConfig

    @State private var viewModel = CharactersFiltersViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(CharacterGender.allCases, id: \.rawValue) { gender in
                        Button {
                            selectGender(gender)
                        } label: {
                            HStack {
                                Text(gender.localized())
                                    .bodyRegular()
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                if viewModel.selectedGender == gender {
                                    Image(systemName: Icons.checkmark)
                                }
                            }
                        }
                    }
                } header: {
                    Text(.characterGender)
                }

                Section {
                    ForEach(CharacterStatus.allCases, id: \.rawValue) { status in
                        Button {
                            selectStatus(status)
                        } label: {
                            HStack {
                                Text(status.localized())
                                    .bodyRegular()
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                if viewModel.selectedStatus == status {
                                    Image(systemName: Icons.checkmark)
                                }
                            }
                        }
                    }
                } header: {
                    Text(.characterStatus)
                }
            }
            .navigationTitle(.filterTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(.generalClear) {
                        viewModel.addEvent(.clearFilters)
                    }
                }
                ToolbarSpacer(placement: .topBarTrailing)
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewConfig.onApply(
                            viewModel.selectedGender,
                            viewModel.selectedStatus
                        )
                    } label: {
                        Image(systemName: Icons.checkmark)
                    }
                    .buttonStyle(.glassProminent)
                }
            }
        }
        .task {
            viewModel.addEvent(
                .initialLoad(
                    viewConfig.selectedGender,
                    viewConfig.selectedStatus
                )
            )
        }
    }

    private func selectGender(_ gender: CharacterGender) {
        viewModel.addEvent(.setGender(gender))
    }

    private func selectStatus(_ status: CharacterStatus) {
        viewModel.addEvent(.setStatus(status))
    }
}
