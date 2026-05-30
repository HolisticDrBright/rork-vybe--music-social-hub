//
//  DropCampaignView.swift
//  VYBE
//
//  Release campaign pages for artist drops — goals, fan missions, leaderboard,
//  early-supporter rewards, and the support/boost CTAs.
//

import SwiftUI

struct DropCampaignsHubView: View {
    @Environment(AppState.self) private var app
    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Back a drop before it becomes a cultural moment.")
                        .font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    ForEach(app.dropCampaigns) { DropCampaignCard(campaign: $0) }
                }
                .padding(.horizontal, 20).padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Drop Campaigns")
        .navigationBarTitleDisplayMode(.large)
        .vybeDestinations()
    }
}

struct DropCampaignView: View {
    @Environment(AppState.self) private var app
    let campaignId: String
    @State private var receipt: SupportReceipt? = nil

    private var campaign: DropCampaign? { app.dropCampaign(campaignId) }

    var body: some View {
        ZStack {
            if let c = campaign {
                HoloArt(seed: c.coverSeed).ignoresSafeArea().opacity(0.5).blur(radius: 40)
                VYBE.bg.opacity(0.6).ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        hero(c)
                        if c.bornOnVYBE { BornOnVYBEBanner() }
                        goals(c)
                        ctas(c)
                        rewards(c)
                        missions(c)
                        leaderboard
                        if c.videoId != nil { videoLink(c) }
                    }
                    .padding(.horizontal, 20).padding(.vertical, 16)
                }
                .scrollIndicators(.hidden)
            } else {
                VYBEBackground()
                Text("Campaign not found.").foregroundStyle(VYBE.textSecondary)
            }
        }
        .navigationTitle("Drop Campaign")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $receipt) { r in
            NavigationStack {
                SupportReceiptView(receipt: r)
                    .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Done") { receipt = nil }.foregroundStyle(VYBE.text) } }
            }
            .environment(app)
        }
        .vybeDestinations()
    }

    private func hero(_ c: DropCampaign) -> some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomLeading) {
                HoloArt(seed: c.coverSeed, corner: 22).frame(height: 200)
                LinearGradient(colors: [.clear, .black.opacity(0.6)], startPoint: .center, endPoint: .bottom)
                HStack { StatusPill(text: c.status.label, color: c.status.color, icon: c.status.icon); Spacer(); if c.bornOnVYBE { BornOnVYBEBadge() } }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top).padding(12)
            }
            .frame(height: 200).clipShape(.rect(cornerRadius: 22))
            VStack(spacing: 4) {
                Text(c.title).font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(VYBE.text).multilineTextAlignment(.center)
                Text(c.subtitle).font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary).multilineTextAlignment(.center)
                NavigationLink(value: Route.artist(c.artistId)) {
                    Text(c.artistName).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.magenta)
                }
                Text(c.countdownText).font(.system(size: 12, weight: .bold)).foregroundStyle(c.status.color).padding(.top, 2)
            }
        }
    }

    private func goals(_ c: DropCampaign) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Campaign goals").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.textSecondary)
            GoalBar(label: "Fan support", value: "$\(c.raisedUSD) / $\(c.supportGoalUSD)", progress: c.fundingProgress, color: VYBE.green)
            GoalBar(label: "Boosts", value: "\(c.boosts) / \(c.boostGoal)", progress: c.boostProgress, color: VYBE.magenta)
            GoalBar(label: "Pre-saves", value: "\(c.presaves) / \(c.presaveGoal)", progress: c.presaveProgress, color: VYBE.cyan)
            HStack(spacing: 8) {
                Image(systemName: "dollarsign.circle.fill").foregroundStyle(VYBE.gold)
                Text("Artist earnings goal: $\(c.earningsGoalUSD) · keeps 90%").font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.gold)
            }
        }
        .padding(16).vybeCard(corner: 18)
    }

    private func ctas(_ c: DropCampaign) -> some View {
        HStack(spacing: 12) {
            Button { receipt = app.supportCampaign(c.id, amount: 10) } label: {
                Label("Support · $10", systemImage: "bolt.heart.fill")
                    .font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 14).background(VYBE.holo, in: .capsule).neonGlow(VYBE.magenta, radius: 10)
            }.buttonStyle(.plain)
            Button { app.boostCampaign(c.id) } label: {
                Label("Boost", systemImage: "bolt.horizontal.fill")
                    .font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.magenta)
                    .frame(maxWidth: .infinity).padding(.vertical, 14).background(VYBE.magenta.opacity(0.14), in: .capsule)
                    .overlay(Capsule().stroke(VYBE.magenta.opacity(0.4), lineWidth: 1))
            }.buttonStyle(.plain)
        }
    }

    private func rewards(_ c: DropCampaign) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Early supporter rewards", systemImage: "gift.fill").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.gold)
            ForEach(c.rewards, id: \.self) { r in
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 13)).foregroundStyle(VYBE.gold)
                    Text(r).font(.system(size: 13, weight: .semibold)).foregroundStyle(VYBE.text)
                    Spacer()
                }
            }
        }
        .padding(16).background(VYBE.gold.opacity(0.07), in: .rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.gold.opacity(0.25), lineWidth: 1))
    }

    @ViewBuilder private func missions(_ c: DropCampaign) -> some View {
        let ms = c.missionIds.compactMap { app.mission($0) }
        if !ms.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Fan missions")
                ForEach(ms) { MissionCard(mission: $0) }
            }
        }
    }

    private var leaderboard: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Top supporters")
            ForEach(Array(Mock.leaderboard.prefix(4).enumerated()), id: \.element.id) { idx, fan in
                HStack(spacing: 12) {
                    Text("\(idx + 1)").font(.system(size: 14, weight: .black, design: .rounded)).foregroundStyle(idx == 0 ? VYBE.gold : VYBE.textSecondary).frame(width: 20)
                    AvatarView(seed: fan.avatarSeed, size: 36)
                    Text("@\(fan.name)").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                    Spacer()
                    Text(fan.score.compact).font(.system(size: 13, weight: .black, design: .rounded)).foregroundStyle(VYBE.magenta)
                }
                .padding(10).vybeCard(corner: 14)
            }
        }
    }

    private func videoLink(_ c: DropCampaign) -> some View {
        NavigationLink(value: Route.vybeTV) {
            HStack(spacing: 12) {
                Image(systemName: "play.tv.fill").font(.system(size: 16)).foregroundStyle(.white)
                    .frame(width: 40, height: 40).background(VYBE.holo, in: .circle)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Watch the video on VYBE TV").font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Text("Premiere + behind-the-video").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
            }
            .padding(14).vybeCard(corner: 18)
        }
        .buttonStyle(.plain)
    }
}
