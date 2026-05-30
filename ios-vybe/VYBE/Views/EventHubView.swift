//
//  EventHubView.swift
//  VYBE
//
//  Concert/event hub with details, lineup, RSVP, and a community message board.
//

import SwiftUI

struct EventHubView: View {
    @Environment(AppState.self) private var app
    let eventId: String
    @State private var channel = "All"
    @State private var posts: [BoardPost] = Mock.boardPosts
    @State private var composing = false
    @State private var draft = ""
    @State private var showGuidelines = false
    @State private var hasPostedBefore = false

    private var event: Event { Mock.events.first { $0.id == eventId } ?? Mock.events[0] }
    private var going: Bool { app.rsvpEvents.contains(eventId) }

    private var filteredPosts: [BoardPost] {
        channel == "All" ? posts : posts.filter { $0.channel == channel }
    }

    var body: some View {
        ZStack {
            VYBE.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    header
                    VStack(spacing: 18) {
                        rsvpRow
                        details
                        lineup
                        memoryWall
                        boardSection
                    }
                    .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 40)
                }
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .vybeDestinations()
        .sheet(isPresented: $composing) { composer }
        .sheet(isPresented: $showGuidelines) {
            GuidelinesSheet(isFirstTime: true) {
                showGuidelines = false
                hasPostedBefore = true
                composing = true
            }
        }
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            HoloArt(seed: event.title).frame(height: 240)
            LinearGradient(colors: [.clear, VYBE.bg], startPoint: .center, endPoint: .bottom).frame(height: 240)
            VStack(alignment: .leading, spacing: 6) {
                if event.isFestival { NeonTag(text: "FESTIVAL", color: VYBE.gold, icon: "star.fill") }
                Text(event.title).font(.system(size: 24, weight: .black, design: .rounded)).foregroundStyle(.white)
                Text("\(event.venue) · \(event.city)").font(.system(size: 13, weight: .semibold)).foregroundStyle(.white.opacity(0.85))
            }
            .padding(16)
        }
    }

    private var rsvpRow: some View {
        HStack(spacing: 12) {
            Button {
                app.toggleRSVP(eventId)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: going ? "checkmark.circle.fill" : "hand.raised.fill")
                    Text(going ? "I'm Going!" : "I'm Going")
                }
                .font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(going ? AnyShapeStyle(VYBE.green) : AnyShapeStyle(VYBE.holo), in: .capsule)
                .neonGlow(going ? VYBE.green : VYBE.magenta, radius: 12)
            }
            .buttonStyle(.plain)
            Button {} label: {
                HStack(spacing: 6) { Image(systemName: "ticket.fill"); Text("Tickets") }
                    .font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.gold)
                    .padding(.horizontal, 18).padding(.vertical, 14)
                    .background(.white.opacity(0.08), in: .capsule)
                    .overlay(Capsule().stroke(VYBE.gold.opacity(0.4), lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
    }

    private var details: some View {
        HStack {
            detailItem("calendar", event.date.formatted(.dateTime.month().day()), "Date")
            Divider().frame(height: 36).overlay(VYBE.stroke)
            detailItem("clock.fill", "9:00 PM", "Doors")
            Divider().frame(height: 36).overlay(VYBE.stroke)
            detailItem("person.3.fill", event.attending.compact, "Going")
            Divider().frame(height: 36).overlay(VYBE.stroke)
            detailItem("dollarsign.circle.fill", "$\(event.ticketPriceFrom)+", "From")
        }
        .padding(.vertical, 14).vybeCard(corner: 18)
    }

    private func detailItem(_ icon: String, _ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(VYBE.purple)
            Text(value).font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
            Text(label).font(.system(size: 10, weight: .medium)).foregroundStyle(VYBE.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var lineup: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Lineup")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(event.lineup, id: \.self) { name in
                        let aid = Mock.artists.first { $0.name == name }?.id
                        NavigationLink(value: Route.artist(aid ?? "a1")) {
                            VStack(spacing: 6) {
                                AvatarView(seed: name, size: 64)
                                Text(name).font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.text)
                                    .lineLimit(1).frame(width: 72)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var memoryWall: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "📸 Memory Wall")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<6) { i in
                        HoloArt(seed: "\(event.id)mem\(i)", corner: 14)
                            .frame(width: 110, height: 140)
                            .overlay(alignment: .bottomLeading) {
                                Image(systemName: "play.circle.fill").font(.system(size: 18)).foregroundStyle(.white).padding(8)
                            }
                    }
                }
            }
        }
    }

    private var boardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SectionHeader(title: "Attendee Board")
                Spacer()
                Button {
                    if hasPostedBefore { composing = true }
                    else { showGuidelines = true }
                } label: {
                    Image(systemName: "square.and.pencil").foregroundStyle(VYBE.magenta)
                }
            }
            ChipRow(items: Mock.boardChannels, selection: $channel).padding(.horizontal, -20)
            ForEach(filteredPosts) { post in
                BoardPostRow(post: post)
            }
        }
    }

    private var composer: some View {
        VStack(spacing: 16) {
            Capsule().fill(.white.opacity(0.2)).frame(width: 40, height: 5).padding(.top, 10)
            Text("Post to \(channel == "All" ? "Meetups" : channel)")
                .font(.system(size: 17, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
            TextField("", text: $draft, prompt: Text("Find your crew, share a ride, link up...").foregroundColor(VYBE.textTertiary), axis: .vertical)
                .foregroundStyle(VYBE.text).lineLimit(3...6)
                .padding(14).background(VYBE.card, in: .rect(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(VYBE.stroke, lineWidth: 1))
                .padding(.horizontal, 20)
            PrimaryButton(title: "Post", icon: "paperplane.fill") {
                let text = draft.trimmingCharacters(in: .whitespaces)
                if !text.isEmpty {
                    posts.insert(BoardPost(id: UUID().uuidString, author: "you", avatarSeed: "you", text: text, minutesAgo: 0, likes: 0, replies: 0, channel: channel == "All" ? "Meetups" : channel), at: 0)
                    app.addScore(40)
                    hasPostedBefore = true
                }
                draft = ""; composing = false
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(VYBE.bgElevated)
        .presentationDetents([.medium])
    }
}

struct BoardPostRow: View {
    @Environment(AppState.self) private var app
    let post: BoardPost
    private var liked: Bool { app.likedPosts.contains(post.id) }

    private var channelColor: Color {
        switch post.channel {
        case "Ride Share": return VYBE.blue
        case "First-Timers": return VYBE.green
        case "VIP": return VYBE.gold
        case "Afterparty": return VYBE.magenta
        default: return VYBE.purple
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                AvatarView(seed: post.avatarSeed, size: 36)
                VStack(alignment: .leading, spacing: 1) {
                    Text("@\(post.author)").font(.system(size: 13, weight: .bold)).foregroundStyle(VYBE.text)
                    Text(post.minutesAgo == 0 ? "just now" : "\(post.minutesAgo)m ago").font(.system(size: 11)).foregroundStyle(VYBE.textTertiary)
                }
                Spacer()
                NeonTag(text: post.channel, color: channelColor)
            }
            Text(post.text).font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.text)
            HStack(spacing: 20) {
                Button {
                    app.toggleLike(post.id)
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: liked ? "heart.fill" : "heart")
                        Text("\(post.likes + (liked ? 1 : 0))")
                    }
                    .font(.system(size: 13, weight: .bold)).foregroundStyle(liked ? VYBE.magenta : VYBE.textSecondary)
                }
                .buttonStyle(.plain)
                HStack(spacing: 5) {
                    Image(systemName: "bubble.right"); Text("\(post.replies)")
                }
                .font(.system(size: 13, weight: .bold)).foregroundStyle(VYBE.textSecondary)
                Spacer()
                Image(systemName: "paperplane").font(.system(size: 13)).foregroundStyle(VYBE.textSecondary)
                Spacer(minLength: 0)
                NavigationLink(value: Route.report(post.id)) {
                    Image(systemName: "ellipsis").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.textTertiary)
                }
            }
        }
        .padding(14).vybeCard(corner: 18)
    }
}
