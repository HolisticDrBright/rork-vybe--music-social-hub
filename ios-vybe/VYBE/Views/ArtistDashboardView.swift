//
//  ArtistDashboardView.swift
//  VYBE
//

import SwiftUI

struct ArtistDashboardView: View {
    @Environment(AppState.self) private var app
    @State private var aiTwinEnabled = true
    @State private var showLaunch = false
    @State private var showCollabCreate = false
    @State private var rewardedFan: String? = nil

    /// The artist whose dashboard this is (the demo "you, the artist").
    private let dashboardArtistId = "a1"
    private var impact: ArtistImpact { ArtistImpact.build(artistId: dashboardArtistId, app: app) }

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        headerCard
                        collabLabModule
                        sleeveBuilderModule
                        growthChart
                        earningsVsStreaming
                        recognitionCard
                    }
                    Group {
                        SectionHeader(title: "Top Fans by Revenue Driven")
                        topFansByRevenue
                        rewardTopFans
                        SectionHeader(title: "Recent Fan Support")
                        recentSupport
                    }
                    Group {
                        SectionHeader(title: "AI Artist Twin")
                        aiTwinCard
                        SectionHeader(title: "City Demand / Scene Heat")
                        cityDemand
                        SectionHeader(title: "Growth Drivers")
                        growthDrivers
                    }
                }
                .padding(.horizontal, 20).padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Artist Dashboard")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showLaunch) { LaunchChallengeSheet() }
    }

    // MARK: - Collab Lab module

    private var collabLabModule: some View {
        VStack(spacing: 12) {
            NavigationLink(value: Route.collabLab) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 12) {
                        Image(systemName: "person.2.wave.2.fill").font(.system(size: 18)).foregroundStyle(.white)
                            .frame(width: 44, height: 44).background(VYBE.holo, in: .circle)
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text("Collab Lab").font(.system(size: 16, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                                NeonTag(text: "NEW", color: VYBE.magenta, icon: "sparkles")
                            }
                            Text("Find people to make music with").font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
                    }
                    HStack(spacing: 10) {
                        collabStat("\(app.myChallenges.count)", "Active", VYBE.cyan)
                        collabStat("\(app.incomingSubmissionCount)", "Incoming", VYBE.magenta)
                        collabStat("\(app.openChallenges.count)", "Open beats", VYBE.green)
                        collabStat("\(app.upcomingDrops.count)", "Drops", VYBE.gold)
                    }
                }
                .padding(16)
                .background { ZStack { VYBE.card; HoloArt(seed: "collabmodule").opacity(0.12) }.clipShape(.rect(cornerRadius: 20)) }
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.magenta.opacity(0.3), lineWidth: 1))
            }
            .buttonStyle(.plain)

            Button { showCollabCreate = true } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus").font(.system(size: 14, weight: .bold))
                    Text("Create a Challenge").font(.system(size: 14, weight: .heavy, design: .rounded))
                }
                .foregroundStyle(.white).frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(VYBE.holo, in: .capsule).neonGlow(VYBE.magenta, radius: 10)
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $showCollabCreate) { CreateCollabChallengeView().environment(app) }
    }

    // MARK: - Sleeve Builder module

    private var sleeveBuilderModule: some View {
        VStack(spacing: 12) {
            NavigationLink(value: Route.sleeveBuilder) {
                HStack(spacing: 12) {
                    Image(systemName: "rectangle.stack.badge.plus").font(.system(size: 18)).foregroundStyle(.white)
                        .frame(width: 44, height: 44).background(VYBE.holoSunset, in: .circle)
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text("Sleeve Builder").font(.system(size: 16, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                            NeonTag(text: "NEW", color: VYBE.gold, icon: "sparkles")
                        }
                        Text("Give your drop art, lyrics & liner notes").font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
                }
                .padding(16)
                .background { ZStack { VYBE.card; HoloArt(seed: "sleevebuildermod").opacity(0.14) }.clipShape(.rect(cornerRadius: 20)) }
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.gold.opacity(0.3), lineWidth: 1))
            }
            .buttonStyle(.plain)
            NavigationLink(value: Route.vybeTV) {
                HStack(spacing: 8) {
                    Image(systemName: "tv.fill").font(.system(size: 13, weight: .bold))
                    Text("Preview on VYBE TV").font(.system(size: 13, weight: .heavy, design: .rounded))
                    Spacer()
                    Image(systemName: "arrow.right").font(.system(size: 12, weight: .bold))
                }
                .foregroundStyle(VYBE.magenta).padding(.horizontal, 16).padding(.vertical, 11)
                .background(VYBE.magenta.opacity(0.1), in: .capsule)
            }
            .buttonStyle(.plain)
        }
    }

    private func collabStat(_ value: String, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 3) {
            Text(value).font(.system(size: 18, weight: .black, design: .rounded)).foregroundStyle(color)
            Text(label).font(.system(size: 10, weight: .semibold)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 10).background(.white.opacity(0.04), in: .rect(cornerRadius: 12))
    }

    // MARK: - Earnings vs streaming

    private var earningsVsStreaming: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("$\(impact.earnings.total.grouped)")
                    .font(.system(size: 26, weight: .black, design: .rounded)).foregroundStyle(VYBE.green)
                Text("fan-funded this month").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("$\(impact.earnings.streamingEquivalent.grouped)")
                    .font(.system(size: 18, weight: .black, design: .rounded)).foregroundStyle(VYBE.textSecondary)
                Text("on streaming").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textTertiary)
            }
            Divider().frame(height: 40).overlay(VYBE.stroke)
            VStack(spacing: 2) {
                Text("\(impact.multiplier)x").font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(VYBE.magenta)
                Text("more").font(.system(size: 10, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
            }
        }
        .padding(16).vybeCard(corner: 20)
    }

    // MARK: - Recognition moment

    private var recognitionCard: some View {
        let fan = impact.risingTopFan
        return HStack(spacing: 12) {
            AvatarView(seed: fan.fan.avatarSeed, size: 46)
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "arrow.up.right.circle.fill").font(.system(size: 14))
                        .foregroundStyle(VYBE.green).background(VYBE.bg, in: .circle)
                }
            VStack(alignment: .leading, spacing: 2) {
                Text("@\(fan.fan.name) is a rising top fan")
                    .font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Text("Drove $\(fan.revenueDriven) · \(fan.streamsDriven.compact) streams")
                    .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
            Button { rewardedFan = fan.fan.name; app.hapticSuccess() } label: {
                Text(rewardedFan == fan.fan.name ? "Rewarded ✓" : "Recognize")
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .foregroundStyle(rewardedFan == fan.fan.name ? VYBE.green : .white)
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background {
                        if rewardedFan == fan.fan.name { Capsule().fill(VYBE.green.opacity(0.15)) }
                        else { Capsule().fill(VYBE.holo) }
                    }
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background { ZStack { VYBE.card; HoloArt(seed: "recognize").opacity(0.1) }.clipShape(.rect(cornerRadius: 18)) }
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.green.opacity(0.3), lineWidth: 1))
    }

    // MARK: - Top fans by revenue

    private var topFansByRevenue: some View {
        VStack(spacing: 10) {
            ForEach(Array(impact.topFans.enumerated()), id: \.element.id) { idx, tf in
                HStack(spacing: 12) {
                    Text("\(idx + 1)").font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundStyle(idx == 0 ? VYBE.gold : VYBE.textSecondary).frame(width: 20)
                    AvatarView(seed: tf.fan.avatarSeed, size: 40)
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 5) {
                            Text("@\(tf.fan.name)").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                            if tf.isYou { NeonTag(text: "YOU", color: VYBE.magenta) }
                        }
                        Text("\(tf.streamsDriven.compact) streams driven · \(tf.fan.city)")
                            .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("$\(tf.revenueDriven)").font(.system(size: 15, weight: .black, design: .rounded)).foregroundStyle(VYBE.green)
                        Text("revenue").font(.system(size: 9, weight: .semibold)).foregroundStyle(VYBE.textTertiary)
                    }
                }
                .padding(12).vybeCard(corner: 14)
            }
        }
    }

    // MARK: - Recent support feed

    private var recentSupport: some View {
        VStack(spacing: 8) {
            ForEach(impact.recentEvents) { ev in
                HStack(spacing: 12) {
                    AvatarView(seed: ev.fanName, size: 34)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("@\(ev.fanName) · \(ev.verb)")
                            .font(.system(size: 13, weight: .semibold)).foregroundStyle(VYBE.text).lineLimit(1)
                        Text("\(ev.minutesAgo)m ago").font(.system(size: 10, weight: .medium)).foregroundStyle(VYBE.textTertiary)
                    }
                    Spacer()
                    Text("+\(ev.dollarsLabel)").font(.system(size: 13, weight: .black, design: .rounded)).foregroundStyle(VYBE.green)
                }
                .padding(.vertical, 8).padding(.horizontal, 12).vybeCard(corner: 12)
            }
        }
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
            ForEach(impact.cityHeat) { heat in
                cityBar(heat.city, heat.value, heat.fans)
            }
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
