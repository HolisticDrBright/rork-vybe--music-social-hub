//
//  ContentView.swift
//  VYBE
//
//  Shared reusable UI components used across screens.
//

import SwiftUI

/// Circular avatar generated from a seed (holo gradient + initial).
struct AvatarView: View {
    let seed: String
    var size: CGFloat = 40

    private var initial: String { String(seed.prefix(1)).uppercased() }

    var body: some View {
        HoloArt(seed: seed)
            .frame(width: size, height: size)
            .clipShape(.circle)
            .overlay(
                Text(initial)
                    .font(.system(size: size * 0.42, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
            )
            .overlay(Circle().stroke(.white.opacity(0.18), lineWidth: 1))
    }
}

/// Section header with optional trailing action.
struct SectionHeader: View {
    let title: String
    var actionLabel: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.text)
            Spacer()
            if let actionLabel, let action {
                Button(actionLabel, action: action)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(VYBE.purple)
            }
        }
    }
}

/// Primary gradient call-to-action button.
struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    var gradient: LinearGradient = VYBE.holo
    let action: () -> Void

    @State private var pressed = false

    var body: some View {
        Button {
            let gen = UIImpactFeedbackGenerator(style: .medium)
            gen.impactOccurred()
            action()
        } label: {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon).font(.system(size: 15, weight: .bold)) }
                Text(title).font(.system(size: 16, weight: .heavy, design: .rounded))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(gradient, in: .capsule)
            .neonGlow(VYBE.magenta, radius: 14)
            .scaleEffect(pressed ? 0.96 : 1)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.snappy) { pressed = true } }
                .onEnded { _ in withAnimation(.snappy) { pressed = false } }
        )
    }
}

/// Small stat block (number + label).
struct StatBlock: View {
    let value: String
    let label: String
    var color: Color = VYBE.text

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

/// Animated progress bar with neon gradient fill.
struct NeonProgressBar: View {
    let progress: Double
    var height: CGFloat = 8
    var gradient: LinearGradient = VYBE.holo

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(.white.opacity(0.10))
                Capsule()
                    .fill(gradient)
                    .frame(width: max(height, geo.size.width * progress))
                    .neonGlow(VYBE.magenta, radius: 8)
            }
        }
        .frame(height: height)
    }
}

/// Verified checkmark badge.
struct VerifiedBadge: View {
    var size: CGFloat = 15
    var body: some View {
        Image(systemName: "checkmark.seal.fill")
            .font(.system(size: size))
            .foregroundStyle(VYBE.blue)
    }
}

/// Persistent floating VYBE Score Orb — pulses and shows live score.
struct VYBEScoreOrb: View {
    @Environment(AppState.self) private var app
    @State private var pulse = false
    @State private var lastScore = 0

    var body: some View {
        NavigationLink(value: Route.viralStats) {
            ZStack {
                Circle()
                    .fill(VYBE.holo)
                    .frame(width: 48, height: 48)
                    .neonGlow(VYBE.magenta, radius: pulse ? 16 : 8)
                VStack(spacing: 0) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 14, weight: .black))
                        .foregroundStyle(.white)
                    Text(app.vybeScore.compact)
                        .font(.system(size: 10, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                }
            }
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
        .onChange(of: app.vybeScore) { old, new in
            if new > old {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    pulse = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                        pulse = true
                    }
                }
            }
        }
    }
}

/// Horizontal selectable chip row.
struct ChipRow: View {
    let items: [String]
    @Binding var selection: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    let isOn = item == selection
                    Button {
                        withAnimation(.snappy) { selection = item }
                    } label: {
                        Text(item)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(isOn ? .white : VYBE.textSecondary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background {
                                if isOn {
                                    Capsule().fill(VYBE.holo).neonGlow(VYBE.purple, radius: 10)
                                } else {
                                    Capsule().fill(.white.opacity(0.06))
                                        .overlay(Capsule().stroke(VYBE.stroke, lineWidth: 1))
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .contentMargins(.horizontal, 20, for: .scrollContent)
    }
}
