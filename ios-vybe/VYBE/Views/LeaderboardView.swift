//
//  LeaderboardView.swift
//  VYBE
//

import SwiftUI

struct LeaderboardView: View {
    let artistId: String
    @State private var scope = "Global"
    private let scopes = ["Global", "City", "Weekly", "All-Time"]

    private var artist: Artist { Mock.artist(artistId) }
    private var fans: [LeaderFan] {
        switch scope {
        case "City": return Mock.leaderboard.filter { $0.city == "Los Angeles" }
        case "Weekly": return Array(Mock.leaderboard.shuffled())
        default: return Mock.leaderboard
        }
    }

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(spacing: 18) {
                    Text("Top Fans of \(artist.name)")
                        .font(.system(size: 13, weight: .bold)).foregroundStyle(VYBE.textSecondary)
                    podium
                    prizes
                    ChipRow(items: scopes, selection: $scope).padding(.horizontal, -20)
                    VStack(spacing: 10) {
                        ForEach(Array(fans.enumerated()), id: \.element.id) { idx, fan in
                            LeaderRow(rank: idx + 1, fan: fan)
                        }
                    }
                }
                .padding(.horizontal, 20).padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Leaderboard")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var podium: some View {
        HStack(alignment: .bottom, spacing: 12) {
            podiumFan(Mock.leaderboard[1], rank: 2, height: 90, color: VYBE.cyan)
            podiumFan(Mock.leaderboard[0], rank: 1, height: 120, color: VYBE.gold)
            podiumFan(Mock.leaderboard[2], rank: 3, height: 70, color: VYBE.magenta)
        }
    }

    private func podiumFan(_ fan: LeaderFan, rank: Int, height: CGFloat, color: Color) -> some View {
        VStack(spacing: 8) {
            ZStack(alignment: .top) {
                AvatarView(seed: fan.avatarSeed, size: rank == 1 ? 64 : 52).neonGlow(color, radius: 12)
                if rank == 1 {
                    Image(systemName: "crown.fill").font(.system(size: 20)).foregroundStyle(VYBE.gold).offset(y: -16)
                }
            }
            .padding(.top, rank == 1 ? 16 : 0)
            Text("@\(fan.name)").font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.text).lineLimit(1)
            Text(fan.score.compact).font(.system(size: 12, weight: .black, design: .rounded)).foregroundStyle(color)
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.18))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(color.opacity(0.4), lineWidth: 1))
                .frame(height: height)
                .overlay(Text("\(rank)").font(.system(size: 28, weight: .black, design: .rounded)).foregroundStyle(color))
        }
        .frame(maxWidth: .infinity)
    }

    private var prizes: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🎁 This week's top fans win").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["Free Tickets", "VIP Access", "Meet & Greet", "Backstage Pass", "Signed Merch", "Shoutout"], id: \.self) { p in
                        NeonTag(text: p, color: VYBE.gold, icon: "gift.fill")
                    }
                }
            }
        }
        .padding(14).vybeCard(corner: 18)
    }
}

struct LeaderRow: View {
    let rank: Int
    let fan: LeaderFan
    private var isYou: Bool { fan.name == "you" }

    var body: some View {
        HStack(spacing: 12) {
            Text("\(rank)")
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundStyle(rank <= 3 ? VYBE.gold : VYBE.textSecondary)
                .frame(width: 26)
            AvatarView(seed: fan.avatarSeed, size: 42)
            VStack(alignment: .leading, spacing: 2) {
                Text(isYou ? "You" : "@\(fan.name)").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                HStack(spacing: 4) {
                    Image(systemName: "crown.fill").font(.system(size: 9)).foregroundStyle(VYBE.gold)
                    Text(fan.topBadge).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                }
            }
            Spacer()
            Text(fan.score.compact)
                .font(.system(size: 15, weight: .black, design: .rounded)).foregroundStyle(VYBE.magenta)
        }
        .padding(12)
        .background(isYou ? VYBE.purple.opacity(0.14) : VYBE.card, in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isYou ? VYBE.purple.opacity(0.5) : VYBE.stroke, lineWidth: 1))
    }
}
