//
//  CommunitiesView.swift
//  VYBE
//

import SwiftUI

struct CommunitiesView: View {
    @Environment(AppState.self) private var app
    @State private var kind = "All"
    private let kinds = ["All", "Artist", "City", "Genre", "Fan Group"]

    private var communities: [Community] {
        kind == "All" ? Mock.communities : Mock.communities.filter { $0.kind == kind }
    }

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    yourScene
                    cultureEntries
                    ChipRow(items: kinds, selection: $kind).padding(.horizontal, -20)
                    SectionHeader(title: "Communities")
                    VStack(spacing: 12) {
                        ForEach(communities) { c in
                            NavigationLink(value: Route.communityBoard(c.id)) { CommunityCard(community: c) }.buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20).padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Vybes")
        .vybeDestinations()
    }

    private var cultureEntries: some View {
        HStack(spacing: 12) {
            NavigationLink(value: Route.scenePulse) {
                cultureTile("Scene Pulse", "🌃", "City heat & rising scenes", VYBE.magenta)
            }.buttonStyle(.plain)
            NavigationLink(value: Route.fanCrews) {
                cultureTile("Fan Crews", "🤝", "Join a squad, run missions", VYBE.cyan)
            }.buttonStyle(.plain)
        }
    }

    private func cultureTile(_ title: String, _ emoji: String, _ sub: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(emoji).font(.system(size: 22))
            Text(title).font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
            Text(sub).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding(14)
        .background { ZStack { VYBE.card; HoloArt(seed: title).opacity(0.1) }.clipShape(.rect(cornerRadius: 18)) }
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(color.opacity(0.3), lineWidth: 1))
    }

    private var yourScene: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "📍 Your Local Scene")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    localTile("Shows Near Me", "ticket.fill", "8 this week", VYBE.blue)
                    localTile("Fans Near Me", "person.2.fill", "1.2k in LA", VYBE.magenta)
                    localTile("Local Trending", "chart.line.uptrend.xyaxis", "Neon Bloodstream", VYBE.gold)
                    localTile("Local Meetups", "mappin.and.ellipse", "3 today", VYBE.green)
                }
            }
        }
    }

    private func localTile(_ title: String, _ icon: String, _ sub: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).font(.system(size: 18, weight: .bold)).foregroundStyle(color)
            Text(title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
            Text(sub).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
        }
        .frame(width: 140, alignment: .leading).padding(14)
        .vybeCard(corner: 18)
    }
}

struct CommunityCard: View {
    @Environment(AppState.self) private var app
    let community: Community
    private var joined: Bool { app.joinedCommunities.contains(community.id) }

    private var kindColor: Color {
        switch community.kind {
        case "Artist": return VYBE.magenta
        case "City": return VYBE.blue
        case "Genre": return VYBE.purple
        default: return VYBE.green
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                HoloArt(seed: community.name).frame(height: 100)
                LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .center, endPoint: .bottom)
                HStack {
                    NeonTag(text: community.kind, color: kindColor)
                    Spacer()
                    HStack(spacing: 4) {
                        Circle().fill(VYBE.green).frame(width: 6, height: 6)
                        Text("\(community.activeNow.compact) active").font(.system(size: 11, weight: .bold)).foregroundStyle(.white)
                    }
                }
                .padding(12)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(community.name).font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Text(community.about).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(2)
                HStack {
                    Label("\(community.members.compact) members", systemImage: "person.3.fill")
                        .font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.textSecondary)
                    Spacer()
                    Button {
                        app.toggleCommunity(community.id)
                    } label: {
                        Text(joined ? "Joined" : "Join")
                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                            .foregroundStyle(joined ? VYBE.green : .white)
                            .padding(.horizontal, 16).padding(.vertical, 7)
                            .background {
                                if joined { Capsule().fill(VYBE.green.opacity(0.15)) }
                                else { Capsule().fill(VYBE.holo) }
                            }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 2)
            }
            .padding(14)
        }
        .background(VYBE.card)
        .clipShape(.rect(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.stroke, lineWidth: 1))
    }
}

struct CommunityBoardView: View {
    @Environment(AppState.self) private var app
    let communityId: String
    @State private var posts: [BoardPost] = Array(Mock.boardPosts.shuffled().prefix(5))

    private var community: Community { Mock.communities.first { $0.id == communityId } ?? Mock.communities[0] }

    var body: some View {
        ZStack {
            VYBE.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    header
                    VStack(spacing: 14) {
                        trending
                        ForEach(posts) { BoardPostRow(post: $0) }
                    }
                    .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 40)
                }
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            HoloArt(seed: community.name).frame(height: 200)
            LinearGradient(colors: [.clear, VYBE.bg], startPoint: .center, endPoint: .bottom).frame(height: 200)
            VStack(alignment: .leading, spacing: 6) {
                Text(community.name).font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(.white)
                HStack(spacing: 10) {
                    Label("\(community.members.compact)", systemImage: "person.3.fill")
                    Label("\(community.activeNow.compact) active", systemImage: "dot.radiowaves.left.and.right")
                }
                .font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.cyan)
            }
            .padding(16)
        }
    }

    private var trending: some View {
        HStack(spacing: 10) {
            Image(systemName: "flame.fill").foregroundStyle(VYBE.magenta)
            VStack(alignment: .leading, spacing: 1) {
                Text("Trending topic").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                Text(community.trendingTopic).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
            }
            Spacer()
        }
        .padding(14).vybeCard(corner: 18)
    }
}
