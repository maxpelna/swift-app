//
//  CharactersEmptyView.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct CharactersEmptyView: View {
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: Radius.xLarge)
                .fill(Color.backgroundSecondary)
                .padding()

            VStack(spacing: Spacing.xxLarge) {
                Image(systemName: Icons.search)
                    .font(.system(size: Size.iconLarge))
                    .symbolEffect(.breathe, options: .repeat(.continuous))

                Text(.noCharactersFound)
                    .bodySecondary()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
