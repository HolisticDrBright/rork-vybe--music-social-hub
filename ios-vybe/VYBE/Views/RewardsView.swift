//
//  RewardsView.swift
//  VYBE
//

import SwiftUI

struct RewardsView: View {
    @Environment(AppState.self) private var app
    @State private var category = "All"
    @State private var redeemed: Reward? = nil

    private var rewards: [Reward] {
        category == "All" ? Mock.rewards : Mock.rewards.filter { $0.category == category }
    }

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    scoreHero
                    earnRow
                    SectionHeader(title: "🏆 Active Challenges")
                    VStack(spacing: 12) { ForEach(Mock.challenges.prefix(3)) { ChallengeCard(challenge: $0) } }
                    missionsSection
                    SectionHeader(title: "Rewards Marketplace")
                    ChipRow(items: Mock.rewardCategories, selection: $category).padding(.horizontal, -20)
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                        ForEach(rewards) { reward in
                            RewardCard(reward: reward) { redeemed = reward }
                        }
                    }
                    premiumBanner
                }
                .padding(.horizontal, 20).padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Rewards")
        .vybeDestinations()
        .sheet(item: $redeemed) { reward in RedeemSheet(reward: reward) }
    }

    private var missionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("🎯 Artist Growth Missions").font(.system(size: 20, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Spacer()
                NavigationLink(value: Route.artistMissions) { Text("See all").font(.system(size: 13, weight: .bold)).foregroundStyle(VYBE.purple) }
            }
            ForEach(app.artistMissions.prefix(2)) { MissionCard(mission: $0) }
        }
    }

    private var scoreHero: some View {
        VStack(spacing: 14) {
            Text("VYBE SCORE").font(.system(size: 12, weight: .heavy, design: .rounded)).tracking(2).foregroundStyle(.white.opacity(0.8))
            Text(app.vybeScore.grouped)
                .font(.system(size: 46, weight: .black, design: .rounded)).foregroundStyle(.white)
                .contentTransition(.numericText())
            HStack(spacing: 20) {
                StatBlock(value: "#\(app.fanRank)", label: "Global Rank", color: .white)
                StatBlock(value: "Lvl 24", label: "Fan Level", color: .white)
                StatBlock(value: "7", label: "Day Streak", color: .white)
            }
            NeonProgressBar(progress: 0.64, gradient: VYBE.goldGrad)
            Text("8,550 pts to Level 25 → unlocks VIP Festival Pass")
                .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white.opacity(0.85))
        }
        .padding(20)
        .background {
            ZStack { VYBE.holo; HoloArt(seed: "scorehero").opacity(0.3).blendMode(.overlay) }
                .clipShape(.rect(cornerRadius: 24))
        }
        .neonGlow(VYBE.purple, radius: 20)
    }

    private var earnRow: some View {
        NavigationLink(value: Route.viralStats) {
            HStack(spacing: 0) {
                earnItem("bolt.fill", "Viral Impact", "\(app.viralImpact)", VYBE.gold)
                earnItem("square.and.arrow.up.fill", "Shares", "\(app.shareCount)", VYBE.magenta)
                earnItem("person.badge.plus", "Referrals", "\(app.referralCount)", VYBE.cyan)
                earnItem("waveform", "Streams", app.streamsGenerated.compact, VYBE.green)
            }
            .padding(.vertical, 14).vybeCard(corner: 18)
        }
        .buttonStyle(.plain)
    }

    private func earnItem(_ icon: String, _ label: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(color)
            Text(value).font(.system(size: 15, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
            Text(label).font(.system(size: 10, weight: .medium)).foregroundStyle(VYBE.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var premiumBanner: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("VYBE Premium", systemImage: "crown.fill").font(.system(size: 16, weight: .black, design: .rounded)).foregroundStyle(VYBE.gold)
                Spacer()
                NeonTag(text: "2X POINTS", color: VYBE.gold)
            }
            Text("Double points, exclusive drops, early ticket access, and ad-free vibes. $9.99/mo.")
                .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(VYBE.cyan)
                Text("Spotify charges superfans $18/mo for less. VYBE pays YOU back for being a superfan.")
                    .font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.cyan)
                    .lineSpacing(2)
            }
            .padding(.vertical, 6)
            PrimaryButton(title: "Go Premium · $9.99/mo", icon: "sparkles", gradient: VYBE.goldGrad) {}
                .padding(.top, 4)
        }
        .padding(16)
        .background {
            ZStack { VYBE.card; HoloArt(seed: "premium").opacity(0.12) }
                .clipShape(.rect(cornerRadius: 20))
        }
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.gold.opacity(0.35), lineWidth: 1))
    }
}

struct RewardCard: View {
    @Environment(AppState.self) private var app
    let reward: Reward
    let action: () -> Void
    private var affordable: Bool { app.vybeScore >= reward.cost }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                HoloArt(seed: reward.title, corner: 16).frame(height: 90)
                Image(systemName: reward.icon).font(.system(size: 28, weight: .bold)).foregroundStyle(.white).shadow(radius: 6)
                if reward.hot {
                    VStack { HStack { Spacer(); NeonTag(text: "HOT", color: VYBE.magenta, icon: "flame.fill") }; Spacer() }.padding(8)
                }
            }
            Text(reward.title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(1)
            Text(reward.subtitle).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
            Button(action: action) {
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill").font(.system(size: 10))
                    Text("\(reward.cost.compact)").font(.system(size: 13, weight: .black, design: .rounded))
                }
                .foregroundStyle(affordable ? .white : VYBE.textSecondary)
                .frame(maxWidth: .infinity).padding(.vertical, 9)
                .background {
                    if affordable { Capsule().fill(VYBE.holo) }
                    else { Capsule().fill(.white.opacity(0.06)).overlay(Capsule().stroke(VYBE.stroke, lineWidth: 1)) }
                }
            }
            .buttonStyle(.plain)
        }
        .padding(12).vybeCard(corner: 18)
    }
}

struct RedeemSheet: View {
    @Environment(AppState.self) private var app
    @Environment(\.dismiss) private var dismiss
    let reward: Reward
    @State private var done = false
    private var affordable: Bool { app.vybeScore >= reward.cost }

    var body: some View {
        VStack(spacing: 18) {
            Capsule().fill(.white.opacity(0.2)).frame(width: 40, height: 5).padding(.top, 10)
            ZStack {
                HoloArt(seed: reward.title, corner: 24).frame(width: 110, height: 110).neonGlow(VYBE.magenta, radius: 16)
                Image(systemName: done ? "checkmark" : reward.icon).font(.system(size: 40, weight: .bold)).foregroundStyle(.white)
            }
            VStack(spacing: 4) {
                Text(done ? "Redeemed!" : reward.title).font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                Text(done ? "Check your profile for the unlock" : reward.subtitle).font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            HStack(spacing: 6) {
                Image(systemName: "bolt.fill").foregroundStyle(VYBE.gold)
                Text("\(reward.cost.grouped) points").font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
            }
            if !affordable && !done {
                Text("You need \((reward.cost - app.vybeScore).grouped) more points")
                    .font(.system(size: 13, weight: .semibold)).foregroundStyle(VYBE.magenta)
            }
            PrimaryButton(title: done ? "Done" : (affordable ? "Redeem now" : "Keep earning"), icon: done ? "checkmark" : "gift.fill") {
                if done { dismiss() }
                else if affordable {
                    app.addScore(-reward.cost)
                    let g = UINotificationFeedbackGenerator(); g.notificationOccurred(.success)
                    withAnimation(.snappy) { done = true }
                } else { dismiss() }
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(VYBE.bgElevated)
        .presentationDetents([.medium])
    }
}
