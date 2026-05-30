//
//  SongDetailView.swift
//  VYBE
//
//  Song detail with play controls, share sheet, viral points,
//  and dual earning visualization (what the fan earns + what the artist earns).
//

import SwiftUI

struct SongDetailView: View {
    @Environment(AppState.self) private var app
    let songId: String
    @State private var playing = false
    @State private var progress: Double = 0.32
    @State private var showShareSheet = false
    @State private var rotate = false

    private var song: Song { Mock.songs.first { $0.id == songId } ?? Mock.songs[0] }
    private var artist: Artist { Mock.artist(song.artistId) }
    private var saved: Bool { app.savedSongs.contains(songId) }
    private var earnings: ArtistEarnings { Mock.earnings(for: song.artistId) }

    var body: some View {
        ZStack {
            // Ambient backdrop from cover art
            HoloArt(seed: song.title).ignoresSafeArea().opacity(0.5).blur(radius: 40)
            VYBE.bg.opacity(0.55).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    cover
                    titleBlock
                    scrubber
                    controls
                    actionRow
                    viralCard
                    dualEarningsCard
                    NavigationLink(value: Route.artist(artist.id)) {
                        ArtistRow(artist: artist)
                    }.buttonStyle(.plain)
                }
                .padding(20)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(isPresented: $showShareSheet) { ShareSheet(song: song) }
        .vybeDestinations()
        .onChange(of: playing) { _, p in
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                rotate = p
            }
        }
    }

    private var cover: some View {
        HoloArt(seed: song.title, corner: 28)
            .frame(width: 280, height: 280)
            .neonGlow(VYBE.magenta, radius: 30)
            .overlay(
                Circle().stroke(.white.opacity(0.15), lineWidth: 1).frame(width: 80, height: 80)
                    .overlay(Circle().fill(VYBE.bg).frame(width: 24, height: 24))
                    .rotationEffect(.degrees(rotate ? 360 : 0))
            )
            .padding(.top, 10)
    }

    private var titleBlock: some View {
        VStack(spacing: 6) {
            Text(song.title).font(.system(size: 26, weight: .black, design: .rounded)).foregroundStyle(VYBE.text).multilineTextAlignment(.center)
            Text(song.artistName).font(.system(size: 16, weight: .semibold)).foregroundStyle(VYBE.magenta)
            HStack(spacing: 8) {
                NeonTag(text: song.mood, color: VYBE.purple, icon: "sparkles")
                NeonTag(text: "\(song.energy) energy", color: VYBE.cyan, icon: "bolt.fill")
                if song.isViral { NeonTag(text: "VIRAL", color: VYBE.magenta, icon: "flame.fill") }
            }
        }
    }

    private var scrubber: some View {
        VStack(spacing: 6) {
            NeonProgressBar(progress: progress, height: 6)
            HStack {
                Text(timeString(Int(progress * Double(song.durationSec))))
                Spacer()
                Text(timeString(song.durationSec))
            }
            .font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
        }
    }

    private var controls: some View {
        HStack(spacing: 36) {
            Image(systemName: "backward.fill").font(.system(size: 24)).foregroundStyle(VYBE.text)
            Button {
                let g = UIImpactFeedbackGenerator(style: .medium); g.impactOccurred()
                withAnimation(.snappy) { playing.toggle() }
                if playing { app.addScore(20, reason: "Streaming \(song.title)") }
            } label: {
                Image(systemName: playing ? "pause.fill" : "play.fill")
                    .font(.system(size: 30, weight: .black)).foregroundStyle(.white)
                    .frame(width: 76, height: 76)
                    .background(VYBE.holo, in: .circle)
                    .neonGlow(VYBE.purple, radius: 18)
            }
            .buttonStyle(.plain)
            Image(systemName: "forward.fill").font(.system(size: 24)).foregroundStyle(VYBE.text)
        }
    }

    private var actionRow: some View {
        HStack(spacing: 12) {
            iconButton(saved ? "checkmark.circle.fill" : "plus.circle", saved ? "Saved" : "Save", saved ? VYBE.green : VYBE.text) {
                app.toggleSave(songId)
            }
            iconButton("square.and.arrow.up.fill", "Share", VYBE.magenta) {
                showShareSheet = true
            }
            iconButton("heart.fill", "Tip $5", VYBE.gold) {
                app.tipArtist(song.artistId, amount: 5)
                app.hapticSuccess()
            }
            iconButton("video.badge.plus", "Boost", VYBE.cyan) {
                app.boost(song.artistId)
                app.hapticSuccess()
            }
        }
    }

    private func iconButton(_ icon: String, _ label: String, _ color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 18, weight: .bold))
                Text(label).font(.system(size: 11, weight: .bold, design: .rounded))
            }
            .foregroundStyle(color)
            .frame(maxWidth: .infinity).padding(.vertical, 14)
            .vybeCard(corner: 16)
        }
        .buttonStyle(.plain)
    }

    private var viralCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Earn by Sharing", systemImage: "bolt.horizontal.fill")
                    .font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.gold)
                Spacer()
                NavigationLink(value: Route.viralStats) {
                    Text("My impact").font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.purple)
                }
            }
            Text("Share this song and earn points for every click, listen, and new fan you drive.")
                .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            HStack(spacing: 10) {
                miniStat("+250", "per share", VYBE.magenta)
                miniStat("+50", "per listen", VYBE.cyan)
                miniStat("+500", "per referral", VYBE.green)
            }
        }
        .padding(16)
        .background {
            ZStack { VYBE.card; HoloArt(seed: "viral").opacity(0.12) }
                .clipShape(.rect(cornerRadius: 20))
        }
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.gold.opacity(0.3), lineWidth: 1))
    }

    // MARK: - Dual Earnings Card

    private var dualEarningsCard: some View {
        let fanEarningEst = 750
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("The VYBE Loop", systemImage: "arrow.triangle.capsulepath")
                    .font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.green)
                Spacer()
                NavigationLink(value: Route.earnings(song.artistId)) {
                    Text("Artist earnings →").font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.green)
                }
            }
            Text("Support this artist and BOTH sides win.")
                .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary)

            HStack(spacing: 0) {
                // Fan side
                VStack(spacing: 6) {
                    Image(systemName: "bolt.fill").font(.system(size: 20)).foregroundStyle(VYBE.gold)
                    Text("+\(fanEarningEst)").font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(VYBE.gold)
                    Text("Your VYBE Score").font(.system(size: 10, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
                    Text("+ rank up").font(.system(size: 10, weight: .bold)).foregroundStyle(VYBE.cyan)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 10).background(VYBE.gold.opacity(0.06), in: .rect(cornerRadius: 12))

                Image(systemName: "arrow.left.arrow.right").foregroundStyle(VYBE.textTertiary).padding(.horizontal, 6)

                // Artist side
                VStack(spacing: 6) {
                    Image(systemName: "dollarsign.circle.fill").font(.system(size: 20)).foregroundStyle(VYBE.green)
                    Text("$\(Int(Double(750) * 0.12) + 5)").font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(VYBE.green)
                    Text("Artist earns").font(.system(size: 10, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
                    Text("keeps 90%").font(.system(size: 10, weight: .bold)).foregroundStyle(VYBE.green)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 10).background(VYBE.green.opacity(0.06), in: .rect(cornerRadius: 12))
            }
        }
        .padding(16)
        .background {
            ZStack { VYBE.card; HoloArt(seed: "dualearn").opacity(0.1) }
                .clipShape(.rect(cornerRadius: 20))
        }
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.green.opacity(0.3), lineWidth: 1))
    }

    private func miniStat(_ v: String, _ l: String, _ c: Color) -> some View {
        VStack(spacing: 2) {
            Text(v).font(.system(size: 16, weight: .black, design: .rounded)).foregroundStyle(c)
            Text(l).font(.system(size: 10, weight: .medium)).foregroundStyle(VYBE.textSecondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 10)
        .background(.white.opacity(0.04), in: .rect(cornerRadius: 12))
    }

    private func timeString(_ sec: Int) -> String { String(format: "%d:%02d", sec / 60, sec % 60) }
}

struct ShareSheet: View {
    @Environment(AppState.self) private var app
    @Environment(\.dismiss) private var dismiss
    let song: Song
    @State private var shared = false

    private let platforms: [(String, String, Color)] = [
        ("Stories", "camera.fill", VYBE.magenta),
        ("Reels", "video.fill", VYBE.purple),
        ("TikTok", "music.note", VYBE.cyan),
        ("Copy Link", "link", VYBE.blue),
        ("Message", "message.fill", VYBE.green),
        ("Invite Friend", "person.badge.plus", VYBE.gold),
    ]

    var body: some View {
        VStack(spacing: 18) {
            Capsule().fill(.white.opacity(0.2)).frame(width: 40, height: 5).padding(.top, 10)
            HoloArt(seed: song.title, corner: 16).frame(width: 64, height: 64)
                .overlay(alignment: .center) {
                    if shared { Image(systemName: "checkmark.circle.fill").font(.system(size: 28)).foregroundStyle(.white) }
                }
            VStack(spacing: 2) {
                Text(shared ? "Shared! +250 points" : "Share \(song.title)")
                    .font(.system(size: 18, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                Text(shared ? "Track your viral impact in Rewards" : "Earn points for every listen you drive")
                    .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(platforms, id: \.0) { p in
                    Button {
                        let g = UINotificationFeedbackGenerator(); g.notificationOccurred(.success)
                        if p.0 == "Invite Friend" { app.refer() } else { app.share(song.title) }
                        withAnimation(.snappy) { shared = true }
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: p.1).font(.system(size: 20, weight: .bold)).foregroundStyle(.white)
                                .frame(width: 56, height: 56).background(p.2.opacity(0.9), in: .circle)
                            Text(p.0).font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.text)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(VYBE.bgElevated)
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
}
