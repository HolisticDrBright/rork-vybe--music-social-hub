//
//  ArtistProfileView.swift
//  VYBE
//
//  Artist profile with music, events, fan wall, top fans, and earnings transparency.
//

import SwiftUI

struct ArtistProfileView: View {
    @Environment(AppState.self) private var app
    let artistId: String
    @State private var tab = 0
    private let tabs = ["Music", "Events", "Fan Wall", "Top Fans", "Earnings"]

    private var artist: Artist { Mock.artist(artistId) }
    private var following: Bool { app.followedArtists.contains(artistId) }

    var body: some View {
        ZStack {
            VYBE.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    header
                    VStack(spacing: 20) {
                        actions
                        statsRow
                        if artist.aiEnabled { aiBanner }
                        earningsBanner
                        sleevesVideosBanner
                        dropCampaignBanner
                        tabPicker
                        tabContent
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .vybeDestinations()
    }

    private var header: some View {
        ZStack(alignment: .bottom) {
            HoloArt(seed: artist.name + "header")
                .frame(height: 280)
            LinearGradient(colors: [.clear, VYBE.bg], startPoint: .center, endPoint: .bottom)
                .frame(height: 280)
            VStack(spacing: 8) {
                AvatarView(seed: artist.name, size: 92)
                    .neonGlow(VYBE.magenta, radius: 18)
                HStack(spacing: 6) {
                    Text(artist.name)
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    if artist.isVerified { VerifiedBadge(size: 18) }
                }
                Text("\(artist.handle) · \(artist.city)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.8))
                HStack(spacing: 6) {
                    ForEach(artist.tags, id: \.self) { NeonTag(text: $0, color: VYBE.purple) }
                    NeonTag(text: "Open to Collab", color: VYBE.green, icon: "person.2.wave.2.fill")
                }
                .padding(.top, 2)
            }
            .padding(.bottom, 10)
        }
    }

    private var actions: some View {
        HStack(spacing: 12) {
            Button {
                app.toggleFollow(artistId)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: following ? "checkmark" : "plus")
                    Text(following ? "Following" : "Follow")
                }
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(following ? VYBE.text : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background {
                    if following { Capsule().fill(.white.opacity(0.1)).overlay(Capsule().stroke(VYBE.stroke, lineWidth: 1)) }
                    else { Capsule().fill(VYBE.holo).neonGlow(VYBE.purple, radius: 12) }
                }
            }
            .buttonStyle(.plain)

            // Support / tip button
            Button {
                app.tipArtist(artistId, amount: 5)
                app.hapticSuccess()
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(VYBE.magenta)
                    .frame(width: 50, height: 48)
                    .background(.white.opacity(0.08), in: .capsule)
                    .overlay(Capsule().stroke(VYBE.stroke, lineWidth: 1))
            }
            .buttonStyle(.plain)

            NavigationLink(value: Route.leaderboard(artistId)) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(VYBE.gold)
                    .frame(width: 50, height: 48)
                    .background(.white.opacity(0.08), in: .capsule)
                    .overlay(Capsule().stroke(VYBE.stroke, lineWidth: 1))
            }
            .buttonStyle(.plain)

            Button {} label: {
                Image(systemName: "bag.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(VYBE.text)
                    .frame(width: 50, height: 48)
                    .background(.white.opacity(0.08), in: .capsule)
                    .overlay(Capsule().stroke(VYBE.stroke, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
    }

    private var statsRow: some View {
        HStack {
            StatBlock(value: artist.monthlyListeners.compact, label: "Listeners")
            Divider().frame(height: 30).overlay(VYBE.stroke)
            StatBlock(value: artist.followers.compact, label: "Followers", color: VYBE.magenta)
            Divider().frame(height: 30).overlay(VYBE.stroke)
            StatBlock(value: "\(Mock.songs(for: artistId).count)", label: "Tracks", color: VYBE.cyan)
        }
        .padding(.vertical, 14)
        .vybeCard(corner: 18)
    }

    private var aiBanner: some View {
        NavigationLink(value: Route.aiChat(artistId)) {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(VYBE.holo).frame(width: 48, height: 48)
                    Image(systemName: "cpu.fill").font(.system(size: 20)).foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 5) {
                        Text("Chat with AI \(artist.name)").font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    }
                    Text("Official artist-approved AI · ask anything")
                        .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.cyan)
                }
                Spacer()
                Image(systemName: "arrow.right.circle.fill").font(.system(size: 24)).foregroundStyle(VYBE.cyan)
            }
            .padding(14)
            .background {
                ZStack { VYBE.card; HoloArt(seed: "aibanner").opacity(0.14) }
                    .clipShape(.rect(cornerRadius: 18))
            }
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.cyan.opacity(0.4), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Earnings Banner

    private var earningsBanner: some View {
        NavigationLink(value: Route.earnings(artistId)) {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(VYBE.green.opacity(0.15)).frame(width: 44, height: 44)
                    Image(systemName: "bolt.heart.fill").font(.system(size: 18)).foregroundStyle(VYBE.green)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Supported directly by fans").font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Text("Earns far more than streaming · artist keeps 90%").font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.green)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 13)).foregroundStyle(VYBE.textTertiary)
            }
            .padding(14)
            .background {
                ZStack { VYBE.card; HoloArt(seed: "earnings\(artistId)").opacity(0.1) }
                    .clipShape(.rect(cornerRadius: 18))
            }
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.green.opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private var sleevesVideosBanner: some View {
        let sleeve = Mock.sleeves.first { $0.artistId == artistId }
        let route: Route = sleeve.map { Route.sleeve($0.id) } ?? .vybeTV
        return NavigationLink(value: route) {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(VYBE.holo).frame(width: 44, height: 44)
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill").font(.system(size: 18)).foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Sleeves + Videos").font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Text(sleeve != nil ? "Open the art, lyrics & liner notes · watch on VYBE TV" : "Watch this artist on VYBE TV")
                        .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
            }
            .padding(14)
            .background { ZStack { VYBE.card; HoloArt(seed: "sleevebanner\(artistId)").opacity(0.12) }.clipShape(.rect(cornerRadius: 18)) }
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.purple.opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder private var dropCampaignBanner: some View {
        let campaign = app.dropCampaigns.first { $0.artistId == artistId }
        let openMissions = app.missions(forArtist: artistId).count
        let route: Route = campaign.map { Route.dropCampaign($0.id) } ?? .artistMissions
        NavigationLink(value: route) {
            HStack(spacing: 12) {
                ZStack { Circle().fill(VYBE.holoSunset).frame(width: 44, height: 44)
                    Image(systemName: "flame.fill").font(.system(size: 18)).foregroundStyle(.white) }
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(campaign != nil ? "Drop Campaign" : "Growth Missions").font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                        if campaign?.bornOnVYBE == true { BornOnVYBEBadge() }
                    }
                    Text(campaign != nil ? (campaign!.countdownText) : "\(openMissions) open missions to help \(artist.name) grow")
                        .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
            }
            .padding(14)
            .background { ZStack { VYBE.card; HoloArt(seed: "dropbanner\(artistId)").opacity(0.12) }.clipShape(.rect(cornerRadius: 18)) }
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.magenta.opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { i in
                Button {
                    withAnimation(.snappy) { tab = i }
                } label: {
                    VStack(spacing: 6) {
                        Text(tabs[i])
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(tab == i ? VYBE.text : VYBE.textSecondary)
                        Capsule().fill(tab == i ? AnyShapeStyle(VYBE.holo) : AnyShapeStyle(Color.clear))
                            .frame(height: 3)
                    }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
        }
    }

    @ViewBuilder private var tabContent: some View {
        switch tab {
        case 0:
            VStack(alignment: .leading, spacing: 14) {
                Text(artist.bio).font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                ForEach(Mock.songs(for: artistId)) { song in
                    NavigationLink(value: Route.song(song.id)) { SongRow(song: song) }.buttonStyle(.plain)
                }
                challengesBlock
            }
        case 1:
            VStack(spacing: 10) {
                let evs = Mock.events.filter { $0.lineup.contains(artist.name) }
                if evs.isEmpty {
                    emptyState("No upcoming shows", "calendar")
                }
                ForEach(evs) { e in
                    NavigationLink(value: Route.event(e.id)) { EventRow(event: e) }.buttonStyle(.plain)
                }
            }
        case 2:
            fanWall
        case 4:
            earningsTab
        default:
            topFans
        }
    }

    // MARK: - Earnings Tab

    private var earningsTab: some View {
        VStack(alignment: .leading, spacing: 14) {
            let e = Mock.earnings(for: artistId)
            VStack(alignment: .leading, spacing: 6) {
                Text("Supported directly by fans")
                    .font(.system(size: 20, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                Text("On VYBE, support reaches \(artist.name) directly — worth far more than passive streaming plays.")
                    .font(.system(size: 12)).foregroundStyle(VYBE.textSecondary).lineSpacing(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14).vybeCard(corner: 16)
            HStack(spacing: 0) {
                earningsBreakdownItem("heart.fill", "Tips", VYBE.magenta)
                earningsBreakdownItem("music.note.list", "Drops", VYBE.cyan)
                earningsBreakdownItem("tshirt.fill", "Merch", VYBE.blue)
                earningsBreakdownItem("ticket.fill", "Events", VYBE.green)
            }
            .padding(10).vybeCard(corner: 16)
            NavigationLink(value: Route.earnings(artistId)) {
                Text("How support works →").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.green).frame(maxWidth: .infinity).padding(.vertical, 8)
            }
            Text("Artist keeps \(e.artistKeepsPercent)% of every dollar of fan support — VYBE's fee is 10% (plus card processing). Compare: Spotify pays ~$0.004 per stream.")
                .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(3)
        }
    }

    private func earningsBreakdownItem(_ icon: String, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(color)
            Text(label).font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.text)
        }
        .frame(maxWidth: .infinity)
    }

    private var challengesBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Active Challenges")
            ForEach(Mock.challenges.filter { $0.artistName == artist.name }) { ch in
                ChallengeCard(challenge: ch)
            }
        }
        .padding(.top, 6)
    }

    private var fanWall: some View {
        VStack(spacing: 10) {
            ForEach(Mock.boardPosts.prefix(4)) { post in
                BoardPostRow(post: post)
            }
        }
    }

    private var topFans: some View {
        VStack(spacing: 10) {
            ForEach(Array(Mock.leaderboard.prefix(5).enumerated()), id: \.element.id) { idx, fan in
                LeaderRow(rank: idx + 1, fan: fan)
            }
            NavigationLink(value: Route.leaderboard(artistId)) {
                Text("View full leaderboard")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(VYBE.purple)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
        }
    }

    private func emptyState(_ text: String, _ icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 28)).foregroundStyle(VYBE.textTertiary)
            Text(text).font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.textSecondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 30)
    }
}

struct ChallengeCard: View {
    @Environment(AppState.self) private var app
    let challenge: Challenge
    private var joined: Bool { app.joinedChallenges.contains(challenge.id) }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: challenge.icon)
                    .font(.system(size: 16, weight: .bold)).foregroundStyle(VYBE.gold)
                    .frame(width: 38, height: 38).background(VYBE.gold.opacity(0.15), in: .circle)
                VStack(alignment: .leading, spacing: 2) {
                    Text(challenge.title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Text("\(challenge.participants.compact) joined · \(challenge.deadline)")
                        .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                }
                Spacer()
                Text("+\(challenge.reward)")
                    .font(.system(size: 13, weight: .black, design: .rounded)).foregroundStyle(VYBE.gold)
            }
            NeonProgressBar(progress: challenge.progress, gradient: VYBE.goldGrad)
            Button {
                app.joinChallenge(challenge.id, reward: challenge.reward)
            } label: {
                Text(joined ? "Joined ✓" : "Join challenge")
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundStyle(joined ? VYBE.green : .white)
                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                    .background {
                        if joined { Capsule().fill(VYBE.green.opacity(0.15)) }
                        else { Capsule().fill(VYBE.goldGrad) }
                    }
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .vybeCard(corner: 18)
    }
}
