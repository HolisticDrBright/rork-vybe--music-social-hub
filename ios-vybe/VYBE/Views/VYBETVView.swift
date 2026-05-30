//
//  VYBETVView.swift
//  VYBE
//
//  VYBE TV / Video Lounge — an original-MTV-style music video wall.
//  Featured premieres, "Born on VYBE" collab videos, underground premieres,
//  and classics. Mock/placeholder playback.
//

import SwiftUI

struct VYBETVView: View {
    @Environment(AppState.self) private var app
    @State private var playingVideo: MusicVideo? = nil

    private var premieres: [MusicVideo] { Mock.musicVideos.filter { $0.status == .premiere } }
    private var bornOnVYBE: [MusicVideo] { Mock.musicVideos.filter { $0.status == .bornOnVYBE } }
    private var underground: [MusicVideo] { Mock.musicVideos.filter { $0.status == .underground } }
    private var newReleases: [MusicVideo] { Mock.musicVideos.filter { $0.status == .newRelease } }
    private var classics: [MusicVideo] { Mock.musicVideos.filter { $0.status == .classic } }

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    hero
                    section("🔴 Premiering Now", "Live drops on VYBE TV", premieres)
                    section("✨ Born on VYBE", "Collabs that started as challenges", bornOnVYBE)
                    section("👁 Underground & Local", "Scene premieres before they blow up", underground)
                    section("🆕 New Videos", "Fresh from the artists you support", newReleases)
                    section("⭐️ VYBE Classics", "Videos that defined the wall", classics)
                }
                .padding(.horizontal, 20).padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("VYBE TV")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $playingVideo) { VideoPlayerSheet(video: $0).environment(app) }
        .vybeDestinations()
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "tv.fill").foregroundStyle(VYBE.magenta)
                Text("VYBE TV").font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                NeonTag(text: "VIDEO LOUNGE", color: VYBE.cyan, icon: "play.tv.fill")
                Spacer()
            }
            Text("The return of music television — premieres, underground discovery, and behind-the-video stories.")
                .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(3)
            if let feature = premieres.first ?? Mock.musicVideos.first {
                VideoCard(video: feature, width: UIScreen.main.bounds.width - 40) { playingVideo = feature }
                    .padding(.top, 4)
            }
        }
    }

    private func section(_ title: String, _ subtitle: String, _ videos: [MusicVideo]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 19, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Text(subtitle).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            if videos.isEmpty {
                Text("Nothing here yet — check back soon.")
                    .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textTertiary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(videos) { v in
                            VideoCard(video: v, width: 250) { playingVideo = v }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, -20)
            }
        }
    }
}
