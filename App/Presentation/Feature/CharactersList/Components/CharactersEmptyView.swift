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
            RoundedRectangle(cornerRadius: 26)
                .fill(Color.backgroundSecondary)
                .padding()

            VStack(spacing: 24) {
                Image(systemName: Icons.search)
                    .font(.system(size: 40))
                    .symbolEffect(.breathe, options: .repeat(.continuous))

                Text(.noCharactersFound)
                    .bodySecondary()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
