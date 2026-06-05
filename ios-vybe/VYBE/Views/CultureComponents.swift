//
//  CultureComponents.swift
//  VYBE
//
//  Reusable cards/badges for the music-culture layer.
//

import SwiftUI

// MARK: - Born on VYBE

struct BornOnVYBEBadge: View {
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "sparkles").font(.system(size: 10, weight: .bold))
            Text("Born on VYBE").font(.system(size: 11, weight: .heavy, design: .rounded))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 10).padding(.vertical, 5)
        .background(LinearGradient(colors: [VYBE.cyan, VYBE.blue], startPoint: .leading, endPoint: .trailing), in: .capsule)
        .overlay(Capsule().stroke(.white.opacity(0.25), lineWidth: 1))
    }
}

/// Full-width "Born on VYBE" mythology banner for drop/premiere surfaces.
struct BornOnVYBEBanner: View {
    var subtitle: String = "This started here. Fans made it move."
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(LinearGradient(colors: [VYBE.cyan, VYBE.blue], startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width: 44, height: 44)
                Image(systemName: "sparkles").font(.system(size: 18, weight: .bold)).foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Born on VYBE").font(.system(size: 15, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                Text(subtitle).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
        }
        .padding(14)
        .background { ZStack { VYBE.card; HoloArt(seed: "bornbanner").opacity(0.12) }.clipShape(.rect(cornerRadius: 18)) }
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.cyan.opacity(0.3), lineWidth: 1))
    }
}

// MARK: - Goal bar

struct GoalBar: View {
    let label: String
    let value: String
    let progress: Double
    var color: Color = VYBE.magenta
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(label).font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.textSecondary)
                Spacer()
                Text(value).font(.system(size: 12, weight: .black, design: .rounded)).foregroundStyle(color)
            }
            NeonProgressBar(progress: progress, height: 7,
                            gradient: LinearGradient(colors: [color, color.opacity(0.65)], startPoint: .leading, endPoint: .trailing))
        }
    }
}

struct StatusPill: View {
    let text: String
    let color: Color
    var icon: String? = nil
    var body: some View {
        HStack(spacing: 4) {
            if let icon { Image(systemName: icon).font(.system(size: 9, weight: .bold)) }
            Text(text).font(.system(size: 11, weight: .heavy, design: .rounded))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 9).padding(.vertical, 5)
        .background(color.opacity(0.16), in: .capsule)
        .overlay(Capsule().stroke(color.opacity(0.4), lineWidth: 1))
    }
}

// MARK: - Drop campaign card

struct DropCampaignCard: View {
    let campaign: DropCampaign
    var body: some View {
        NavigationLink(value: Route.dropCampaign(campaign.id)) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    HoloArt(seed: campaign.coverSeed).frame(height: 140)
                    LinearGradient(colors: [.clear, .black.opacity(0.65)], startPoint: .center, endPoint: .bottom).frame(height: 140)
                    HStack {
                        StatusPill(text: campaign.status.label, color: campaign.status.color, icon: campaign.status.icon)
                        Spacer()
                        if campaign.bornOnVYBE { BornOnVYBEBadge() }
                    }
                    .padding(10)
                    VStack { Spacer()
                        Text(campaign.countdownText).font(.system(size: 11, weight: .bold)).foregroundStyle(.white)
                            .padding(.horizontal, 8).padding(.vertical, 4).background(.black.opacity(0.5), in: .capsule)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(10)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text(campaign.title).font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(2)
                    Text(campaign.subtitle).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(2)
                    GoalBar(label: "Fan support", value: "\(Int(campaign.fundingProgress * 100))% to goal", progress: campaign.fundingProgress, color: VYBE.green)
                    HStack(spacing: 12) {
                        Label("\(campaign.boosts)/\(campaign.boostGoal) boosts", systemImage: "bolt.horizontal.fill")
                        Label("\(campaign.presaves)/\(campaign.presaveGoal) pre-saves", systemImage: "bookmark.fill")
                    }
                    .font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.textSecondary)
                }
                .padding(14)
            }
            .background(VYBE.card).clipShape(.rect(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(campaign.status.color.opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Before They Blow card

struct BeforeTheyBlowCard: View {
    @Environment(AppState.self) private var app
    let alert: BeforeTheyBlowAlert
    @State private var backed = false

    private var isReal: Bool { Mock.artists.contains { $0.id == alert.artistId } }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                AvatarView(seed: alert.artistName, size: 50)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "arrow.up.right.circle.fill").font(.system(size: 14)).foregroundStyle(VYBE.green).background(VYBE.bg, in: .circle)
                    }
                VStack(alignment: .leading, spacing: 3) {
                    Text(alert.artistName).font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Text("\(alert.city) · \(alert.genre) · \(alert.listenersNow.compact) listeners")
                        .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
                }
                Spacer()
                VStack(spacing: 0) {
                    Text("+\(alert.momentumPct)%").font(.system(size: 15, weight: .black, design: .rounded)).foregroundStyle(VYBE.magenta)
                    Text("momentum").font(.system(size: 9, weight: .semibold)).foregroundStyle(VYBE.textTertiary)
                }
            }
            Text(alert.reason).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.gold)
            VStack(alignment: .leading, spacing: 5) {
                ForEach(alert.signals, id: \.self) { sig in
                    HStack(spacing: 6) {
                        Image(systemName: "chart.line.uptrend.xyaxis").font(.system(size: 10)).foregroundStyle(VYBE.green)
                        Text(sig).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    }
                }
            }
            HStack(spacing: 6) {
                Image(systemName: "sparkle.magnifyingglass").font(.system(size: 10)).foregroundStyle(VYBE.cyan)
                Text(alert.anchor).font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.cyan).lineLimit(1)
            }
            Button {
                app.backEarly(alert)
                withAnimation(.snappy) { backed = true }
            } label: {
                HStack(spacing: 7) {
                    Image(systemName: backed ? "checkmark.circle.fill" : "bolt.heart.fill").font(.system(size: 14, weight: .bold))
                    Text(backed ? "Backed early · Early Discoverer ✓" : "Support early · Early Discoverer bonus")
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                }
                .foregroundStyle(backed ? VYBE.green : .white)
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background {
                    if backed { Capsule().fill(VYBE.green.opacity(0.15)) }
                    else { Capsule().fill(VYBE.holo).neonGlow(VYBE.magenta, radius: 10) }
                }
            }
            .buttonStyle(.plain)
            .disabled(backed)
            if isReal {
                NavigationLink(value: Route.artist(alert.artistId)) {
                    Text("View profile →").font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.purple)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background { ZStack { VYBE.card; HoloArt(seed: alert.artistName + "blow").opacity(0.08) }.clipShape(.rect(cornerRadius: 20)) }
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.gold.opacity(0.3), lineWidth: 1))
    }
}

// MARK: - Scene card

struct SceneCard: View {
    let scene: ScenePulse
    var body: some View {
        NavigationLink(value: Route.scene(scene.id)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(scene.label).font(.system(size: 17, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                        Text(scene.genres.joined(separator: " · ")).font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.magenta)
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("\(scene.heat)").font(.system(size: 26, weight: .black, design: .rounded))
                            .foregroundStyle(scene.heat >= 85 ? VYBE.magenta : VYBE.gold)
                        Text("HEAT").font(.system(size: 9, weight: .heavy, design: .rounded)).tracking(1).foregroundStyle(VYBE.textTertiary)
                    }
                }
                NeonProgressBar(progress: Double(scene.heat) / 100, height: 6, gradient: VYBE.holoSunset)
                Text(scene.blurb).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(2)
                HStack(spacing: 14) {
                    sceneStat("\(scene.risingArtistIds.count)", "rising", VYBE.green)
                    sceneStat("\(scene.showsThisWeek)", "shows", VYBE.blue)
                    sceneStat("\(scene.openChallenges)", "challenges", VYBE.purple)
                    sceneStat("\(scene.fanCrews)", "crews", VYBE.cyan)
                }
            }
            .padding(16)
            .background { ZStack { VYBE.card; HoloArt(seed: scene.label).opacity(0.1) }.clipShape(.rect(cornerRadius: 20)) }
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.stroke, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
    private func sceneStat(_ v: String, _ l: String, _ c: Color) -> some View {
        VStack(spacing: 1) {
            Text(v).font(.system(size: 15, weight: .black, design: .rounded)).foregroundStyle(c)
            Text(l).font(.system(size: 9, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Crew card

struct CrewCard: View {
    @Environment(AppState.self) private var app
    let crew: FanCrew
    var showJoin: Bool = true
    private var joined: Bool { app.joinedCrews.contains(crew.id) }
    var body: some View {
        NavigationLink(value: Route.fanCrew(crew.id)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: crew.focus.icon).font(.system(size: 16)).foregroundStyle(.white)
                        .frame(width: 40, height: 40).background(VYBE.holo, in: .circle)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(crew.name).font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(1)
                        Text("\(crew.focusLabel) · \(crew.members.compact) members").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("\(crew.impactScore)").font(.system(size: 16, weight: .black, design: .rounded)).foregroundStyle(VYBE.magenta)
                        Text("impact").font(.system(size: 9, weight: .semibold)).foregroundStyle(VYBE.textTertiary)
                    }
                }
                HStack(spacing: 6) {
                    Image(systemName: "target").font(.system(size: 10)).foregroundStyle(VYBE.gold)
                    Text(crew.currentMission).font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.gold).lineLimit(1)
                }
                if showJoin {
                    Button { app.toggleCrew(crew.id) } label: {
                        Text(joined ? "Joined ✓" : "Join crew")
                            .font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(joined ? VYBE.green : .white)
                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background { if joined { Capsule().fill(VYBE.green.opacity(0.15)) } else { Capsule().fill(VYBE.holo) } }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(14).vybeCard(corner: 18)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Mission card

struct MissionCard: View {
    @Environment(AppState.self) private var app
    let mission: ArtistMission
    @State private var receipt: SupportReceipt? = nil
    private var live: ArtistMission { app.mission(mission.id) ?? mission }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: live.type.icon).font(.system(size: 16, weight: .bold)).foregroundStyle(live.type.color)
                    .frame(width: 38, height: 38).background(live.type.color.opacity(0.15), in: .circle)
                VStack(alignment: .leading, spacing: 2) {
                    Text(live.title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(2)
                    Text("\(live.artistName) · \(live.deadlineText)").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                }
                Spacer()
                Text("+\(live.points)").font(.system(size: 13, weight: .black, design: .rounded)).foregroundStyle(VYBE.gold)
            }
            GoalBar(label: "\(live.progress) / \(live.goal) \(live.unit)", value: "\(Int(live.pct * 100))%", progress: live.pct, color: live.type.color)
            HStack(spacing: 8) {
                Image(systemName: "gift.fill").font(.system(size: 11)).foregroundStyle(VYBE.gold)
                Text(live.reward).font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
                Spacer()
            }
            Button { receipt = app.contributeToMission(live.id) } label: {
                Text(live.pct >= 1 ? "Completed ✓" : "Help this mission")
                    .font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(live.pct >= 1 ? VYBE.green : .white)
                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                    .background { if live.pct >= 1 { Capsule().fill(VYBE.green.opacity(0.15)) } else { Capsule().fill(live.type.color.opacity(0.9)) } }
            }
            .buttonStyle(.plain)
            .disabled(live.pct >= 1)
        }
        .padding(14).vybeCard(corner: 18)
        .sheet(item: $receipt) { r in
            NavigationStack {
                SupportReceiptView(receipt: r)
                    .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Done") { receipt = nil }.foregroundStyle(VYBE.text) } }
            }
            .environment(app)
        }
    }
}

// MARK: - Need card

struct NeedCard: View {
    @Environment(AppState.self) private var app
    let need: ArtistNeed
    @State private var applied = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: need.type.icon).font(.system(size: 16, weight: .bold)).foregroundStyle(VYBE.cyan)
                    .frame(width: 38, height: 38).background(VYBE.cyan.opacity(0.15), in: .circle)
                VStack(alignment: .leading, spacing: 2) {
                    Text(need.type.label).font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Text("\(need.artistName) · \(need.location) · \(need.genre)").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
                }
                Spacer()
                StatusPill(text: need.deadlineText, color: VYBE.gold)
            }
            Text(need.description).font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(2)
            HStack(spacing: 6) {
                Image(systemName: "doc.text.fill").font(.system(size: 10)).foregroundStyle(VYBE.green)
                Text(need.compensation).font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.green)
            }
            Button { withAnimation(.snappy) { applied = true }; app.haptic(.light) } label: {
                Text(applied ? "Response sent ✓" : "Respond / apply")
                    .font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(applied ? VYBE.green : .white)
                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                    .background { if applied { Capsule().fill(VYBE.green.opacity(0.15)) } else { Capsule().fill(VYBE.holo) } }
            }
            .buttonStyle(.plain).disabled(applied)
        }
        .padding(14).vybeCard(corner: 18)
    }
}

// MARK: - Premiere card

struct PremiereCard: View {
    let premiere: VideoPremiere
    var width: CGFloat = 280
    var body: some View {
        NavigationLink(value: Route.premiere(premiere.id)) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    HoloArt(seed: premiere.previewSeed, corner: 16).frame(width: width, height: width * 0.56)
                    LinearGradient(colors: [.clear, .black.opacity(0.55)], startPoint: .center, endPoint: .bottom)
                        .frame(width: width, height: width * 0.56).clipShape(.rect(cornerRadius: 16))
                    Image(systemName: premiere.isLive ? "dot.radiowaves.left.and.right" : "play.circle.fill")
                        .font(.system(size: 40)).foregroundStyle(.white).shadow(radius: 6)
                }
                .overlay(alignment: .topLeading) {
                    StatusPill(text: premiere.premiereStatus, color: premiere.isLive ? VYBE.magenta : VYBE.gold,
                               icon: premiere.isLive ? "dot.radiowaves.left.and.right" : "sparkles.tv.fill").padding(8)
                }
                .overlay(alignment: .bottomTrailing) {
                    Text(premiere.countdownText).font(.system(size: 10, weight: .bold)).foregroundStyle(.white)
                        .padding(.horizontal, 6).padding(.vertical, 3).background(.black.opacity(0.6), in: .capsule).padding(8)
                }
                Text(premiere.title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(1).frame(width: width, alignment: .leading)
                Text(premiere.artistName).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1).frame(width: width, alignment: .leading)
            }
            .frame(width: width)
        }
        .buttonStyle(.plain)
    }
}
