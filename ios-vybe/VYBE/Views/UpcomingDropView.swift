//
//  UpcomingDropView.swift
//  VYBE
//
//  A collab release "Born on VYBE" — fans can pre-save and support it early,
//  tying Collab Lab back into the VYBE support economy.
//

import SwiftUI

struct UpcomingDropView: View {
    @Environment(AppState.self) private var app
    let dropId: String
    @State private var receipt: SupportReceipt? = nil

    private var drop: UpcomingDrop? { app.upcomingDrops.first { $0.id == dropId } }
    private var presaved: Bool { app.presavedDrops.contains(dropId) }

    var body: some View {
        ZStack {
            if let drop {
                HoloArt(seed: drop.previewSeed).ignoresSafeArea().opacity(0.5).blur(radius: 40)
                VYBE.bg.opacity(0.55).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        hero(drop)
                        if drop.bornOnVYBE { BornOnVYBEBanner() }
                        originCard(drop)
                        if let cid = drop.campaignId, app.dropCampaign(cid) != nil {
                            NavigationLink(value: Route.dropCampaign(cid)) {
                                HStack(spacing: 12) {
                                    Image(systemName: "flame.fill").font(.system(size: 16)).foregroundStyle(.white)
                                        .frame(width: 40, height: 40).background(VYBE.holoSunset, in: .circle)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Open the full Drop Campaign").font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                                        Text("Goals · missions · leaderboard · premiere").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                                    }
                                    Spacer(); Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
                                }
                                .padding(14).vybeCard(corner: 18)
                            }
                            .buttonStyle(.plain)
                        }
                        Text(drop.description)
                            .font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                            .multilineTextAlignment(.center).lineSpacing(4).padding(.horizontal, 8)
                        presaveCard(drop)
                        launchChallengeCard(drop)
                        collaboratorsCard(drop)
                        splitCard(drop)
                    }
                    .padding(.horizontal, 20).padding(.bottom, 36)
                }
                .scrollIndicators(.hidden)
            } else {
                VYBEBackground()
                CollabEmptyState(text: "This drop is no longer available.", icon: "sparkles")
            }
        }
        .navigationTitle("Upcoming Drop")
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

    private func hero(_ drop: UpcomingDrop) -> some View {
        VStack(spacing: 12) {
            HoloArt(seed: drop.previewSeed, corner: 26)
                .frame(width: 240, height: 240)
                .neonGlow(VYBE.magenta, radius: 26)
                .overlay(alignment: .topLeading) {
                    if drop.bornOnVYBE { NeonTag(text: "Born on VYBE", color: VYBE.cyan, icon: "sparkles").padding(12) }
                }
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "play.circle.fill").font(.system(size: 40)).foregroundStyle(.white).padding(12).shadow(radius: 6)
                }
                .padding(.top, 8)
            Text(drop.title).font(.system(size: 24, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                .multilineTextAlignment(.center)
            Text(drop.artistNames.joined(separator: "  ×  ")).font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.magenta)
            HStack(spacing: 10) {
                NeonTag(text: drop.genre, color: VYBE.purple, icon: "guitars")
                NeonTag(text: drop.releaseText, color: VYBE.gold, icon: "calendar")
            }
        }
    }

    private func originCard(_ drop: UpcomingDrop) -> some View {
        Group {
            if let chId = drop.originChallengeId {
                NavigationLink(value: Route.collabChallenge(chId)) { originRow(chevron: true) }.buttonStyle(.plain)
            } else {
                originRow(chevron: false)
            }
        }
    }

    private func originRow(chevron: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "person.2.wave.2.fill").font(.system(size: 16)).foregroundStyle(.white)
                .frame(width: 40, height: 40).background(VYBE.holo, in: .circle)
            VStack(alignment: .leading, spacing: 2) {
                Text("Started as a VYBE Collab Lab challenge").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Text("Open beat challenge → winning collaborator → this drop").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
            if chevron { Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(VYBE.textTertiary) }
        }
        .padding(14).vybeCard(corner: 18)
    }

    private func presaveCard(_ drop: UpcomingDrop) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "bolt.heart.fill").foregroundStyle(VYBE.magenta)
                Text("Support this collab early").font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Spacer()
                Text("\(drop.earlySupporters) early")
                    .font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.green)
                    .contentTransition(.numericText())
            }
            Button { receipt = app.presaveDrop(dropId) } label: {
                HStack(spacing: 8) {
                    Image(systemName: presaved ? "checkmark.circle.fill" : "bookmark.fill").font(.system(size: 15, weight: .bold))
                    Text(presaved ? "Pre-saved · First Heard It earned" : "Pre-save & support early")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                }
                .foregroundStyle(presaved ? VYBE.green : .white)
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background {
                    if presaved { Capsule().fill(VYBE.green.opacity(0.15)).overlay(Capsule().stroke(VYBE.green.opacity(0.3), lineWidth: 1)) }
                    else { Capsule().fill(VYBE.holo).neonGlow(VYBE.magenta, radius: 12) }
                }
            }
            .buttonStyle(.plain)
            HStack(spacing: 6) {
                Image(systemName: "sparkle").font(.system(size: 10)).foregroundStyle(VYBE.gold)
                Text(presaved
                     ? "Early Supporter bonus claimed: +180 VYBE Score · “First Heard It” + “Collab Scout” badges"
                     : "Early supporters earn +180 VYBE Score and the “First Heard It” + “Collab Scout” badges.")
                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.gold).lineSpacing(2)
            }
        }
        .padding(16).vybeCard(corner: 20)
    }

    private func launchChallengeCard(_ drop: UpcomingDrop) -> some View {
        Button { app.share(drop.title); app.hapticSuccess() } label: {
            HStack(spacing: 12) {
                Image(systemName: "flame.fill").font(.system(size: 16)).foregroundStyle(VYBE.gold)
                    .frame(width: 40, height: 40).background(VYBE.gold.opacity(0.15), in: .circle)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Help this collab drop trend").font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Text("Launch challenge · share to boost both artists · +250").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                }
                Spacer()
                Image(systemName: "square.and.arrow.up").foregroundStyle(VYBE.gold)
            }
            .padding(14).vybeCard(corner: 18)
        }
        .buttonStyle(.plain)
    }

    private func collaboratorsCard(_ drop: UpcomingDrop) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Collaborators").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.textSecondary)
            HStack(spacing: 16) {
                ForEach(drop.artistNames, id: \.self) { name in
                    VStack(spacing: 6) {
                        AvatarView(seed: name, size: 56)
                        Text(name).font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.text).lineLimit(1).frame(width: 76)
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14).vybeCard(corner: 18)
    }

    private func splitCard(_ drop: UpcomingDrop) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.magnifyingglass").foregroundStyle(VYBE.gold)
                Text("Split & credit").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
            }
            Text("Proposed split: \(drop.splitNote)").font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
            Text(Mock.collabRightsNotice).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textTertiary).lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(VYBE.gold.opacity(0.06), in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(VYBE.gold.opacity(0.2), lineWidth: 1))
    }
}
