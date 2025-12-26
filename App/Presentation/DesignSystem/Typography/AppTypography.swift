//
//  AppTypography.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

extension Text {
    func headerPrimary() -> some View {
        self
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.textPrimary)
    }

    func bodySemibold() -> some View {
        self
            .font(.body)
            .fontWeight(.semibold)
            .foregroundStyle(.textPrimary)
    }

    func bodyRegular() -> some View {
        self
            .font(.body)
            .foregroundStyle(.textPrimary)
    }

    func bodySecondary() -> some View {
        self
            .font(.body)
            .foregroundStyle(.textSecondary)
    }

    func captionPrimary() -> some View {
        self
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.textPrimary)
    }

    func captionSecondary() -> some View {
        self
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.textSecondary)
    }
}
