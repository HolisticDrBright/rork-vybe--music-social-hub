//
//  ScenePulseView.swift
//  VYBE
//
//  Scene Pulse — city/scene heat with rising artists, shows, challenges,
//  crews, and open needs. A culture map, not a geographic one.
//

import SwiftUI

struct ScenePulseView: View {
    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Where the culture is moving right now. Tap a scene to dive in.")
                        .font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    ForEach(Mock.scenePulses.sorted { $0.heat > $1.heat }) { SceneCard(scene: $0) }
                }
                .padding(.horizontal, 20).padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Scene Pulse")
        .navigationBarTitleDisplayMode(.large)
        .vybeDestinations()
    }
}

struct SceneDetailView: View {
    @Environment(AppState.self) private var app
    let sceneId: String
    private var scene: ScenePulse? { Mock.scene(sceneId) }

    var body: some View {
        ZStack {
            VYBEBackground()
            if let s = scene {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        header(s)
                        risingArtists(s)
                        quickActions(s)
                        crews(s)
                    }
                    .padding(.horizontal, 20).padding(.vertical, 16)
                }
                .scrollIndicators(.hidden)
            } else {
                Text("Scene not found.").foregroundStyle(VYBE.textSecondary)
            }
        }
        .navigationTitle(scene?.city ?? "Scene")
        .navigationBarTitleDisplayMode(.inline)
        .vybeDestinations()
    }

    private func header(_ s: ScenePulse) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(s.label).font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                    Text(s.genres.joined(separator: " · ")).font(.system(size: 13, weight: .semibold)).foregroundStyle(VYBE.magenta)
                }
                Spacer()
                VStack(spacing: 0) {
                    Text("\(s.heat)").font(.system(size: 32, weight: .black, design: .rounded)).foregroundStyle(VYBE.magenta)
                    Text("HEAT").font(.system(size: 9, weight: .heavy, design: .rounded)).tracking(1).foregroundStyle(VYBE.textTertiary)
                }
            }
            NeonProgressBar(progress: Double(s.heat) / 100, height: 7, gradient: VYBE.holoSunset)
            Text(s.blurb).font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(3)
            HStack(spacing: 10) {
                StatusPill(text: "\(s.showsThisWeek) shows", color: VYBE.blue, icon: "ticket.fill")
                StatusPill(text: "\(s.openChallenges) challenges", color: VYBE.purple, icon: "person.2.wave.2.fill")
                StatusPill(text: "\(s.fanCrews) crews", color: VYBE.cyan, icon: "person.3.fill")
            }
        }
        .padding(16).vybeCard(corner: 20)
    }

    private func risingArtists(_ s: ScenePulse) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Rising in \(s.city)")
            ForEach(s.risingArtistIds.compactMap { id in Mock.artists.first { $0.id == id } }) { artist in
                NavigationLink(value: Route.artist(artist.id)) { ArtistRow(artist: artist, showEarnings: true) }.buttonStyle(.plain)
            }
        }
    }

    private func quickActions(_ s: ScenePulse) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Get involved")
            HStack(spacing: 10) {
                sceneLink("Trending: \(s.trendingDrop)", "flame.fill", VYBE.magenta, .dropCampaigns)
                sceneLink("Open beat challenges", "person.2.wave.2.fill", VYBE.purple, .collabLab)
            }
            HStack(spacing: 10) {
                sceneLink("Fan crews", "person.3.fill", VYBE.cyan, .fanCrews)
                sceneLink("Artist needs", "hands.sparkles.fill", VYBE.green, .artistNeeds)
            }
        }
    }

    private func sceneLink(_ title: String, _ icon: String, _ color: Color, _ route: Route) -> some View {
        NavigationLink(value: route) {
            HStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 14, weight: .bold)).foregroundStyle(color)
                Text(title).font(.system(size: 12, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(2)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading).padding(12).vybeCard(corner: 14)
        }
        .buttonStyle(.plain)
    }

    private func crews(_ s: ScenePulse) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Crews in this scene")
            ForEach(Mock.fanCrews.filter { $0.focusLabel.localizedCaseInsensitiveContains(s.city) || $0.focus == .genre }.prefix(2)) { crew in
                CrewCard(crew: crew)
            }
        }
    }
}
