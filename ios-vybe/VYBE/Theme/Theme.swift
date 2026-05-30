//
//  Theme.swift
//  VYBE
//
//  Central design system: colors, gradients, typography, and reusable modifiers.
//

import SwiftUI

/// VYBE brand palette — festival neon on deep charcoal.
enum VYBE {
    // Base surfaces
    static let bg = Color(red: 0.04, green: 0.03, blue: 0.07)
    static let bgElevated = Color(red: 0.08, green: 0.07, blue: 0.12)
    static let card = Color(red: 0.11, green: 0.09, blue: 0.16)
    static let stroke = Color.white.opacity(0.08)

    // Neon accents
    static let purple = Color(red: 0.55, green: 0.30, blue: 1.0)
    static let magenta = Color(red: 1.0, green: 0.20, blue: 0.62)
    static let blue = Color(red: 0.20, green: 0.62, blue: 1.0)
    static let cyan = Color(red: 0.25, green: 0.95, blue: 0.95)
    static let gold = Color(red: 1.0, green: 0.78, blue: 0.27)
    static let green = Color(red: 0.30, green: 0.95, blue: 0.55)

    // Text
    static let text = Color.white
    static let textSecondary = Color.white.opacity(0.62)
    static let textTertiary = Color.white.opacity(0.40)

    // Signature gradients
    static let holo = LinearGradient(
        colors: [purple, magenta, blue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let holoSunset = LinearGradient(
        colors: [magenta, gold, purple],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let goldGrad = LinearGradient(
        colors: [gold, Color(red: 1.0, green: 0.55, blue: 0.2)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

/// Deterministic holographic mesh-gradient artwork derived from a string seed.
/// Used as "cover art" stand-ins so the app stays fully self-contained yet vibrant.
struct HoloArt: View {
    let seed: String
    var corner: CGFloat = 0

    private var palette: [Color] {
        let banks: [[Color]] = [
            [VYBE.purple, VYBE.magenta, VYBE.blue],
            [VYBE.magenta, VYBE.gold, VYBE.purple],
            [VYBE.blue, VYBE.cyan, VYBE.purple],
            [VYBE.purple, VYBE.blue, VYBE.cyan],
            [VYBE.magenta, VYBE.purple, VYBE.blue],
            [VYBE.gold, VYBE.magenta, VYBE.purple],
            [VYBE.green, VYBE.cyan, VYBE.blue],
        ]
        let h = abs(seed.hashValue)
        return banks[h % banks.count]
    }

    private var rotation: Double {
        Double(abs(seed.hashValue) % 360)
    }

    var body: some View {
        let p = palette
        ZStack {
            LinearGradient(colors: p, startPoint: .topLeading, endPoint: .bottomTrailing)
            // Glow blobs for depth
            Circle()
                .fill(p[0].opacity(0.9))
                .frame(width: 160)
                .blur(radius: 60)
                .offset(x: -40, y: -30)
            Circle()
                .fill(p.count > 2 ? p[2].opacity(0.8) : p[0].opacity(0.8))
                .frame(width: 140)
                .blur(radius: 55)
                .offset(x: 50, y: 40)
            // Holographic sheen
            LinearGradient(
                colors: [.white.opacity(0.22), .clear, .black.opacity(0.18)],
                startPoint: .top, endPoint: .bottom
            )
            .rotationEffect(.degrees(rotation))
            .blendMode(.overlay)
        }
        .clipShape(.rect(cornerRadius: corner))
    }
}

// MARK: - Reusable modifiers

extension View {
    /// Standard VYBE card surface with subtle stroke.
    func vybeCard(corner: CGFloat = 20) -> some View {
        self
            .background(VYBE.card, in: .rect(cornerRadius: corner))
            .overlay(
                RoundedRectangle(cornerRadius: corner)
                    .stroke(VYBE.stroke, lineWidth: 1)
            )
    }

    /// Neon glow shadow in a given color.
    func neonGlow(_ color: Color, radius: CGFloat = 16) -> some View {
        self.shadow(color: color.opacity(0.55), radius: radius)
    }
}

/// App-wide background atmosphere with deep gradient and faint glow orbs.
struct VYBEBackground: View {
    var body: some View {
        ZStack {
            VYBE.bg.ignoresSafeArea()
            RadialGradient(
                colors: [VYBE.purple.opacity(0.28), .clear],
                center: .topLeading, startRadius: 5, endRadius: 420
            )
            .ignoresSafeArea()
            RadialGradient(
                colors: [VYBE.magenta.opacity(0.20), .clear],
                center: .bottomTrailing, startRadius: 5, endRadius: 460
            )
            .ignoresSafeArea()
        }
    }
}

/// Pill tag with neon tint.
struct NeonTag: View {
    let text: String
    var color: Color = VYBE.purple
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 4) {
            if let icon { Image(systemName: icon).font(.system(size: 10, weight: .bold)) }
            Text(text)
                .font(.system(size: 11, weight: .bold, design: .rounded))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.16), in: .capsule)
        .overlay(Capsule().stroke(color.opacity(0.35), lineWidth: 1))
    }
}

/// Gradient text using the holo gradient.
struct HoloText: View {
    let text: String
    var font: Font = .largeTitle.bold()
    var gradient: LinearGradient = VYBE.holo

    var body: some View {
        Text(text)
            .font(font)
            .overlay { gradient.mask(Text(text).font(font)) }
    }
}
