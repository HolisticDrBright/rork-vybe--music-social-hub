//
//  FanCrewView.swift
//  VYBE
//
//  Fan Crews — social growth squads around artists, cities, genres, drops,
//  events, and collabs.
//

import SwiftUI

struct FanCrewsView: View {
    @Environment(AppState.self) private var app
    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Join a crew. Run missions together. Earn status as a unit.")
                        .font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    if !app.joinedCrews.isEmpty {
                        SectionHeader(title: "Your crews")
                        ForEach(Mock.fanCrews.filter { app.joinedCrews.contains($0.id) }) { CrewCard(crew: $0) }
                    }
                    SectionHeader(title: "Crews to join")
                    ForEach(Mock.fanCrews.filter { !app.joinedCrews.contains($0.id) }) { CrewCard(crew: $0) }
                }
                .padding(.horizontal, 20).padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Fan Crews")
        .navigationBarTitleDisplayMode(.large)
        .vybeDestinations()
    }
}

struct FanCrewDetailView: View {
    @Environment(AppState.self) private var app
    let crewId: String
    private var crew: FanCrew? { Mock.crew(crewId) }
    private var joined: Bool { app.joinedCrews.contains(crewId) }

    var body: some View {
        ZStack {
            VYBEBackground()
            if let c = crew {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        header(c)
                        mission(c)
                        activity(c)
                        leaderboard
                    }
                    .padding(.horizontal, 20).padding(.vertical, 16)
                }
                .scrollIndicators(.hidden)
            } else {
                Text("Crew not found.").foregroundStyle(VYBE.textSecondary)
            }
        }
        .navigationTitle("Fan Crew")
        .navigationBarTitleDisplayMode(.inline)
        .vybeDestinations()
    }

    private func header(_ c: FanCrew) -> some View {
        VStack(spacing: 12) {
            Image(systemName: c.focus.icon).font(.system(size: 26)).foregroundStyle(.white)
                .frame(width: 72, height: 72).background(VYBE.holo, in: .circle).neonGlow(VYBE.purple, radius: 14)
            Text(c.name).font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(VYBE.text).multilineTextAlignment(.center)
            Text(c.blurb).font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary).multilineTextAlignment(.center)
            HStack(spacing: 24) {
                StatBlock(value: c.members.compact, label: "Members", color: VYBE.cyan)
                StatBlock(value: "\(c.impactScore)", label: "Impact", color: VYBE.magenta)
                StatBlock(value: c.focus.label, label: "Focus", color: VYBE.gold)
            }
            Button { app.toggleCrew(c.id) } label: {
                Text(joined ? "Joined ✓ · you're in the crew" : "Join this crew")
                    .font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(joined ? VYBE.green : .white)
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background { if joined { Capsule().fill(VYBE.green.opacity(0.15)) } else { Capsule().fill(VYBE.holo).neonGlow(VYBE.magenta, radius: 10) } }
            }
            .buttonStyle(.plain)
        }
        .padding(16).vybeCard(corner: 20)
    }

    private func mission(_ c: FanCrew) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Current crew mission", systemImage: "target").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.gold)
            Text(c.currentMission).font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16).background(VYBE.gold.opacity(0.07), in: .rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.gold.opacity(0.25), lineWidth: 1))
    }

    private func activity(_ c: FanCrew) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Recent activity")
            ForEach(Array(c.recentActivity.enumerated()), id: \.offset) { _, a in
                HStack(spacing: 10) {
                    Image(systemName: "circle.fill").font(.system(size: 5)).foregroundStyle(VYBE.magenta)
                    Text(a).font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    Spacer()
                }
                .padding(.horizontal, 12).padding(.vertical, 10).vybeCard(corner: 12)
            }
        }
    }

    private var leaderboard: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Crew leaderboard")
            ForEach(Array(Mock.leaderboard.prefix(4).enumerated()), id: \.element.id) { idx, fan in
                HStack(spacing: 12) {
                    Text("\(idx + 1)").font(.system(size: 14, weight: .black, design: .rounded)).foregroundStyle(idx == 0 ? VYBE.gold : VYBE.textSecondary).frame(width: 20)
                    AvatarView(seed: fan.avatarSeed, size: 34)
                    Text("@\(fan.name)").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                    Spacer()
                    Text(fan.score.compact).font(.system(size: 13, weight: .black, design: .rounded)).foregroundStyle(VYBE.magenta)
                }
                .padding(10).vybeCard(corner: 14)
            }
        }
    }
}
