//
//  ArtistDashboardView.swift
//  VYBE
//

import SwiftUI

struct ArtistDashboardView: View {
    @Environment(AppState.self) private var app
    @State private var aiTwinEnabled = true
    @State private var showLaunch = false

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerCard
                    growthChart
                    SectionHeader(title: "AI Artist Twin")
                    aiTwinCard
                    SectionHeader(title: "Top Fans")
                    VStack(spacing: 10) {
                        ForEach(Array(Mock.leaderboard.prefix(4).enumerated()), id: \.element.id) { idx, fan in
                            HStack {
                                LeaderRow(rank: idx + 1, fan: fan)
                            }
                        }
                    }
                    rewardTopFans
                    SectionHeader(title: "City Demand")
                    cityDemand
                    SectionHeader(title: "Growth Drivers")
                    growthDrivers
                }
                .padding(.horizontal, 20).padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Artist Dashboard")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showLaunch) { LaunchChallengeSheet() }
    }

    private var headerCard: some View {
        VStack(spacing: 14) {
            HStack {
                AvatarView(seed: "NOVA REIGN", size: 54)
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text("NOVA REIGN").font(.system(size: 17, weight: .black, design: .rounded)).foregroundStyle(.white)
                        VerifiedBadge(size: 14)
                    }
                    Text("Hyperpop · Los Angeles").font(.system(size: 12, weight: .medium)).foregroundStyle(.white.opacity(0.8))
                }
                Spacer()
            }
            HStack {
                StatBlock(value: "2.84M", label: "Listeners", color: .white)
                StatBlock(value: "+18%", label: "30-day growth", color: .white)
                StatBlock(value: "412K", label: "Community", color: .white)
            }
            HStack(spacing: 10) {
                Button { showLaunch = true } label: {
                    Label("Launch Challenge", systemImage: "bolt.fill")
                        .font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.purple)
                        .frame(maxWidth: .infinity).padding(.vertical, 11)
                        .background(.white, in: .capsule)
                }
                .buttonStyle(.plain)
                Button {} label: {
                    Label("Post Update", systemImage: "megaphone.fill")
                        .font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 11)
                        .background(.white.opacity(0.2), in: .capsule)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(18)
        .background {
            ZStack { VYBE.holo; HoloArt(seed: "dashhdr").opacity(0.25).blendMode(.overlay) }
                .clipShape(.rect(cornerRadius: 22))
        }
        .neonGlow(VYBE.purple, radius: 16)
    }

    private var growthChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Fan Growth").font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Spacer()
                NeonTag(text: "+34K this week", color: VYBE.green, icon: "arrow.up.right")
            }
            let bars: [Double] = [0.4, 0.55, 0.5, 0.7, 0.65, 0.85, 1.0]
            HStack(alignment: .bottom, spacing: 10) {
                ForEach(bars.indices, id: \.self) { i in
                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(VYBE.holo)
                            .frame(height: 90 * bars[i])
                            .neonGlow(VYBE.magenta, radius: 6)
                        Text(["M","T","W","T","F","S","S"][i]).font(.system(size: 10, weight: .bold)).foregroundStyle(VYBE.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 120, alignment: .bottom)
        }
        .padding(16).vybeCard(corner: 20)
    }

    private var aiTwinCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "cpu.fill").font(.system(size: 18)).foregroundStyle(.white)
                    .frame(width: 44, height: 44).background(VYBE.holo, in: .circle)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Your AI Twin").font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Text(aiTwinEnabled ? "Live · answering fans" : "Disabled").font(.system(size: 12, weight: .semibold)).foregroundStyle(aiTwinEnabled ? VYBE.green : VYBE.textSecondary)
                }
                Spacer()
                Toggle("", isOn: $aiTwinEnabled).labelsHidden().tint(VYBE.purple)
            }
            Text("Your fans chat with an official, artist-approved AI version of you. You control its personality and can disable it anytime. No impersonation, fully consent-based.")
                .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            if aiTwinEnabled {
                HStack(spacing: 10) {
                    miniMetric("3,402", "chats today", VYBE.cyan)
                    miniMetric("4.9", "fan rating", VYBE.gold)
                    miniMetric("+$2.1K", "paid AI revenue", VYBE.green)
                }
            }
        }
        .padding(16)
        .background(VYBE.card, in: .rect(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(aiTwinEnabled ? VYBE.cyan.opacity(0.4) : VYBE.stroke, lineWidth: 1))
    }

    private func miniMetric(_ v: String, _ l: String, _ c: Color) -> some View {
        VStack(spacing: 2) {
            Text(v).font(.system(size: 15, weight: .black, design: .rounded)).foregroundStyle(c)
            Text(l).font(.system(size: 10, weight: .medium)).foregroundStyle(VYBE.textSecondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 10).background(.white.opacity(0.04), in: .rect(cornerRadius: 12))
    }

    private var rewardTopFans: some View {
        Button {} label: {
            HStack(spacing: 12) {
                Image(systemName: "gift.fill").font(.system(size: 16)).foregroundStyle(VYBE.gold)
                    .frame(width: 40, height: 40).background(VYBE.gold.opacity(0.15), in: .circle)
                VStack(alignment: .leading, spacing: 1) {
                    Text("Reward your top fans").font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Text("Drop tickets, backstage passes & shoutouts").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
            }
            .padding(14).vybeCard(corner: 18)
        }
        .buttonStyle(.plain)
    }

    private var cityDemand: some View {
        VStack(spacing: 10) {
            cityBar("Los Angeles", 1.0, "184K fans")
            cityBar("New York", 0.78, "142K fans")
            cityBar("Miami", 0.62, "112K fans")
            cityBar("Chicago", 0.45, "81K fans")
        }
        .padding(16).vybeCard(corner: 20)
    }

    private func cityBar(_ city: String, _ v: Double, _ label: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(city).font(.system(size: 13, weight: .bold)).foregroundStyle(VYBE.text)
                Spacer()
                Text(label).font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
            }
            NeonProgressBar(progress: v)
        }
    }

    private var growthDrivers: some View {
        VStack(spacing: 10) {
            ForEach(Array(Mock.leaderboard.prefix(3).enumerated()), id: \.element.id) { idx, fan in
                HStack(spacing: 12) {
                    AvatarView(seed: fan.avatarSeed, size: 40)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("@\(fan.name)").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                        Text("Drove \((42 - idx * 8))K streams · \(28 - idx * 6) referrals").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    }
                    Spacer()
                    NeonTag(text: "Top Promoter", color: VYBE.magenta, icon: "bolt.fill")
                }
                .padding(12).vybeCard(corner: 16)
            }
        }
    }
}

struct LaunchChallengeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var reward = 500.0
    private let templates = ["Share my new single", "Help sell out my show", "Make a video with this song", "Invite friends to my event", "Add to a playlist"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Capsule().fill(.white.opacity(0.2)).frame(width: 40, height: 5).frame(maxWidth: .infinity).padding(.top, 10)
            Text("Launch a Challenge").font(.system(size: 20, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
            Text("Pick a mission template").font(.system(size: 13, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(templates, id: \.self) { t in
                        Button { title = t } label: {
                            HStack {
                                Text(t).font(.system(size: 14, weight: .semibold)).foregroundStyle(VYBE.text)
                                Spacer()
                                Image(systemName: title == t ? "checkmark.circle.fill" : "circle").foregroundStyle(title == t ? VYBE.purple : VYBE.textTertiary)
                            }
                            .padding(14).background(title == t ? VYBE.purple.opacity(0.14) : VYBE.card, in: .rect(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(title == t ? VYBE.purple.opacity(0.5) : VYBE.stroke, lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Point reward").font(.system(size: 13, weight: .bold)).foregroundStyle(VYBE.text)
                    Spacer()
                    Text("+\(Int(reward))").font(.system(size: 14, weight: .black, design: .rounded)).foregroundStyle(VYBE.gold)
                }
                Slider(value: $reward, in: 100...2000, step: 100).tint(VYBE.purple)
            }
            PrimaryButton(title: "Launch Challenge", icon: "bolt.fill") { dismiss() }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(VYBE.bgElevated)
        .presentationDetents([.large])
    }
}
