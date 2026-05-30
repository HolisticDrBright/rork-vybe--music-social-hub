//
//  SleeveDetailView.swift
//  VYBE
//
//  The full interactive sleeve — flip through cover art, inside art, mock lyrics,
//  liner notes, credits, thank-yous, the behind-the-song story, the music video,
//  fan reactions, and support. Paged like a record sleeve / CD booklet.
//

import SwiftUI

/// The one sheet a sleeve screen can present (avoids stacked-sheet conflicts).
enum SleeveSheet: Identifiable {
    case video(MusicVideo)
    case lyricShare
    case receipt(SupportReceipt)
    var id: String {
        switch self {
        case .video(let v): return "video-\(v.id)"
        case .lyricShare: return "lyricShare"
        case .receipt(let r): return "receipt-\(r.id)"
        }
    }
}

struct SleeveDetailView: View {
    @Environment(AppState.self) private var app
    let sleeveId: String

    @State private var page = 0
    @State private var activeSheet: SleeveSheet? = nil

    private var sleeve: SongSleeve? { app.sleeve(sleeveId) }

    var body: some View {
        ZStack {
            if let sleeve {
                SleeveEraBackground(era: sleeve.era)
                TabView(selection: $page) {
                    coverPage(sleeve).tag(0)
                    insideArtPage(sleeve).tag(1)
                    lyricsPage(sleeve).tag(2)
                    linerNotesPage(sleeve).tag(3)
                    creditsPage(sleeve).tag(4)
                    behindPage(sleeve).tag(5)
                    if sleeve.videoId != nil { videoPage(sleeve).tag(6) }
                    fanReactionsPage(sleeve).tag(7)
                    supportPage(sleeve).tag(8)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            } else {
                VYBEBackground()
                Text("This sleeve is no longer available.").font(.system(size: 15, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
        }
        .navigationTitle("Sleeve")
        .navigationBarTitleDisplayMode(.inline)
        // Single enum-driven sheet (avoids stacked-sheet presentation conflicts).
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .video(let v):
                VideoPlayerSheet(video: v).environment(app)
            case .lyricShare:
                if let s = sleeve { LyricShareSheet(sleeve: s, lines: shareLines(s)).environment(app) }
            case .receipt(let r):
                NavigationStack {
                    SupportReceiptView(receipt: r)
                        .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Done") { activeSheet = nil }.foregroundStyle(VYBE.text) } }
                }
                .environment(app)
            }
        }
        .vybeDestinations()
        .onAppear { app.openSleeve(sleeveId) }
    }

    private func shareLines(_ s: SongSleeve) -> [String] {
        (s.mockLyrics.first { $0.label.lowercased().contains("chorus") } ?? s.mockLyrics.first)?.lines ?? [s.lyricExcerpt]
    }

    // MARK: - Page scaffold

    private func pageScaffold<Content: View>(_ s: SongSleeve, title: String, icon: String, @ViewBuilder _ content: () -> Content) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: icon).font(.system(size: 13, weight: .bold)).foregroundStyle(s.era.accents[0])
                    Text(title.uppercased()).font(.system(size: 12, weight: .heavy, design: .rounded)).tracking(1.5).foregroundStyle(s.era.accents[0])
                    Spacer()
                    EraBadge(era: s.era)
                }
                content()
            }
            .padding(20).padding(.bottom, 60)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Pages

    private func coverPage(_ s: SongSleeve) -> some View {
        VStack(spacing: 18) {
            Spacer()
            SleeveCoverCard(sleeve: s, size: 290)
            VStack(spacing: 4) {
                Text(s.tagline).font(.system(size: 13, weight: .semibold, design: .rounded)).foregroundStyle(VYBE.textSecondary)
                Text("Swipe to open the booklet →").font(.system(size: 12, weight: .bold)).foregroundStyle(s.era.accents[0])
            }
            Button {
                app.reactToSleeveArt(s.id)
            } label: {
                Label(app.reactedSleeves.contains(s.id) ? "Loved the art" : "React to the art",
                      systemImage: app.reactedSleeves.contains(s.id) ? "heart.fill" : "heart")
                    .font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                    .padding(.horizontal, 16).padding(.vertical, 10)
                    .background(LinearGradient(colors: s.era.accents, startPoint: .leading, endPoint: .trailing), in: .capsule)
            }
            .buttonStyle(.plain)
            Spacer(); Spacer()
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
    }

    private func insideArtPage(_ s: SongSleeve) -> some View {
        pageScaffold(s, title: "Inside Art", icon: "photo.artframe") {
            VStack(alignment: .leading, spacing: 14) {
                ForEach(s.insidePanels) { panel in
                    VStack(alignment: .leading, spacing: 8) {
                        HoloArt(seed: panel.artSeed, corner: 14).frame(height: 150)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(s.era.accents[0].opacity(0.4), lineWidth: 1))
                        Text(panel.title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                        Text(panel.caption).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    }
                }
                // Hidden visual details
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hidden details").font(.system(size: 12, weight: .heavy, design: .rounded)).foregroundStyle(s.era.accents[0])
                    HStack(spacing: 14) {
                        ForEach(s.visualSymbols, id: \.self) { sym in
                            Image(systemName: sym).font(.system(size: 20)).foregroundStyle(VYBE.text.opacity(0.85))
                                .frame(width: 48, height: 48).background(.white.opacity(0.05), in: .rect(cornerRadius: 12))
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
    }

    private func lyricsPage(_ s: SongSleeve) -> some View {
        pageScaffold(s, title: "Lyrics", icon: "text.quote") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Fictional lyrics, written for this VYBE artist.")
                    .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textTertiary)
                ForEach(s.mockLyrics) { block in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(block.label.uppercased()).font(.system(size: 11, weight: .heavy, design: .rounded)).tracking(1).foregroundStyle(s.era.accents[1])
                        ForEach(Array(block.lines.enumerated()), id: \.offset) { _, line in
                            Text(line).font(.system(size: 16, weight: .medium, design: .serif)).foregroundStyle(VYBE.text).lineSpacing(2)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(.white.opacity(0.04), in: .rect(cornerRadius: 14))
                }
                Button { activeSheet = .lyricShare } label: {
                    Label("Share a lyric card", systemImage: "square.and.arrow.up.fill")
                        .font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 13)
                        .background(LinearGradient(colors: s.era.accents, startPoint: .leading, endPoint: .trailing), in: .capsule)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func linerNotesPage(_ s: SongSleeve) -> some View {
        pageScaffold(s, title: "Liner Notes", icon: "doc.plaintext") {
            VStack(alignment: .leading, spacing: 14) {
                Text(s.linerNotes)
                    .font(.system(size: 16, weight: .regular, design: .serif)).foregroundStyle(VYBE.text).lineSpacing(6)
                Divider().overlay(VYBE.stroke)
                Label("Thank yous", systemImage: "hands.sparkles.fill").font(.system(size: 12, weight: .heavy, design: .rounded)).foregroundStyle(s.era.accents[0])
                Text(s.thankYous)
                    .font(.system(size: 14, weight: .medium, design: .serif)).italic().foregroundStyle(VYBE.textSecondary).lineSpacing(4)
            }
            .padding(16)
            .background { ZStack { Color.white.opacity(0.03); HoloArt(seed: s.coverArtSeed + "paper").opacity(0.06) }.clipShape(.rect(cornerRadius: 16)) }
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(s.era.accents[0].opacity(0.2), lineWidth: 1))
        }
    }

    private func creditsPage(_ s: SongSleeve) -> some View {
        pageScaffold(s, title: "Credits", icon: "list.bullet.rectangle.portrait") {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(s.credits.enumerated()), id: \.element.id) { idx, c in
                    HStack(alignment: .top, spacing: 10) {
                        Text(c.role).font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.textSecondary).frame(width: 130, alignment: .leading)
                        Text(c.name).font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                        Spacer()
                    }
                    .padding(.vertical, 11)
                    if idx < s.credits.count - 1 { Divider().overlay(VYBE.stroke) }
                }
            }
            .padding(14).vybeCard(corner: 16)
        }
    }

    private func behindPage(_ s: SongSleeve) -> some View {
        pageScaffold(s, title: "Behind the Song", icon: "book.closed.fill") {
            VStack(alignment: .leading, spacing: 10) {
                Text(s.behindTheSong.heading).font(.system(size: 18, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                Text(s.behindTheSong.body).font(.system(size: 15, weight: .regular, design: .serif)).foregroundStyle(VYBE.textSecondary).lineSpacing(6)
            }
            .padding(16)
            .background { ZStack { VYBE.card; HoloArt(seed: s.coverArtSeed + "story").opacity(0.08) }.clipShape(.rect(cornerRadius: 18)) }
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(s.era.accents[0].opacity(0.25), lineWidth: 1))
        }
    }

    private func videoPage(_ s: SongSleeve) -> some View {
        pageScaffold(s, title: "Music Video", icon: "play.tv.fill") {
            VStack(alignment: .leading, spacing: 14) {
                if let v = s.videoId.flatMap({ Mock.video($0) }) {
                    VideoCard(video: v, width: UIScreen.main.bounds.width - 40) { activeSheet = .video(v) }
                    NavigationLink(value: Route.vybeTV) {
                        Label("More on VYBE TV", systemImage: "tv.fill")
                            .font(.system(size: 13, weight: .bold)).foregroundStyle(s.era.accents[0])
                    }
                } else {
                    Text("No video yet for this drop.").font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                }
            }
        }
    }

    private func fanReactionsPage(_ s: SongSleeve) -> some View {
        pageScaffold(s, title: "Fan Reactions", icon: "bubble.left.and.bubble.right.fill") {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(s.fanReactions.enumerated()), id: \.offset) { idx, r in
                    HStack(alignment: .top, spacing: 10) {
                        AvatarView(seed: "fan\(idx)\(s.id)", size: 34)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("@" + ["glowqueen", "static_kid", "dreampop_dani", "neon_nadia", "sol_seeker"][idx % 5])
                                .font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.text)
                            Text(r).font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(12).vybeCard(corner: 14)
                }
                NavigationLink(value: Route.report(s.id)) {
                    Text("Report this content").font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.textTertiary)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private func supportPage(_ s: SongSleeve) -> some View {
        let artist = Mock.artist(s.artistId)
        return pageScaffold(s, title: "Support This Drop", icon: "bolt.heart.fill") {
            VStack(alignment: .leading, spacing: 14) {
                Text("You opened the sleeve. Now make it count.")
                    .font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Text("Supporting a drop from its sleeve drives real earnings to the artist and unlocks Sleeve Collector progress.")
                    .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(3)

                Button { activeSheet = .receipt(app.supportDrop(artist: artist, title: s.title)) } label: {
                    Label("Support this drop · $8", systemImage: "bolt.fill")
                        .font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 15)
                        .background(VYBE.holo, in: .capsule).neonGlow(VYBE.magenta, radius: 12)
                }
                .buttonStyle(.plain)

                // Supporter-only bonus placeholder
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "lock.fill").foregroundStyle(VYBE.gold)
                        Text("Supporter bonus").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    }
                    Text(s.supporterBonus).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.gold).lineSpacing(2)
                }
                .padding(14)
                .background(VYBE.gold.opacity(0.07), in: .rect(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(VYBE.gold.opacity(0.25), lineWidth: 1))

                NavigationLink(value: Route.artist(s.artistId)) {
                    HStack(spacing: 10) {
                        AvatarView(seed: artist.name, size: 36)
                        Text("Visit \(artist.name)").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
                    }
                    .padding(12).vybeCard(corner: 14)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
