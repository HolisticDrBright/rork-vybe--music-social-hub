//
//  HomeView.swift
//  VYBE
//

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var app
    @State private var mood = "For You"
    private let moods = ["For You", "Euphoric", "Dreamy", "Aggressive", "Groovy", "Intimate", "Chaotic"]

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    greeting
                    scoreCard
                    vibeCheckEntry
                    ChipRow(items: moods, selection: $mood)
                        .padding(.horizontal, -20)

                    // Trending strip
                    SectionHeader(title: "🔥 Trending Now")
                    trendingStrip

                    // Sleeves + VYBE TV
                    sleeveTVEntry

                    // Collab drops born on VYBE
                    if !app.upcomingDrops.isEmpty {
                        SectionHeader(title: "✨ Born on VYBE")
                        bornOnVYBEStrip
                    }

                    // Dynamic feed
                    SectionHeader(title: "Your Feed")
                    VStack(spacing: 14) {
                        ForEach(Mock.feed) { item in
                            FeedCard(item: item)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HoloText(text: "VYBE", font: .system(size: 26, weight: .black, design: .rounded))
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "bell.badge.fill")
                    .foregroundStyle(VYBE.text)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(VYBE.text, VYBE.magenta)
            }
        }
        .vybeDestinations()
    }

    private var greeting: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Good evening, tastemaker")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(VYBE.textSecondary)
            Text("Los Angeles · 8 shows near you")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(VYBE.textTertiary)
        }
    }

    private var vibeCheckEntry: some View {
        NavigationLink(value: Route.vibeCheck) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(VYBE.holo.opacity(0.2))
                        .frame(width: 48, height: 48)
                    Text("🎧")
                        .font(.system(size: 22))
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("VIBE CHECK")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .tracking(1)
                        .foregroundStyle(VYBE.cyan)
                    Text("How are you feeling?")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(VYBE.text)
                    Text("Find music that matches your mood or take a journey")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(VYBE.textSecondary)
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(VYBE.textTertiary)
            }
            .padding(14)
            .background(VYBE.card, in: .rect(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.cyan.opacity(0.2), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private var scoreCard: some View {
        NavigationLink(value: Route.viralStats) {
            HStack(spacing: 16) {
                ZStack {
                    Circle().fill(VYBE.holo).frame(width: 56, height: 56).neonGlow(VYBE.purple, radius: 14)
                    Image(systemName: "bolt.fill").font(.system(size: 22, weight: .black)).foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("VYBE SCORE")
                        .font(.system(size: 11, weight: .heavy, design: .rounded)).tracking(1)
                        .foregroundStyle(VYBE.textSecondary)
                    Text(app.vybeScore.grouped)
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundStyle(VYBE.text)
                        .contentTransition(.numericText())
                    Text("Rank #\(app.fanRank) · Artist Ambassador")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(VYBE.gold)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
            }
            .padding(16)
            .background {
                ZStack {
                    VYBE.card
                    HoloArt(seed: "scorecard").opacity(0.16)
                }
                .clipShape(.rect(cornerRadius: 22))
            }
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(VYBE.stroke, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private var trendingStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(Mock.songs.filter { $0.isViral }) { song in
                    NavigationLink(value: Route.song(song.id)) {
                        TrendingSongCard(song: song)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }

    private var sleeveTVEntry: some View {
        VStack(alignment: .leading, spacing: 12) {
            // VYBE TV banner
            NavigationLink(value: Route.vybeTV) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14).fill(VYBE.holo).frame(width: 52, height: 52)
                        Image(systemName: "tv.fill").font(.system(size: 22)).foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Text("VYBE TV").font(.system(size: 15, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                            NeonTag(text: "VIDEO LOUNGE", color: VYBE.magenta, icon: "play.tv.fill")
                        }
                        Text("Premieres, underground videos & behind-the-video stories")
                            .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
                }
                .padding(14)
                .background { ZStack { VYBE.card; HoloArt(seed: "vybetvbanner").opacity(0.14) }.clipShape(.rect(cornerRadius: 18)) }
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.magenta.opacity(0.25), lineWidth: 1))
            }
            .buttonStyle(.plain)

            // New Sleeve Drops rail
            HStack(alignment: .firstTextBaseline) {
                Text("🎁 New Sleeve Drops").font(.system(size: 19, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Spacer()
                Text("Open them like vinyl").font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(app.allSleeves) { SleeveRailCard(sleeve: $0) }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
    }

    private var bornOnVYBEStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(app.upcomingDrops) { drop in
                    NavigationLink(value: Route.upcomingDrop(drop.id)) {
                        BornOnVYBECard(drop: drop)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
}

struct BornOnVYBECard: View {
    let drop: UpcomingDrop
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HoloArt(seed: drop.previewSeed, corner: 18)
                .frame(width: 200, height: 130)
                .overlay(alignment: .topLeading) {
                    NeonTag(text: "Born on VYBE", color: VYBE.cyan, icon: "sparkles").padding(8)
                }
                .overlay(alignment: .bottomLeading) {
                    Text("Started as an Open Beat Challenge")
                        .font(.system(size: 10, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(.black.opacity(0.5), in: .capsule).padding(8)
                }
            Text(drop.title)
                .font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(2)
                .frame(width: 200, alignment: .leading)
            Text(drop.artistNames.joined(separator: " × "))
                .font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.magenta).lineLimit(1)
        }
        .frame(width: 200)
    }
}

struct TrendingSongCard: View {
    let song: Song
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HoloArt(seed: song.title, corner: 18)
                .frame(width: 150, height: 150)
                .overlay(alignment: .topLeading) {
                    NeonTag(text: "VIRAL", color: VYBE.magenta, icon: "flame.fill").padding(8)
                }
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                        .padding(8)
                        .shadow(radius: 6)
                }
            Text(song.title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(VYBE.text).lineLimit(1)
            Text("\(song.artistName) · \(song.plays.compact)")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(VYBE.textSecondary).lineLimit(1)
        }
        .frame(width: 150)
    }
}

struct FeedCard: View {
    @Environment(AppState.self) private var app
    let item: FeedItem

    private var accent: Color {
        switch item.kind {
        case .aiMessage: return VYBE.cyan
        case .challenge: return VYBE.gold
        case .friends: return VYBE.green
        case .concert: return VYBE.blue
        case .trendingSong: return VYBE.magenta
        default: return VYBE.purple
        }
    }

    private var route: Route {
        switch item.kind {
        case .trendingSong, .artistDrop, .recommendation:
            return .song(songId)
        case .aiMessage: return .aiChat("a1")
        case .challenge: return .artist("a1")
        case .concert: return .event(eventId)
        case .friends: return .event("e1")
        case .communityUpdate: return .communityBoard("cm3")
        }
    }

    private var songId: String {
        Mock.songs.first { $0.title == item.seed }?.id ?? "s1"
    }
    private var eventId: String {
        Mock.events.first { $0.title == item.seed }?.id ?? "e1"
    }

    private var kindLabel: String {
        switch item.kind {
        case .trendingSong: return "TRENDING"
        case .artistDrop: return "NEW DROP"
        case .challenge: return "CHALLENGE"
        case .concert: return "CONCERT NEARBY"
        case .friends: return "FRIENDS GOING"
        case .communityUpdate: return "COMMUNITY"
        case .aiMessage: return "AI ARTIST"
        case .recommendation: return "FOR YOU"
        }
    }

    private var kindIcon: String {
        switch item.kind {
        case .trendingSong: return "flame.fill"
        case .artistDrop: return "sparkles"
        case .challenge: return "bolt.fill"
        case .concert: return "ticket.fill"
        case .friends: return "person.2.fill"
        case .communityUpdate: return "bubble.left.and.bubble.right.fill"
        case .aiMessage: return "cpu.fill"
        case .recommendation: return "wand.and.stars"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink(value: route) {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .bottomLeading) {
                        HoloArt(seed: item.seed)
                            .frame(height: 150)
                        LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .center, endPoint: .bottom)
                            .frame(height: 150)
                        NeonTag(text: kindLabel, color: accent, icon: kindIcon)
                            .padding(12)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.title)
                            .font(.system(size: 17, weight: .heavy, design: .rounded))
                            .foregroundStyle(VYBE.text)
                        Text(item.subtitle)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(VYBE.textSecondary)
                            .lineLimit(2)
                        HStack(spacing: 5) {
                            Image(systemName: "circle.fill").font(.system(size: 4)).foregroundStyle(accent)
                            Text(item.meta)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(accent)
                        }
                        .padding(.top, 2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                }
            }
            .buttonStyle(.plain)

            // One-tap support actions
            supportBar
        }
        .background(VYBE.card)
        .clipShape(.rect(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(VYBE.stroke, lineWidth: 1))
    }

    private var supportBar: some View {
        HStack(spacing: 0) {
            feedActionBtn("play.fill", "Preview +20", VYBE.green) {
                app.addScore(20, reason: "Previewed \(item.title)")
                app.haptic(.light)
            }
            feedActionBtn("square.and.arrow.up.fill", "Share +250", VYBE.magenta) {
                app.share(item.title)
                app.hapticSuccess()
            }
            feedActionBtn("heart.fill", "Tip +100", VYBE.gold) {
                app.addScore(100, reason: "Tipped for \(item.title)")
                app.tipArtist("a1", amount: 5)
                app.hapticSuccess()
            }
            feedActionBtn("arrow.triangle.capsulepath", "Support", VYBE.cyan) {
                app.addScore(50, reason: "Supported \(item.title)")
                app.haptic(.medium)
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 10)
    }

    private func feedActionBtn(_ icon: String, _ label: String, _ color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 16)).foregroundStyle(color)
                Text(label).font(.system(size: 9, weight: .semibold, design: .rounded)).foregroundStyle(color.opacity(0.9))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}
