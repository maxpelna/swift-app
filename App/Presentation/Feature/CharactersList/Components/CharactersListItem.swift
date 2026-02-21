//
//  CharactersListItem.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

struct CharactersListItem: View {
    let character: CharacterEntity

    var body: some View {
        HStack(spacing: 0) {
            if !character.image.isEmpty {
                CachedAsyncImage(url: character.image) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.textPrimary.opacity(Opacity.subtle)
                }
                .frame(width: Size.avatarMedium, height: Size.avatarMedium)
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
