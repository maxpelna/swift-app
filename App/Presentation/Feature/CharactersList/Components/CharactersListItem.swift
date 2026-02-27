//
//  CharactersListItem.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import NukeUI
import SwiftUI

struct CharactersListItem: View {
    let character: CharacterEntity

    var body: some View {
        HStack(spacing: 0) {
            if let url = URL(string: character.image) {
                LazyImage(url: url) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color.textPrimary.opacity(Opacity.subtle)
                    }
                }
                .frame(width: Sizes.avatarMedium, height: Sizes.avatarMedium)
                .clipShape(RoundedRectangle(cornerRadius: Radius.xxLarge))
            }

            Spacer()
                .frame(width: Spacing.large)

            VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                Text(character.name)
                    .bodySemibold()

                if let status = character.status {
                    Text(.characterStatusSubtitle(status.localized()))
                        .captionSecondary()
                }

                if let gender = character.gender {
                    Text(.characterGenderSubtitle(gender.localized()))
                        .captionSecondary()
                }
            }
        }
    }
}
