//
//  PremiereView.swift
//  VYBE
//
//  VYBE TV video premiere — countdown, watch-party feel, live chat placeholder,
//  support during premiere, and the Premiere Crew badge moment.
//

import SwiftUI

struct PremiereView: View {
    @Environment(AppState.self) private var app
    let premiereId: String
    @State private var receipt: SupportReceipt? = nil
    @State private var reacted = false

    private var premiere: VideoPremiere? { Mock.premiere(premiereId) }
    private let chat: [(String, String)] = [
        ("glowqueen", "been waiting ALL week for this 🔥"),
        ("static_kid", "the parking structure shoot??? insane"),
        ("dreampop_dani", "supporting now, let's get them paid"),
        ("neon_nadia", "premiere crew represent 🫡"),
        ("sol_seeker", "this is what music TV was missing"),
    ]

    var body: some View {
        ZStack {
            if let p = premiere {
                HoloArt(seed: p.previewSeed).ignoresSafeArea().opacity(0.55).blur(radius: 34)
                VYBE.bg.opacity(0.62).ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        countdownBanner(p)
                        videoScreen(p)
                        intro(p)
                        liveChat
                        supportBar(p)
                    }
                    .padding(.horizontal, 20).padding(.vertical, 16)
                }
                .scrollIndicators(.hidden)
            } else {
                VYBEBackground(); Text("Premiere not found.").foregroundStyle(VYBE.textSecondary)
            }
        }
        .navigationTitle("VYBE TV Premiere")
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

    private func countdownBanner(_ p: VideoPremiere) -> some View {
        HStack(spacing: 10) {
            Image(systemName: p.isLive ? "dot.radiowaves.left.and.right" : "sparkles.tv.fill").font(.system(size: 16)).foregroundStyle(.white)
            VStack(alignment: .leading, spacing: 1) {
                Text(p.premiereStatus.uppercased()).font(.system(size: 11, weight: .heavy, design: .rounded)).tracking(1).foregroundStyle(.white)
                Text(p.isLive ? "Live now on VYBE TV" : "Video countdown · \(p.countdownText)").font(.system(size: 13, weight: .bold)).foregroundStyle(.white)
            }
            Spacer()
        }
        .padding(14)
        .background(LinearGradient(colors: p.isLive ? [VYBE.magenta, VYBE.purple] : [VYBE.gold, VYBE.magenta], startPoint: .leading, endPoint: .trailing), in: .rect(cornerRadius: 16))
        .neonGlow(VYBE.magenta, radius: 12)
    }

    private func videoScreen(_ p: VideoPremiere) -> some View {
        ZStack {
            HoloArt(seed: p.previewSeed, corner: 18).aspectRatio(16.0/9.0, contentMode: .fit)
            Image(systemName: p.isLive ? "pause.circle.fill" : "play.circle.fill").font(.system(size: 54)).foregroundStyle(.white.opacity(0.92)).shadow(radius: 8)
            Text(p.isLive ? "LIVE" : "PREMIERE SOON").font(.system(size: 9, weight: .heavy, design: .rounded)).tracking(2)
                .foregroundStyle(.white).padding(.horizontal, 8).padding(.vertical, 4)
                .background((p.isLive ? VYBE.magenta : VYBE.gold).opacity(0.9), in: .capsule)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).padding(10)
        }
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.15), lineWidth: 1))
    }

    private func intro(_ p: VideoPremiere) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(p.title).font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
            NavigationLink(value: Route.artist(p.artistId)) {
                HStack(spacing: 10) {
                    AvatarView(seed: p.artistName, size: 40)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(p.artistName).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                        Text("Artist intro").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    }
                    Spacer(); Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
                }
            }
            .buttonStyle(.plain)
            Text("“\(p.artistIntro)”").font(.system(size: 14, weight: .medium, design: .serif)).italic().foregroundStyle(VYBE.text.opacity(0.9)).lineSpacing(3)
        }
        .padding(16).vybeCard(corner: 18)
    }

    private var liveChat: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Live chat", systemImage: "bubble.left.and.bubble.right.fill").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.cyan)
            ForEach(Array(chat.enumerated()), id: \.offset) { _, c in
                HStack(alignment: .top, spacing: 8) {
                    AvatarView(seed: c.0, size: 26)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("@\(c.0)").font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.magenta)
                        Text(c.1).font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    }
                    Spacer()
                }
            }
            Text("Live chat is a placeholder in this prototype.").font(.system(size: 10, weight: .medium)).foregroundStyle(VYBE.textTertiary)
        }
        .padding(16).vybeCard(corner: 18)
    }

    private func supportBar(_ p: VideoPremiere) -> some View {
        VStack(spacing: 12) {
            Button { receipt = app.supportPremiere(p) } label: {
                Label("Support during the premiere", systemImage: "bolt.heart.fill")
                    .font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 15).background(VYBE.holo, in: .capsule).neonGlow(VYBE.magenta, radius: 12)
            }.buttonStyle(.plain)
            HStack(spacing: 12) {
                Button { withAnimation(.snappy) { reacted.toggle() } } label: {
                    Label("\(p.reactions + (reacted ? 1 : 0))", systemImage: reacted ? "heart.fill" : "heart")
                        .font(.system(size: 13, weight: .bold)).foregroundStyle(VYBE.magenta)
                        .padding(.horizontal, 14).padding(.vertical, 9).background(VYBE.magenta.opacity(0.12), in: .capsule)
                }.buttonStyle(.plain)
                Spacer()
                if app.cultureBadges.contains("Premiere Crew") {
                    StatusPill(text: "Premiere Crew ✓", color: VYBE.green, icon: "checkmark.seal.fill")
                } else {
                    Text("Support to join the Premiere Crew").font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
                }
            }
        }
    }
}
