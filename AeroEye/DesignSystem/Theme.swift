//
//  Theme.swift
//  AeroEye
//
//  Shared colours and surfaces for the AeroEye interface.
//

import SwiftUI

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

enum AeroTheme {
    // Brand
    static let navy = Color(hex: 0x132760)
    static let navyDeep = Color(hex: 0x0A1633)
    static let navyMuted = Color(hex: 0x51648C)
    static let navyTint = Color(hex: 0xEDF1F9)

    // Text
    static let ink = Color(hex: 0x101624)
    static let secondary = Color(hex: 0x687285)
    static let tertiary = Color(hex: 0x98A1B0)

    // Surfaces
    static let canvas = Color(hex: 0xF6F7FA)
    static let surface = Color.white
    static let hairline = Color(hex: 0xE2E6EE)

    // Status
    static let success = Color(hex: 0x1E865C)
    static let warning = Color(hex: 0xBE740C)
    static let danger = Color(hex: 0xBE3D36)

    // Dark placeholder panels
    static let warningBright = Color(hex: 0xF2B347)
    static let accentBright = Color(hex: 0x8FB4FF)

    static var navyGradient: LinearGradient {
        LinearGradient(
            colors: [navy, navyDeep],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension View {
    /// White card treatment used across the dashboard.
    func aeroCard(cornerRadius: CGFloat = 18) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(AeroTheme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(AeroTheme.hairline, lineWidth: 1)
            )
            .shadow(color: AeroTheme.navy.opacity(0.035), radius: 14, x: 0, y: 6)
    }
}
