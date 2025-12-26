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
            if let imageURL = URL(string: character.image) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.textPrimary.opacity(0.3)
                }
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 32))
            }

            Spacer()
                .frame(width: 16)

            VStack(alignment: .leading, spacing: 2) {
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
