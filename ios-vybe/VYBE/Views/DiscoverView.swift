//
//  DiscoverView.swift
//  VYBE
//

import SwiftUI

struct DiscoverView: View {
    @Environment(AppState.self) private var app
    @State private var query = ""
    @State private var lens = "All"
    @State private var showingWhy = false
    @State private var whyText = ""
    @State private var celebration: SupportReceipt? = nil
    private let lenses = ["All", "Artists", "Songs", "Events", "Communities"]

    /// Top "Hidden Gems" matched to the fan's favorites (#17) for the preview row.
    private var hiddenGemsPreview: [DiscoveryResult] {
        let favs = Discovery.defaultFavorites(followed: app.followedArtists, taste: app.taste)
        return Array(Discovery.hiddenGems(
            favorites: favs,
            excluding: app.followedArtists.union(app.discoveredArtists),
            limit: 4))
    }

    /// One recognizable anchor per genre for the "Sounds Like…" quick selector.
    private var soundsLikeAnchors: [AnchorArtist] {
        var seen = Set<String>()
        var out: [AnchorArtist] = []
        for a in Mock.anchors where !seen.contains(a.genre) {
            seen.insert(a.genre); out.append(a)
            if out.count == 8 { break }
        }
        return out
    }

    private var filteredArtists: [Artist] {
        guard !query.isEmpty else { return Mock.artists }
        return Mock.artists.filter {
            $0.name.localizedCaseInsensitiveContains(query) || $0.genre.localizedCaseInsensitiveContains(query)
        }
    }
    private var filteredSongs: [Song] {
        guard !query.isEmpty else { return Mock.songs }
        return Mock.songs.filter {
            $0.title.localizedCaseInsensitiveContains(query) || $0.artistName.localizedCaseInsensitiveContains(query) || $0.genre.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    searchBar
                    ChipRow(items: lenses, selection: $lens)
                        .padding(.horizontal, -20)

                    if query.isEmpty {
                        vibeCheckBanner
                        sceneSpotlightsSection
                        moodGrid
                        risingSection
                        sleevesSection
                        soundsLikeSection
                        hiddenGemsSection
                        nearYouSection
                        viralSection
                    } else {
                        searchResults
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Discover")
        .navigationBarTitleDisplayMode(.large)
        .vybeDestinations()
        .sheet(item: $celebration) { receipt in
            NavigationStack {
                SupportReceiptView(receipt: receipt)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Done") { celebration = nil }.foregroundStyle(VYBE.text)
                        }
                    }
            }
            .environment(app)
        }
    }

    // MARK: - Sounds Like… anchor selector

    private var soundsLikeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "🎯 Sounds Like…")
            Text("Pick a name you love — we'll find the unknowns who sound like them.")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(soundsLikeAnchors) { anchor in
                        NavigationLink(value: Route.soundsLike(anchor.name)) {
                            VStack(spacing: 6) {
                                AvatarView(seed: anchor.name, size: 56)
                                Text(anchor.name)
                                    .font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.text)
                                    .lineLimit(1).frame(width: 72)
                                Text(anchor.genre)
                                    .font(.system(size: 9, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
                                    .lineLimit(1).frame(width: 72)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
    }

    // MARK: - Hidden Gems (#17)

    private var hiddenGemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("💎 Hidden Gems For You")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundStyle(VYBE.text)
                Spacer()
                NavigationLink(value: Route.hiddenGems) {
                    HStack(spacing: 3) {
                        Text("See all").font(.system(size: 13, weight: .bold))
                        Image(systemName: "arrow.right").font(.system(size: 11, weight: .bold))
                    }
                    .foregroundStyle(VYBE.cyan)
                }
                .buttonStyle(.plain)
            }
            Text("Lesser-known artists who sound like your favorites — support one early for the Early Discoverer bonus.")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
            ForEach(hiddenGemsPreview) { result in
                DiscoveryGemCard(result: result) {
                    celebration = app.supportDiscovery(result.artist)
                }
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundStyle(VYBE.textSecondary)
            TextField("", text: $query, prompt: Text("Artists, songs, genres, events...").foregroundColor(VYBE.textTertiary))
                .foregroundStyle(VYBE.text)
                .autocorrectionDisabled()
            if !query.isEmpty {
                Button { query = "" } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(VYBE.textTertiary)
                }
            }
        }
        .padding(14)
        .background(VYBE.card, in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(VYBE.stroke, lineWidth: 1))
    }

    private var vibeCheckBanner: some View {
        NavigationLink(value: Route.vibeCheck) {
            HStack(spacing: 12) {
                ZStack {
                    HoloArt(seed: "vibecheck", corner: 14)
                        .frame(width: 56, height: 56)
                    VStack(spacing: 1) {
                        Text("🎧").font(.system(size: 20))
                        Text("?").font(.system(size: 11, weight: .heavy)).foregroundStyle(.white.opacity(0.8))
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        NeonTag(text: "NEW", color: VYBE.cyan, icon: "sparkles")
                        Text("VIBE CHECK")
                            .font(.system(size: 11, weight: .heavy, design: .rounded))
                            .tracking(1)
                            .foregroundStyle(VYBE.cyan)
                    }
                    Text("How are you feeling?")
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundStyle(VYBE.text)
                    Text("Match music to your mood or take a journey")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(VYBE.textSecondary)
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(VYBE.cyan)
            }
            .padding(14)
            .background(VYBE.card, in: .rect(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.cyan.opacity(0.25), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private var moodGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Browse by Mood")
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                ForEach(Mock.moods, id: \.self) { mood in
                    MoodTile(mood: mood)
                }
            }
        }
    }

    private var sleevesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("💿 Sleeves Worth Opening").font(.system(size: 20, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Spacer()
                NavigationLink(value: Route.vybeTV) {
                    HStack(spacing: 3) {
                        Text("VYBE TV").font(.system(size: 13, weight: .bold))
                        Image(systemName: "play.tv.fill").font(.system(size: 11, weight: .bold))
                    }
                    .foregroundStyle(VYBE.magenta)
                }
                .buttonStyle(.plain)
            }
            Text("Album-worlds: cover art, mock lyrics, liner notes & videos.")
                .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(app.allSleeves) { SleeveRailCard(sleeve: $0) }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
    }

    private var risingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "⚡️ Underground Rising")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(Mock.artists.filter { $0.isUndergroundRising }) { artist in
                        NavigationLink(value: Route.artist(artist.id)) {
                            RisingArtistCard(artist: artist)
                        }.buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
    }

    private var sceneSpotlightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "📝 Scene Spotlights")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(Mock.sceneSpotlights, id: \.title) { spot in
                        SceneSpotlightCard(spot: spot)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
    }

    private var nearYouSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "📍 Artists Near You")
            VStack(spacing: 10) {
                ForEach(Mock.artists.filter { $0.city == "Los Angeles" || $0.city == "Brooklyn" }.prefix(3)) { artist in
                    NavigationLink(value: Route.artist(artist.id)) {
                        ArtistRow(artist: artist, showEarnings: true)
                    }.buttonStyle(.plain)
                }
            }
        }
    }

    private var viralSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "📈 Songs Going Viral")
            VStack(spacing: 10) {
                ForEach(Mock.songs.filter { $0.isViral }) { song in
                    NavigationLink(value: Route.song(song.id)) {
                        SongRow(song: song)
                    }.buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder private var searchResults: some View {
        if (lens == "All" || lens == "Artists"), !filteredArtists.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                SectionHeader(title: "Artists")
                ForEach(filteredArtists) { artist in
                    NavigationLink(value: Route.artist(artist.id)) { ArtistRow(artist: artist, showEarnings: true) }.buttonStyle(.plain)
                }
            }
        }
        if (lens == "All" || lens == "Songs"), !filteredSongs.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                SectionHeader(title: "Songs")
                ForEach(filteredSongs) { song in
                    NavigationLink(value: Route.song(song.id)) { SongRow(song: song) }.buttonStyle(.plain)
                }
            }
        }
        if filteredArtists.isEmpty && filteredSongs.isEmpty {
            Text("No results for \"\(query)\"")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 40)
        }
    }
}

struct MoodTile: View {
    let mood: String
    var body: some View {
        NavigationLink(value: Route.song(Mock.songs.first { $0.mood == mood }?.id ?? "s1")) {
            ZStack(alignment: .bottomLeading) {
                HoloArt(seed: mood + "mood", corner: 18).frame(height: 90)
                LinearGradient(colors: [.clear, .black.opacity(0.6)], startPoint: .center, endPoint: .bottom)
                Text(mood)
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(12)
            }
            .frame(height: 90)
            .clipShape(.rect(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}

struct RisingArtistCard: View {
    let artist: Artist
    var body: some View {
        VStack(spacing: 0) {
            HoloArt(seed: artist.name, corner: 0)
                .frame(width: 160, height: 120)
                .overlay(alignment: .topTrailing) {
                    NeonTag(text: "RISING", color: VYBE.green, icon: "arrow.up.right").padding(8)
                }
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 4) {
                    Text(artist.name).font(.system(size: 14, weight: .heavy, design: .rounded)).lineLimit(1)
                    if artist.isVerified { VerifiedBadge(size: 11) }
                }
                .foregroundStyle(VYBE.text)
                Text("\(artist.genre) · \(artist.monthlyListeners.compact) listeners")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(VYBE.textSecondary).lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
        }
        .frame(width: 160)
        .background(VYBE.card)
        .clipShape(.rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.stroke, lineWidth: 1))
    }
}

struct ArtistRow: View {
    let artist: Artist
    var showEarnings: Bool = false

    private var earnings: ArtistEarnings? {
        showEarnings ? Mock.earnings(for: artist.id) : nil
    }

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(seed: artist.name, size: 52)
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 4) {
                    Text(artist.name).font(.system(size: 15, weight: .bold)).foregroundStyle(VYBE.text)
                    if artist.isVerified { VerifiedBadge(size: 12) }
                    if artist.aiEnabled {
                        NeonTag(text: "AI", color: VYBE.cyan, icon: "cpu.fill")
                    }
                }
                Text("\(artist.genre) · \(artist.monthlyListeners.compact) monthly")
                    .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                if let e = earnings {
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle.fill").font(.system(size: 9)).foregroundStyle(VYBE.green)
                        Text("Fan-funded: $\(e.total.compact) this month")
                            .font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.green)
                    }
                    .padding(.top, 1)
                }
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary).font(.system(size: 13))
        }
        .padding(12)
        .vybeCard(corner: 16)
    }
}

// MARK: - Scene Spotlight Card

struct SceneSpotlightCard: View {
    let spot: (title: String, subtitle: String, description: String, accent: String)
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HoloArt(seed: spot.title, corner: 0).frame(height: 100)
            VStack(alignment: .leading, spacing: 6) {
                NeonTag(text: spot.subtitle, color: VYBE.cyan, icon: "newspaper.fill")
                Text(spot.title)
                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                    .foregroundStyle(VYBE.text)
                    .lineLimit(2)
                Text(spot.description)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(VYBE.textSecondary)
                    .lineLimit(3)
            }
            .padding(12)
        }
        .frame(width: 260)
        .background(VYBE.card)
        .clipShape(.rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.stroke, lineWidth: 1))
    }
}

struct SongRow: View {
    @Environment(AppState.self) private var app
    let song: Song
    var body: some View {
        HStack(spacing: 12) {
            HoloArt(seed: song.title, corner: 12).frame(width: 52, height: 52)
                .overlay(Image(systemName: "play.fill").font(.system(size: 16)).foregroundStyle(.white))
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 5) {
                    Text(song.title).font(.system(size: 15, weight: .bold)).foregroundStyle(VYBE.text).lineLimit(1)
                    if song.isViral { Image(systemName: "flame.fill").font(.system(size: 11)).foregroundStyle(VYBE.magenta) }
                }
                Text("\(song.artistName) · \(song.plays.compact) plays")
                    .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
            }
            Spacer()
            Image(systemName: app.savedSongs.contains(song.id) ? "checkmark.circle.fill" : "plus.circle")
                .font(.system(size: 22))
                .foregroundStyle(app.savedSongs.contains(song.id) ? VYBE.green : VYBE.textSecondary)
        }
        .padding(12)
        .vybeCard(corner: 16)
    }
}
