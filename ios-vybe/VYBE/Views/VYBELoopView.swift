//
//  VYBELoopView.swift
//  VYBE
//
//  Guided demo overlay: discover → support → reward → artist-recognition.
//  The hero flow that sells VYBE in 60 seconds.
//

import SwiftUI

struct VYBELoopView: View {
    @Environment(AppState.self) private var app
    @State private var showPayoffDetail = false
    @State private var payoffAnimation = false
    @State private var orbPulse = false

    var body: some View {
        ZStack {
            VYBEBackground()

            VStack(spacing: 0) {
                // Step indicator
                stepIndicator
                    .padding(.top, 16)
                    .padding(.horizontal, 20)

                Spacer(minLength: 10)

                // Step content
                stepContent
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

                Spacer(minLength: 10)

                // Action
                loopAction
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
            }

            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        app.endLoop()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(VYBE.textTertiary)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 50)
                }
                Spacer()
            }
        }
    }

    // MARK: - Step Indicator

    private var stepIndicator: some View {
        HStack(spacing: 4) {
            ForEach(0..<4, id: \.self) { i in
                Rectangle()
                    .fill(i <= app.loopStep ? AnyShapeStyle(VYBE.holo) : AnyShapeStyle(Color.white.opacity(0.15)))
                    .frame(height: 3)
                    .frame(maxWidth: .infinity)
                    .clipShape(.capsule)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: app.loopStep)
            }
        }
        .overlay(alignment: .leading) {
            Text("VYBE LOOP")
                .font(.system(size: 9, weight: .heavy, design: .rounded))
                .tracking(2)
                .foregroundStyle(VYBE.cyan)
                .offset(y: -10)
        }
    }

    // MARK: - Step Content

    @ViewBuilder
    private var stepContent: some View {
        switch app.loopStep {
        case 0: discoverStep
        case 1: supportStep
        case 2: payoffStep
        case 3: recognitionStep
        default: discoverStep
        }
    }

    // Step 0: Discover an Underground Rising artist
    private var discoverStep: some View {
        VStack(spacing: 20) {
            Text("Step 1: Discover")
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.cyan)

            Text(attributedString())
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(VYBE.text)

            // Artist card
            VStack(spacing: 0) {
                HoloArt(seed: app.loopArtist.name, corner: 0)
                    .frame(height: 160)
                    .overlay(alignment: .topTrailing) {
                        NeonTag(text: "UNDERGROUND RISING", color: VYBE.green, icon: "arrow.up.right")
                            .padding(10)
                    }
                VStack(spacing: 8) {
                    Text(app.loopArtist.name)
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(VYBE.text)
                    Text(app.loopArtist.bio)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(VYBE.textSecondary)
                        .multilineTextAlignment(.center)
                    HStack(spacing: 6) {
                        ForEach(app.loopArtist.tags, id: \.self) {
                            NeonTag(text: $0, color: VYBE.purple)
                        }
                    }
                    HStack(spacing: 24) {
                        StatBlock(value: app.loopArtist.monthlyListeners.compact, label: "Listeners")
                        StatBlock(value: app.loopArtist.followers.compact, label: "Followers")
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }
            .background(VYBE.card)
            .clipShape(.rect(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(VYBE.stroke, lineWidth: 1))

            Text("This is **LUNA TIDE** — an underground dream pop artist from Portland. Her music has connection and emotion, but like most artists, she earns almost nothing from streaming.")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 20)
        }
        .padding(.horizontal, 20)
    }

    private func attributedString() -> AttributedString {
        var s = AttributedString("This underground artist earns $880/yr from streaming.")
        if let range = s.range(of: "$880/yr") { s[range].foregroundColor = UIColor(VYBE.magenta) }
        return s
    }

    // Step 1: Support the artist
    private var supportStep: some View {
        VStack(spacing: 20) {
            Text("Step 2: Support")
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.cyan)

            Text("You can change that.")
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.text)

            // Song preview
            HStack(spacing: 14) {
                HoloArt(seed: "Gravity Loves You", corner: 14)
                    .frame(width: 72, height: 72)
                    .overlay(Image(systemName: "play.fill").font(.system(size: 20)).foregroundStyle(.white))
                VStack(alignment: .leading, spacing: 3) {
                    Text("Gravity Loves You")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(VYBE.text)
                    Text("LUNA TIDE · Dream Pop")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(VYBE.textSecondary)
                    Text("Released 2 days ago")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(VYBE.green)
                }
                Spacer()
            }
            .padding(12)
            .vybeCard(corner: 18)

            // Support actions
            VStack(spacing: 10) {
                supportActionRow("headphones", "Stream the preview", "+20 pts", VYBE.green)
                supportActionRow("square.and.arrow.up.fill", "Share with friends", "+250 pts", VYBE.magenta)
                supportActionRow("heart.fill", "Tip $5 directly", "+500 pts", VYBE.gold)
            }
            .padding(16)
            .vybeCard(corner: 18)

            Text("Streaming would pay LUNA TIDE **$0.004**. Your support means **100x more** — and you earn points for doing it.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 20)
        }
        .padding(.horizontal, 20)
    }

    private func supportActionRow(_ icon: String, _ title: String, _ pts: String, _ color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(color).frame(width: 24)
            Text(title).font(.system(size: 14, weight: .semibold)).foregroundStyle(VYBE.text)
            Spacer()
            Text(pts).font(.system(size: 13, weight: .black, design: .rounded)).foregroundStyle(color)
        }
    }

    // Step 2: The Payoff
    private var payoffStep: some View {
        VStack(spacing: 16) {
            Text("Step 3: The Payoff")
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.cyan)

            if !app.loopShowPayoff {
                Text("Watch what happens\nwhen you support.")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(VYBE.text)
            } else {
                // Payoff reveal
                VStack(spacing: 12) {
                    // Score orb
                    ZStack {
                        Circle()
                            .stroke(VYBE.holo, lineWidth: 4)
                            .frame(width: 120, height: 120)
                            .scaleEffect(payoffAnimation ? 1.08 : 1)
                            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: payoffAnimation)
                        VStack(spacing: 0) {
                            Text("+750")
                                .font(.system(size: 38, weight: .black, design: .rounded))
                                .foregroundStyle(VYBE.text)
                                .contentTransition(.numericText())
                            Text("VYBE SCORE")
                                .font(.system(size: 10, weight: .heavy, design: .rounded))
                                .tracking(1.5)
                                .foregroundStyle(VYBE.textSecondary)
                        }
                    }
                    .neonGlow(VYBE.magenta, radius: 20)

                    // Artist earnings ticker
                    HStack(spacing: 8) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundStyle(VYBE.green)
                        Text("LUNA TIDE earned $26.40")
                            .font(.system(size: 16, weight: .heavy, design: .rounded))
                            .foregroundStyle(VYBE.green)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(VYBE.green.opacity(0.1), in: .capsule)
                    .overlay(Capsule().stroke(VYBE.green.opacity(0.3), lineWidth: 1))

                    // Comparison
                    Text("That's **66x** what streaming would have paid.")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(VYBE.text)
                        .multilineTextAlignment(.center)

                    // Receipt card
                    if let receipt = app.loopReceipt {
                        NavigationLink(value: Route.receipt(receipt)) {
                            HStack(spacing: 10) {
                                Image(systemName: "receipt")
                                    .font(.system(size: 16))
                                    .foregroundStyle(VYBE.gold)
                                Text("View your Support Receipt")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(VYBE.gold)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundStyle(VYBE.gold)
                            }
                            .padding(14)
                            .vybeCard(corner: 16)
                        }
                        .buttonStyle(.plain)
                    }

                    // Rank update
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundStyle(VYBE.cyan)
                        Text("You moved up 12 spots on the Portland leaderboard")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(VYBE.cyan)
                    }
                    .padding(.top, 4)
                }
                .onAppear { payoffAnimation = true }
            }
        }
        .padding(.horizontal, 20)
    }

    // Step 3: Artist Recognition
    private var recognitionStep: some View {
        VStack(spacing: 20) {
            Text("Step 4: Artist Recognition")
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.cyan)

            Text("The artist sees you.")
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.text)

            // Artist dashboard snippet
            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    AvatarView(seed: app.loopArtist.name, size: 50)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(app.loopArtist.name)
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .foregroundStyle(VYBE.text)
                        Text("Artist Dashboard").font(.system(size: 12)).foregroundStyle(VYBE.textSecondary)
                    }
                    Spacer()
                }
                Divider().overlay(VYBE.stroke)
                HStack {
                    VStack(spacing: 2) {
                        Text("You").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.magenta)
                        Text("Rising Top Fan").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    }
                    Spacer()
                    NeonTag(text: "Reward fan →", color: VYBE.gold, icon: "gift.fill")
                }
            }
            .padding(16)
            .vybeCard(corner: 20)

            Text("LUNA TIDE can now reward you with a shoutout, backstage pass, or exclusive drop — because you supported her when it mattered most.")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 16)

            // Unlock badge
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(VYBE.holo)
                        .frame(width: 70, height: 70)
                        .neonGlow(VYBE.purple, radius: 12)
                    Image(systemName: "sparkle.magnifyingglass")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                }
                Text("Early Discoverer")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundStyle(VYBE.text)
                Text("Badge unlocked! You found LUNA TIDE before she blew up.")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(VYBE.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Loop Action

    private var loopAction: some View {
        Group {
            switch app.loopStep {
            case 0:
                PrimaryButton(title: "Discover LUNA TIDE", icon: "arrow.right") {
                    app.advanceLoop()
                }
            case 1:
                PrimaryButton(title: "Support her now · +750 pts", icon: "bolt.fill") {
                    app.loopSupportArtist()
                    app.advanceLoop()
                    app.hapticSuccess()
                }
            case 2:
                if app.loopShowPayoff {
                    PrimaryButton(title: "See what happens next", icon: "arrow.right") {
                        app.advanceLoop()
                    }
                }
            case 3:
                PrimaryButton(title: "Enter VYBE", icon: "sparkles") {
                    app.endLoop()
                    app.hapticSuccess()
                }
            default:
                EmptyView()
            }
        }
    }
}
