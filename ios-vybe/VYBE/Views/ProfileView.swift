//
//  ProfileView.swift
//  VYBE
//
//  Fan profile with music personality, badges, top artists,
//  saved songs, concert history, and "Artists you've funded" section.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var app

    private var earnedBadges: [Badge] { Mock.badges.filter { $0.earned } }
    private var savedSongs: [Song] { Mock.songs.filter { app.savedSongs.contains($0.id) } }
    private var topArtists: [Artist] { Mock.artists.filter { app.followedArtists.contains($0.id) } }
    private var discoveredArtistsList: [Artist] { Mock.artists.filter { app.discoveredArtists.contains($0.id) } }

    var body: some View {
        ZStack {
            VYBE.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    header
                    VStack(spacing: 20) {
                        Group {
                            // Artist tools (dashboard + Collab Lab) — always reachable in the prototype.
                            dashboardLink
                            cultureLinks
                            fanImpactSection
                            fundedArtistsSection
                            discoveredSection
                        }
                        Group {
                            personality
                            badgesSection
                            topArtistsSection
                            savedSection
                            concertHistory
                            revenueModules
                        }
                    }
                    .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 40)
                }
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: Route.settings) {
                    Image(systemName: "gearshape.fill").foregroundStyle(VYBE.text)
                }
            }
        }
        .vybeDestinations()
    }

    private var header: some View {
        ZStack(alignment: .bottom) {
            HoloArt(seed: "youprofile").frame(height: 200)
            LinearGradient(colors: [.clear, VYBE.bg], startPoint: .center, endPoint: .bottom).frame(height: 200)
            VStack(spacing: 8) {
                AvatarView(seed: "you", size: 88).neonGlow(VYBE.magenta, radius: 16)
                Text("@you").font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(.white)
                HStack(spacing: 8) {
                    NeonTag(text: app.role.rawValue, color: VYBE.purple, icon: app.role.icon)
                    NeonTag(text: "Rank #\(app.fanRank)", color: VYBE.gold, icon: "crown.fill")
                    NeonTag(text: "Los Angeles", color: VYBE.blue, icon: "mappin")
                }
                HStack(spacing: 24) {
                    StatBlock(value: app.vybeScore.compact, label: "VYBE Score", color: VYBE.magenta)
                    StatBlock(value: "$\(app.totalEarningsDriven)", label: "Driven to Artists", color: VYBE.green)
                    StatBlock(value: "\(app.followedArtists.count)", label: "Following", color: VYBE.cyan)
                }
                .padding(.top, 6).padding(.horizontal, 30)
            }
            .padding(.bottom, 6)
        }
    }

    private var cultureLinks: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                cultureLink("Your Investments", "chart.line.uptrend.xyaxis", VYBE.green, .fanTimeline)
                cultureLink("Music DNA", "waveform.path.ecg.rectangle.fill", VYBE.magenta, .musicDNA)
            }
            cultureLink("Fan Crews", "person.3.fill", VYBE.cyan, .fanCrews, wide: true)
        }
    }

    private func cultureLink(_ title: String, _ icon: String, _ color: Color, _ route: Route, wide: Bool = false) -> some View {
        NavigationLink(value: route) {
            HStack(spacing: 10) {
                Image(systemName: icon).font(.system(size: 16, weight: .bold)).foregroundStyle(color).frame(width: 26)
                Text(title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(1)
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(VYBE.textTertiary)
            }
            .padding(14).vybeCard(corner: 16)
        }
        .buttonStyle(.plain)
    }

    private var dashboardLink: some View {
        NavigationLink(value: Route.dashboard) {
            HStack(spacing: 12) {
                Image(systemName: "chart.bar.xaxis.ascending").font(.system(size: 18, weight: .bold)).foregroundStyle(.white)
                    .frame(width: 44, height: 44).background(VYBE.holo, in: .circle)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Artist Dashboard").font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Text("Collab Lab · fan growth · earnings & analytics").font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
            }
            .padding(14).vybeCard(corner: 18)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Funded Artists

    private var fundedArtistsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Artists You've Funded")
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("$\(app.totalEarningsDriven)")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundStyle(VYBE.green)
                    Text("Total earnings you drove to artists")
                        .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                }
                Spacer()
                NavigationLink(value: Route.viralStats) {
                    HStack(spacing: 4) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("Impact").font(.system(size: 12, weight: .bold))
                    }
                    .foregroundStyle(VYBE.purple)
                }
            }
            .padding(.bottom, 4)

            ForEach(Mock.fundedArtists) { fa in
                HStack(spacing: 12) {
                    AvatarView(seed: fa.artistName, size: 44)
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Text(fa.artistName).font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                            Text(fa.artistHandle).font(.system(size: 11)).foregroundStyle(VYBE.textSecondary)
                        }
                        HStack(spacing: 8) {
                            Label("$\(fa.totalContributed)", systemImage: "dollarsign.circle.fill")
                                .font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.green)
                            Label("Rank #\(fa.rank)", systemImage: "crown.fill")
                                .font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.gold)
                        }
                        Text(fa.supportActions.joined(separator: " · "))
                            .font(.system(size: 10, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary).font(.system(size: 12))
                }
                .padding(12)
                .vybeCard(corner: 14)
            }
        }
    }

    // MARK: - Fan Impact

    private var fanImpactSection: some View {
        let impact = FanImpact.build(app)
        return VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Your Impact")
            HStack(spacing: 10) {
                impactTile("$\(impact.earningsDriven.compact)", "Drove to artists", VYBE.green, "dollarsign.circle.fill")
                impactTile("\(impact.discoveredCount)", "Discovered", VYBE.cyan, "sparkle.magnifyingglass")
                impactTile("\(impact.artistsFunded)", "Funded", VYBE.magenta, "heart.fill")
            }

            // Scene influence
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label("Your Scene Influence", systemImage: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Spacer()
                    Text(impact.sceneInfluenceLabel)
                        .font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.gold)
                }
                NeonProgressBar(progress: impact.sceneInfluencePercent, gradient: VYBE.goldGrad)
            }
            .padding(14).vybeCard(corner: 16)

            // Early Discoverer wins
            if !impact.earlyWins.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Early Discoverer Wins")
                        .font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.textSecondary)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(impact.earlyWins) { artist in
                                NavigationLink(value: Route.artist(artist.id)) {
                                    VStack(spacing: 6) {
                                        AvatarView(seed: artist.name, size: 52)
                                            .overlay(alignment: .bottomTrailing) {
                                                Image(systemName: "rosette").font(.system(size: 12))
                                                    .foregroundStyle(VYBE.gold).padding(3)
                                                    .background(VYBE.bg, in: .circle)
                                            }
                                        Text(artist.name).font(.system(size: 10, weight: .bold))
                                            .foregroundStyle(VYBE.text).lineLimit(1).frame(width: 64)
                                        Text(artist.isUndergroundRising ? "📈 rising" : "early")
                                            .font(.system(size: 9, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.green)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }

            // Fan rank by artist
            if !impact.rankByArtist.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Rank by Artist")
                        .font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.textSecondary)
                    ForEach(impact.rankByArtist, id: \.artist.id) { entry in
                        NavigationLink(value: Route.leaderboard(entry.artist.id)) {
                            HStack(spacing: 12) {
                                AvatarView(seed: entry.artist.name, size: 38)
                                Text(entry.artist.name).font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                                Spacer()
                                Text("#\(entry.rank)").font(.system(size: 15, weight: .black, design: .rounded)).foregroundStyle(VYBE.gold)
                                Image(systemName: "crown.fill").font(.system(size: 11)).foregroundStyle(VYBE.gold)
                            }
                            .padding(12).vybeCard(corner: 14)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func impactTile(_ value: String, _ label: String, _ color: Color, _ icon: String) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 14, weight: .bold)).foregroundStyle(color)
            Text(value).font(.system(size: 17, weight: .black, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(1).minimumScaleFactor(0.7)
            Text(label).font(.system(size: 10, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 14).vybeCard(corner: 16)
    }

    // MARK: - Discovered by You (#17)

    private var discoveredSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                SectionHeader(title: "Discovered by You")
                NavigationLink(value: Route.hiddenGems) {
                    HStack(spacing: 3) {
                        Image(systemName: "sparkle.magnifyingglass").font(.system(size: 11, weight: .bold))
                        Text("Find gems").font(.system(size: 13, weight: .bold))
                    }
                    .foregroundStyle(VYBE.cyan)
                }
                .buttonStyle(.plain)
            }

            if discoveredArtistsList.isEmpty {
                NavigationLink(value: Route.hiddenGems) {
                    HStack(spacing: 12) {
                        Image(systemName: "sparkle.magnifyingglass")
                            .font(.system(size: 18, weight: .bold)).foregroundStyle(.white)
                            .frame(width: 44, height: 44).background(VYBE.holo, in: .circle)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Discover unknowns like your favorites")
                                .font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                            Text("Support an artist early — make their rise your story.")
                                .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
                    }
                    .padding(14).vybeCard(corner: 18)
                }
                .buttonStyle(.plain)
            } else {
                ForEach(discoveredArtistsList) { artist in
                    NavigationLink(value: Route.artist(artist.id)) {
                        HStack(spacing: 12) {
                            AvatarView(seed: artist.name, size: 44)
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 4) {
                                    Text(artist.name).font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                                    if artist.isVerified { VerifiedBadge(size: 11) }
                                }
                                HStack(spacing: 8) {
                                    Label("Early Discoverer", systemImage: "sparkle.magnifyingglass")
                                        .font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.green)
                                    Text("\(artist.monthlyListeners.compact) listeners")
                                        .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                                }
                                if artist.isUndergroundRising {
                                    Text("📈 On the rise — your early call is paying off")
                                        .font(.system(size: 10, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.gold)
                                }
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary).font(.system(size: 12))
                        }
                        .padding(12).vybeCard(corner: 14)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var personality: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Music Personality")
            HStack(spacing: 10) {
                personalityChip("Euphoric Explorer", VYBE.magenta)
                personalityChip("Festival Native", VYBE.gold)
            }
            HStack(spacing: 10) {
                personalityChip("Underground Scout", VYBE.green)
                personalityChip("Night Owl", VYBE.purple)
            }
            Text("Top genres: \(personalityGenres)")
                .font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.textSecondary).padding(.top, 2)
        }
        .padding(16).vybeCard(corner: 20)
    }

    /// Blend default taste with genres surfaced through discovery.
    private var personalityGenres: String {
        var genres = ["Hyperpop", "Dream Pop", "Afro-House"]
        for g in app.discoveredGenres where !genres.contains(g) { genres.append(g) }
        return genres.prefix(5).joined(separator: " · ")
    }

    private func personalityChip(_ text: String, _ color: Color) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(color)
            .frame(maxWidth: .infinity).padding(.vertical, 10)
            .background(color.opacity(0.14), in: .rect(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.3), lineWidth: 1))
    }

    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Badges · \(earnedBadges.count)/\(Mock.badges.count)")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Mock.badges) { badge in BadgeView(badge: badge) }
                }
            }
        }
    }

    private var topArtistsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Top Artists")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(topArtists.isEmpty ? Array(Mock.artists.prefix(4)) : topArtists) { artist in
                        NavigationLink(value: Route.artist(artist.id)) {
                            VStack(spacing: 6) {
                                AvatarView(seed: artist.name, size: 64)
                                Text(artist.name).font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.text).lineLimit(1).frame(width: 72)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var savedSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Saved Songs")
            ForEach(savedSongs.isEmpty ? Array(Mock.songs.prefix(2)) : savedSongs) { song in
                NavigationLink(value: Route.song(song.id)) { SongRow(song: song) }.buttonStyle(.plain)
            }
        }
    }

    private var concertHistory: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Concert History")
            HStack(spacing: 10) {
                historyStat("\(app.showsAttended)", "Shows", VYBE.magenta)
                historyStat("3", "Festivals", VYBE.gold)
                historyStat("8", "Cities", VYBE.cyan)
            }
        }
    }

    private func historyStat(_ v: String, _ l: String, _ c: Color) -> some View {
        VStack(spacing: 4) {
            Text(v).font(.system(size: 24, weight: .black, design: .rounded)).foregroundStyle(c)
            Text(l).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 16).vybeCard(corner: 16)
    }

    private var revenueModules: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Membership & Perks")
            VStack(spacing: 0) {
                perkRow("crown.fill", "VYBE Premium", "2x points · ad-free · early access", VYBE.gold)
                Divider().overlay(VYBE.stroke).padding(.leading, 54)
                perkRow("star.circle.fill", "Fan Club Subscriptions", "Support your top artists directly", VYBE.magenta)
                Divider().overlay(VYBE.stroke).padding(.leading, 54)
                perkRow("bag.fill", "Merch & Tickets", "Order history & affiliate perks", VYBE.cyan)
                Divider().overlay(VYBE.stroke).padding(.leading, 54)
                perkRow("dollarsign.circle.fill", "Superfan Tier", "$9.99/mo · Spotify charges $18/mo for less", VYBE.green)
            }
            .vybeCard(corner: 18)
        }
    }

    private func perkRow(_ icon: String, _ title: String, _ sub: String, _ color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon).font(.system(size: 16, weight: .bold)).foregroundStyle(color).frame(width: 26)
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                Text(sub).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(VYBE.textTertiary)
        }
        .padding(14)
    }
}

struct BadgeView: View {
    let badge: Badge
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(badge.earned ? AnyShapeStyle(VYBE.holo) : AnyShapeStyle(Color.white.opacity(0.06)))
                    .frame(width: 64, height: 64)
                    .neonGlow(badge.earned ? VYBE.purple : .clear, radius: 10)
                Image(systemName: badge.icon).font(.system(size: 24, weight: .bold))
                    .foregroundStyle(badge.earned ? .white : VYBE.textTertiary)
            }
            Text(badge.name).font(.system(size: 10, weight: .bold)).foregroundStyle(badge.earned ? VYBE.text : VYBE.textTertiary)
                .multilineTextAlignment(.center).frame(width: 74).lineLimit(2)
        }
        .opacity(badge.earned ? 1 : 0.55)
    }
}
