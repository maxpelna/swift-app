//
//  CachedAsyncImage.swift
//  swift-app
//
//  Created by Maksims Pelna on 21/02/2026.
//

import SwiftUI

// In read app should use library like Kingfisher or Nuke
struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let urlString: String
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    @State private var uiImage: UIImage?

    var body: some View {
        imageView
            .task(id: urlString) { await load() }
    }

    @ViewBuilder private var imageView: some View {
        if let uiImage {
            content(Image(uiImage: uiImage))
        } else {
            placeholder()
        }
    }

    init(
        url: String,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.urlString = url
        self.content = content
        self.placeholder = placeholder
    }

    private func load() async {
        guard let url = URL(string: urlString), url.scheme == "https" else { return }

        if let cached = ImageCache.shared.image(for: url) {
            uiImage = cached
            return
        }

        guard
            let (data, _) = try? await URLSession.shared.data(from: url),
            let image = UIImage(data: data)
        else { return }

        ImageCache.shared.store(image, for: url)
        uiImage = image
    }
}
