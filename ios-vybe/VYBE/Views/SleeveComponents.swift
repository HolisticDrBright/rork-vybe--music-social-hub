//
//  SleeveComponents.swift
//  VYBE
//
//  Reusable UI for the Sleeves + Videos experience: era badges, cover cards,
//  sleeve previews, music-video cards, the mock video player, and a shareable
//  lyric card. All lyrics rendered here are fictional/mock.
//

import SwiftUI

// MARK: - Era badge + background

struct EraBadge: View {
    let era: SleeveEra
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: era.icon).font(.system(size: 10, weight: .bold))
            Text(era.label).font(.system(size: 11, weight: .heavy, design: .rounded))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 10).padding(.vertical, 5)
        .background(LinearGradient(colors: era.accents, startPoint: .leading, endPoint: .trailing), in: .capsule)
        .overlay(Capsule().stroke(.white.opacity(0.25), lineWidth: 1))
    }
}

/// Era-tinted ambient background for the sleeve experience.
struct SleeveEraBackground: View {
    let era: SleeveEra
    var body: some View {
        ZStack {
            VYBE.bg.ignoresSafeArea()
            RadialGradient(colors: [era.accents[0].opacity(0.32), .clear], center: .topLeading, startRadius: 5, endRadius: 460).ignoresSafeArea()
            RadialGradient(colors: [era.accents[1].opacity(0.26), .clear], center: .bottomTrailing, startRadius: 5, endRadius: 480).ignoresSafeArea()
        }
    }
}

// MARK: - Cover card

struct SleeveCoverCard: View {
    let sleeve: SongSleeve
    var size: CGFloat = 260

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            HoloArt(seed: sleeve.coverArtSeed, corner: 18).frame(width: size, height: size)
            LinearGradient(colors: [.clear, .black.opacity(0.55)], startPoint: .center, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 4) {
                EraBadge(era: sleeve.era)
                Text(sleeve.title).font(.system(size: size > 200 ? 22 : 15, weight: .black, design: .rounded))
                    .foregroundStyle(.white).lineLimit(2)
                Text(sleeve.artistName).font(.system(size: size > 200 ? 14 : 11, weight: .semibold)).foregroundStyle(.white.opacity(0.85))
            }
            .padding(14)
        }
        .frame(width: size, height: size)
        .clipShape(.rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(LinearGradient(colors: sleeve.era.accents, startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5))
        .shadow(color: sleeve.era.accents[0].opacity(0.4), radius: 16, y: 8)
    }
}

// MARK: - Sleeve preview (song detail / discover)

struct SleevePreviewCard: View {
    let sleeve: SongSleeve
    var hasVideo: Bool = false

    var body: some View {
        NavigationLink(value: Route.sleeve(sleeve.id)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    HoloArt(seed: sleeve.coverArtSeed, corner: 14).frame(width: 72, height: 72)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(LinearGradient(colors: sleeve.era.accents, startPoint: .top, endPoint: .bottom), lineWidth: 1.5))
                    VStack(alignment: .leading, spacing: 5) {
                        EraBadge(era: sleeve.era)
                        Text(sleeve.tagline).font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
                        HStack(spacing: 6) {
                            Label("Lyrics", systemImage: "text.quote").font(.system(size: 10, weight: .bold)).foregroundStyle(VYBE.cyan)
                            Label("Liner notes", systemImage: "doc.plaintext").font(.system(size: 10, weight: .bold)).foregroundStyle(VYBE.gold)
                            if hasVideo { Label("Video", systemImage: "play.tv.fill").font(.system(size: 10, weight: .bold)).foregroundStyle(VYBE.magenta) }
                        }
                    }
                    Spacer()
                }
                // Lyric excerpt teaser
                Text("“\(sleeve.lyricExcerpt)”")
                    .font(.system(size: 13, weight: .medium, design: .serif)).italic()
                    .foregroundStyle(VYBE.text.opacity(0.9))
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(.white.opacity(0.04), in: .rect(cornerRadius: 12))
                HStack(spacing: 8) {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill").font(.system(size: 12)).foregroundStyle(.white)
                    Text("Open Sleeve").font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                    Spacer()
                    Image(systemName: "arrow.right").font(.system(size: 12, weight: .bold)).foregroundStyle(.white)
                }
                .padding(.vertical, 11).padding(.horizontal, 14)
                .background(LinearGradient(colors: sleeve.era.accents, startPoint: .leading, endPoint: .trailing), in: .capsule)
            }
            .padding(14)
            .background { ZStack { VYBE.card; HoloArt(seed: sleeve.coverArtSeed + "bg").opacity(0.1) }.clipShape(.rect(cornerRadius: 20)) }
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(sleeve.era.accents[0].opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

/// Compact sleeve card for horizontal rails (Discover / artist profile).
struct SleeveRailCard: View {
    let sleeve: SongSleeve
    var body: some View {
        NavigationLink(value: Route.sleeve(sleeve.id)) {
            VStack(alignment: .leading, spacing: 8) {
                SleeveCoverCard(sleeve: sleeve, size: 150)
                Text(sleeve.title).font(.system(size: 13, weight: .bold)).foregroundStyle(VYBE.text).lineLimit(1).frame(width: 150, alignment: .leading)
                Text("Open Sleeve · \(sleeve.era.label)").font(.system(size: 10, weight: .semibold)).foregroundStyle(sleeve.era.accents[0]).lineLimit(1)
            }
            .frame(width: 150)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Music video card

struct VideoCard: View {
    let video: MusicVideo
    var width: CGFloat = 260
    var onPlay: () -> Void

    var body: some View {
        Button(action: onPlay) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    HoloArt(seed: video.previewSeed, corner: 16).frame(width: width, height: width * 0.56)
                    LinearGradient(colors: [.clear, .black.opacity(0.5)], startPoint: .center, endPoint: .bottom)
                        .frame(width: width, height: width * 0.56).clipShape(.rect(cornerRadius: 16))
                    Image(systemName: "play.circle.fill").font(.system(size: 42)).foregroundStyle(.white).shadow(radius: 6)
                }
                .overlay(alignment: .topLeading) {
                    HStack(spacing: 5) {
                        Image(systemName: video.status.icon).font(.system(size: 9, weight: .bold))
                        Text(video.status.label).font(.system(size: 10, weight: .heavy, design: .rounded))
                    }
                    .foregroundStyle(.white).padding(.horizontal, 8).padding(.vertical, 4)
                    .background(video.status.color.opacity(0.9), in: .capsule).padding(8)
                }
                .overlay(alignment: .bottomTrailing) {
                    Text(timeString(video.durationSec)).font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white).padding(.horizontal, 6).padding(.vertical, 3)
                        .background(.black.opacity(0.6), in: .capsule).padding(8)
                }
                Text(video.title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(1).frame(width: width, alignment: .leading)
                Text("\(video.artistName) · \(video.scene)").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1).frame(width: width, alignment: .leading)
            }
            .frame(width: width)
        }
        .buttonStyle(.plain)
    }
}

private func timeString(_ sec: Int) -> String { String(format: "%d:%02d", sec / 60, sec % 60) }

// MARK: - Mock video player

struct VideoPlayerSheet: View {
    @Environment(AppState.self) private var app
    @Environment(\.dismiss) private var dismiss
    let video: MusicVideo
    @State private var playing = true
    @State private var progress: Double = 0.0
    @State private var reacted = false

    var body: some View {
        ZStack {
            HoloArt(seed: video.previewSeed).ignoresSafeArea().opacity(0.55).blur(radius: 30)
            VYBE.bg.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 16) {
                HStack {
                    Button { dismiss() } label: { Image(systemName: "chevron.down").font(.system(size: 18, weight: .bold)).foregroundStyle(VYBE.text) }
                    Spacer()
                    HStack(spacing: 5) {
                        Image(systemName: video.status.icon).font(.system(size: 10, weight: .bold))
                        Text(video.status.label).font(.system(size: 11, weight: .heavy, design: .rounded))
                    }
                    .foregroundStyle(.white).padding(.horizontal, 10).padding(.vertical, 5)
                    .background(video.status.color.opacity(0.9), in: .capsule)
                }
                .padding(.horizontal, 20).padding(.top, 14)

                Spacer()
                // "Screen"
                ZStack {
                    HoloArt(seed: video.previewSeed, corner: 18).aspectRatio(16.0/9.0, contentMode: .fit)
                    Button { withAnimation(.snappy) { playing.toggle() } } label: {
                        Image(systemName: playing ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 54)).foregroundStyle(.white.opacity(0.92)).shadow(radius: 8)
                    }
                    .buttonStyle(.plain)
                    Text("MOCK PLAYBACK").font(.system(size: 9, weight: .heavy, design: .rounded)).tracking(2)
                        .foregroundStyle(.white.opacity(0.7)).padding(6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing).padding(10)
                }
                .padding(.horizontal, 16)
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.15), lineWidth: 1).padding(.horizontal, 16))

                // Scrubber
                VStack(spacing: 6) {
                    NeonProgressBar(progress: progress, height: 5)
                    HStack {
                        Text(timeString(Int(progress * Double(video.durationSec))))
                        Spacer()
                        Text(timeString(video.durationSec))
                    }
                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
                }
                .padding(.horizontal, 24)

                VStack(spacing: 4) {
                    Text(video.title).font(.system(size: 20, weight: .black, design: .rounded)).foregroundStyle(VYBE.text).multilineTextAlignment(.center)
                    Text("\(video.artistName) · \(video.scene)").font(.system(size: 13, weight: .semibold)).foregroundStyle(VYBE.magenta)
                }
                .padding(.horizontal, 20)

                // Behind the video
                VStack(alignment: .leading, spacing: 6) {
                    Label("Behind the video", systemImage: "film.fill").font(.system(size: 12, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.cyan)
                    Text(video.behindTheVideo).font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14).vybeCard(corner: 16).padding(.horizontal, 20)

                HStack(spacing: 12) {
                    Button { withAnimation(.snappy) { reacted.toggle() } } label: {
                        Label("\(video.reactions + (reacted ? 1 : 0))", systemImage: reacted ? "heart.fill" : "heart")
                            .font(.system(size: 13, weight: .bold)).foregroundStyle(VYBE.magenta)
                            .padding(.horizontal, 14).padding(.vertical, 9)
                            .background(VYBE.magenta.opacity(0.12), in: .capsule)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Text("+25 for watching").font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.gold)
                }
                .padding(.horizontal, 20).padding(.bottom, 24)
            }
        }
        .onAppear {
            app.watchVideo(video)
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) { progress = 1.0 }
        }
    }
}

// MARK: - Shareable lyric card

struct LyricShareSheet: View {
    @Environment(AppState.self) private var app
    @Environment(\.dismiss) private var dismiss
    let sleeve: SongSleeve
    let lines: [String]
    @State private var shared = false

    var body: some View {
        VStack(spacing: 18) {
            Capsule().fill(.white.opacity(0.2)).frame(width: 40, height: 5).padding(.top, 10)
            Text(shared ? "Lyric card shared! +250" : "Share a lyric card")
                .font(.system(size: 18, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)

            // The visual quote card
            VStack(alignment: .leading, spacing: 14) {
                EraBadge(era: sleeve.era)
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                        Text(line).font(.system(size: 18, weight: .bold, design: .serif)).italic().foregroundStyle(.white)
                    }
                }
                HStack(spacing: 8) {
                    AvatarView(seed: sleeve.artistName, size: 28)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(sleeve.title).font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                        Text(sleeve.artistName).font(.system(size: 11, weight: .medium)).foregroundStyle(.white.opacity(0.8))
                    }
                    Spacer()
                    HoloText(text: "VYBE", font: .system(size: 16, weight: .black, design: .rounded))
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                ZStack {
                    LinearGradient(colors: sleeve.era.accents.map { $0.opacity(0.45) }, startPoint: .topLeading, endPoint: .bottomTrailing)
                    HoloArt(seed: sleeve.coverArtSeed).opacity(0.35)
                }
            }
            .clipShape(.rect(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(.white.opacity(0.2), lineWidth: 1))
            .padding(.horizontal, 20)
            .shadow(color: sleeve.era.accents[0].opacity(0.5), radius: 24, y: 10)

            Text("Mock lyrics — fictional, written for this VYBE artist.")
                .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textTertiary)

            PrimaryButton(title: shared ? "Shared ✓" : "Share to Stories / TikTok", icon: "square.and.arrow.up.fill") {
                app.share(sleeve.title)
                withAnimation(.snappy) { shared = true }
            }
            .padding(.horizontal, 24)
            Spacer(minLength: 10)
        }
        .frame(maxWidth: .infinity)
        .background(VYBE.bgElevated)
        .presentationDetents([.large])
    }
}
