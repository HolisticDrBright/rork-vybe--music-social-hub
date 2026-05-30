//
//  OnboardingView.swift
//  VYBE
//
//  3-card thesis onboarding + taste capture + VYBE Loop intro.
//  Sells the core value prop: streaming is broken → VYBE fixes it.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) private var app
    @State private var page = 0
    @State private var pulse = false

    private let totalPages = 5

    var body: some View {
        ZStack {
            VYBEBackground()
            Circle()
                .fill(VYBE.holo)
                .frame(width: 300)
                .blur(radius: 100)
                .opacity(0.45)
                .scaleEffect(pulse ? 1.2 : 0.8)
                .offset(y: -200)

            VStack(spacing: 0) {
                Spacer(minLength: 10)

                VStack(spacing: 8) {
                    Image(systemName: "waveform")
                        .font(.system(size: 40, weight: .black))
                        .foregroundStyle(VYBE.holo)
                        .neonGlow(VYBE.magenta, radius: 18)
                    HoloText(text: "VYBE", font: .system(size: 48, weight: .black, design: .rounded))
                    Text("THE SOCIAL NETWORK FOR MUSIC")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .tracking(2.5)
                        .foregroundStyle(VYBE.textSecondary)
                }
                .padding(.bottom, page < 3 ? 24 : 14)

                TabView(selection: $page) {
                    thesisPage(
                        icon: "dollarsign.circle",
                        boldText: "Streaming pays artists\nless than a penny per play.",
                        bodyText: "Spotify pays ~$0.004 per stream. That means 250,000 streams = ~$1,000. Meanwhile, they're about to charge superfans $18/mo for 'Music Pro'. We think that's broken.",
                        accent: VYBE.magenta
                    ).tag(0)

                    thesisPage(
                        icon: "bolt.shield.fill",
                        boldText: "VYBE flips the model.\nArtists earn. Fans get rewarded.",
                        bodyText: "Artists keep 90% of every dollar fans give — tips, drops, merch, superfan tiers. And fans earn VYBE Score, badges, VIP access, and real-world prizes for supporting artists early.",
                        accent: VYBE.gold
                    ).tag(1)

                    thesisPage(
                        icon: "arrow.triangle.capsulepath",
                        boldText: "The VYBE Loop",
                        bodyText: "Discover underground artists → support them (stream, share, tip, attend shows) → watch your impact grow instantly → unlock rewards → get recognized by the artists themselves. Supporting artists pays off — for everyone.",
                        accent: VYBE.green
                    ).tag(2)

                    tasteCapture.tag(3)
                    loopOption.tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: page == 3 ? 440 : page == 4 ? 380 : 280)

                HStack(spacing: 7) {
                    ForEach(0..<totalPages, id: \.self) { i in
                        Capsule()
                            .fill(i == page ? AnyShapeStyle(VYBE.holo) : AnyShapeStyle(Color.white.opacity(0.2)))
                            .frame(width: i == page ? 20 : 6, height: 6)
                            .animation(.snappy, value: page)
                    }
                }
                .padding(.bottom, 20)

                PrimaryButton(title: page == 3 ? "Start Exploring" : page == 4 ? "Enter VYBE" : "Continue", icon: "arrow.right") {
                    if page < totalPages - 1 {
                        withAnimation { page += 1 }
                    } else {
                        app.hasOnboarded = true
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 14)

                if page == 4 {
                    Button("Skip for now") {
                        app.hasOnboarded = true
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(VYBE.textSecondary)
                    .padding(.bottom, 8)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    private func thesisPage(icon: String, boldText: String, bodyText: String, accent: Color) -> some View {
        VStack(spacing: 20) {
            ZStack {
                Circle().fill(accent.opacity(0.12)).frame(width: 90, height: 90)
                Circle().stroke(accent.opacity(0.3), lineWidth: 1.5).frame(width: 98, height: 98)
                Image(systemName: icon)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [accent, VYBE.purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            }
            Text(boldText)
                .font(.system(size: 26, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(VYBE.text)
            Text(bodyText)
                .font(.system(size: 15, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundStyle(VYBE.textSecondary)
                .padding(.horizontal, 36)
                .lineSpacing(3)
        }
    }

    private var tasteCapture: some View {
        VStack(spacing: 14) {
            Text("Pick your vibe")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.text)
            Text("We'll match you with the right music and people from day one.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            VStack(alignment: .leading, spacing: 10) {
                Text("GENRES")
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1.5)
                    .foregroundStyle(VYBE.textTertiary)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                    ForEach(Mock.tasteGenres.prefix(9), id: \.self) { genre in
                        let selected = app.taste.favoriteGenres.contains(genre)
                        Button {
                            if selected { app.taste.favoriteGenres.remove(genre) }
                            else { app.taste.favoriteGenres.insert(genre) }
                            app.haptic(.light)
                        } label: {
                            tasteChipLabel(genre, selected: selected)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text("MOODS")
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1.5)
                    .foregroundStyle(VYBE.textTertiary)
                    .padding(.top, 6)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                    ForEach(Mock.tasteMoods.prefix(9), id: \.self) { mood in
                        let selected = app.taste.favoriteMoods.contains(mood)
                        Button {
                            if selected { app.taste.favoriteMoods.remove(mood) }
                            else { app.taste.favoriteMoods.insert(mood) }
                            app.haptic(.light)
                        } label: {
                            tasteChipLabel(mood, selected: selected)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func tasteChipLabel(_ text: String, selected: Bool) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundStyle(selected ? .white : VYBE.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 9)
            .background {
                if selected {
                    Capsule().fill(VYBE.holo).neonGlow(VYBE.purple, radius: 6)
                } else {
                    Capsule().fill(.white.opacity(0.05))
                        .overlay(Capsule().stroke(VYBE.stroke, lineWidth: 1))
                }
            }
    }

    private var loopOption: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle().fill(VYBE.holo).frame(width: 80, height: 80).neonGlow(VYBE.magenta, radius: 20)
                Image(systemName: "arrow.triangle.capsulepath")
                    .font(.system(size: 36, weight: .black))
                    .foregroundStyle(.white)
            }
            Text("One more thing.")
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.text)
            Text("We'd love to show you the VYBE Loop — a 60-second walkthrough where you discover an artist, support them, earn rewards, and see the impact.")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .lineSpacing(3)

            Button {
                app.hasOnboarded = true
                app.startLoop()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "play.fill").font(.system(size: 13))
                    Text("Show me the VYBE Loop")
                }
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.cyan)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(VYBE.cyan.opacity(0.1), in: .capsule)
                .overlay(Capsule().stroke(VYBE.cyan.opacity(0.4), lineWidth: 1))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 30)
        }
    }
}
