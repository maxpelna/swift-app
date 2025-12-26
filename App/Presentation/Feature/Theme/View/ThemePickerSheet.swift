//
//  ThemePickerSheet.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct ThemePickerView: View {

    let viewConfig: ThemePickerViewConfig

    var body: some View {
        VStack(alignment: .leading) {
            Text(.settingsAppearance)
                .headerPrimary()
                .padding(.vertical)

            HStack {
                ForEach(AppTheme.allCases) { theme in
                    let isSelected = viewConfig.selectedTheme == theme

                    VStack {
                        theme.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.rect(cornerRadius: 10))

                        Text(theme.localizedTitle)
                            .captionSecondary()

                        Image(systemName: isSelected ? Icons.circleCheckmarkFilled : Icons.circleCheckmarkEmpty)
                            .foregroundStyle(.tint)
                            .transition(.blurReplace)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        onSelectTheme(theme)
                    }
                }
            }
        }
        .padding()
    }

    private func onSelectTheme(_ theme: AppTheme) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        viewConfig.onChangeTheme(theme)
    }
}
