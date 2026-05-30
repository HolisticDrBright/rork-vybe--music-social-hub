//
//  CollabLabView.swift
//  VYBE
//
//  Collab Lab — artist-to-artist collaboration.
//  Post a beat / hook / loop, invite other artists to submit hooks, verses,
//  remixes or vocals, review submissions, pick a winner, and turn the collab
//  into an Upcoming Drop fans can support early.
//

import SwiftUI

struct CollabLabView: View {
    @Environment(AppState.self) private var app
    @State private var tab = "Open"
    @State private var showCreate = false
    private let tabs = ["Open", "My Challenges", "Submissions", "Collaborators", "Drops"]

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    intro
                    createButton
                    ChipRow(items: tabs, selection: $tab).padding(.horizontal, -20)
                    CollabRightsBanner()
                    content
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Collab Lab")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showCreate = true } label: {
                    Image(systemName: "plus.circle.fill").font(.system(size: 20)).foregroundStyle(VYBE.magenta)
                }
            }
        }
        .sheet(isPresented: $showCreate) { CreateCollabChallengeView().environment(app) }
        .vybeDestinations()
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                NeonTag(text: "COLLAB LAB", color: VYBE.magenta, icon: "person.2.wave.2.fill")
                Spacer()
            }
            Text("Find people to make music with")
                .font(.system(size: 21, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
            Text("Post a beat or idea and invite artists to submit hooks, verses, remixes, or vocals. Pick a winner and turn it into an Upcoming Drop.")
                .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(3)
        }
        .padding(16)
        .background { ZStack { VYBE.card; HoloArt(seed: "collablab").opacity(0.12) }.clipShape(.rect(cornerRadius: 20)) }
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.magenta.opacity(0.25), lineWidth: 1))
    }

    private var createButton: some View {
        PrimaryButton(title: "Create a Challenge", icon: "plus") { showCreate = true }
    }

    @ViewBuilder private var content: some View {
        switch tab {
        case "My Challenges": challengeList(app.myChallenges, empty: "You haven't posted a challenge yet. Tap Create to start.")
        case "Submissions": submissionsTab
        case "Collaborators": collaboratorsTab
        case "Drops": dropsTab
        default: challengeList(app.openChallenges, empty: "No open challenges right now — check back soon.")
        }
    }

    private func challengeList(_ items: [CollabChallenge], empty: String) -> some View {
        Group {
            if items.isEmpty {
                CollabEmptyState(text: empty, icon: "music.mic")
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(items) { CollabChallengeCard(challenge: $0) }
                }
            }
        }
    }

    private var submissionsTab: some View {
        let mine = app.collabSubmissions.filter { $0.artistName == "You" }
        return Group {
            if mine.isEmpty {
                CollabEmptyState(text: "Your submissions to open challenges will appear here.", icon: "paperplane.fill")
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(mine) { sub in
                        NavigationLink(value: Route.collabChallenge(sub.challengeId)) {
                            MySubmissionRow(submission: sub, challenge: app.collabChallenge(sub.challengeId))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var collaboratorsTab: some View {
        let matches = Mock.artists.filter { ["a6", "a4", "a2", "a7", "a3"].contains($0.id) }
        return VStack(alignment: .leading, spacing: 12) {
            Text("Recent collaborator matches")
                .font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.textSecondary)
            ForEach(matches) { CollaboratorRow(artist: $0) }
        }
    }

    private var dropsTab: some View {
        Group {
            if app.upcomingDrops.isEmpty {
                CollabEmptyState(text: "Pick a winner on a challenge to start an Upcoming Drop.", icon: "sparkles")
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(app.upcomingDrops) { drop in
                        NavigationLink(value: Route.upcomingDrop(drop.id)) {
                            UpcomingDropRow(drop: drop)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

// MARK: - Reusable Collab components

/// Rights / splits disclaimer banner.
struct CollabRightsBanner: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "doc.text.magnifyingglass").font(.system(size: 14)).foregroundStyle(VYBE.gold)
            Text(Mock.collabRightsNotice)
                .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(2)
        }
        .padding(12)
        .background(VYBE.gold.opacity(0.08), in: .rect(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(VYBE.gold.opacity(0.25), lineWidth: 1))
    }
}

/// A beat/idea preview placeholder with a fake waveform + play control.
struct CollabBeatPreview: View {
    let seed: String
    var bpm: Int? = nil
    var musicalKey: String? = nil
    var height: CGFloat = 160
    @State private var playing = false

    var body: some View {
        ZStack {
            HoloArt(seed: seed).frame(height: height)
            LinearGradient(colors: [.black.opacity(0.1), .black.opacity(0.55)], startPoint: .top, endPoint: .bottom)
            HStack(spacing: 3) {
                ForEach(0..<32, id: \.self) { i in
                    Capsule().fill(.white.opacity(playing ? 0.85 : 0.55))
                        .frame(width: 3, height: CGFloat(6 + abs((i * 13 + 7) % 26)))
                }
            }
            .frame(height: 44)
            Button {
                withAnimation(.snappy) { playing.toggle() }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Image(systemName: playing ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 50)).foregroundStyle(.white).shadow(radius: 8)
            }
            .buttonStyle(.plain)
        }
        .frame(height: height)
        .clipShape(.rect(cornerRadius: 18))
        .overlay(alignment: .topLeading) {
            NeonTag(text: "PREVIEW · mock audio", color: VYBE.cyan, icon: "waveform").padding(10)
        }
        .overlay(alignment: .bottomLeading) {
            if bpm != nil || musicalKey != nil {
                HStack(spacing: 6) {
                    if let bpm { CollabMetaPill(icon: "metronome", text: "\(bpm) BPM") }
                    if let musicalKey { CollabMetaPill(icon: "pianokeys", text: musicalKey) }
                }
                .padding(10)
            }
        }
    }
}

/// Small meta pill (genre / BPM / key / mood).
struct CollabMetaPill: View {
    let icon: String
    let text: String
    var color: Color = VYBE.text
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 9, weight: .bold))
            Text(text).font(.system(size: 11, weight: .bold, design: .rounded))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 9).padding(.vertical, 5)
        .background(.ultraThinMaterial, in: .capsule)
        .overlay(Capsule().stroke(.white.opacity(0.15), lineWidth: 1))
    }
}

struct CollabEmptyState: View {
    let text: String
    let icon: String
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 30)).foregroundStyle(VYBE.textTertiary)
            Text(text).font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 44)
    }
}

/// The primary challenge card used across Collab Lab.
struct CollabChallengeCard: View {
    let challenge: CollabChallenge

    var body: some View {
        NavigationLink(value: Route.collabChallenge(challenge.id)) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    HoloArt(seed: challenge.previewSeed).frame(height: 120)
                    LinearGradient(colors: [.clear, .black.opacity(0.6)], startPoint: .center, endPoint: .bottom)
                        .frame(height: 120)
                    HStack {
                        NeonTag(text: challenge.challengeType.label, color: VYBE.magenta, icon: challenge.challengeType.icon)
                        Spacer()
                        CollabStatusPill(status: challenge.status)
                    }
                    .padding(10)
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 34)).foregroundStyle(.white.opacity(0.92))
                        .frame(maxWidth: .infinity, maxHeight: 120, alignment: .center)
                }
                VStack(alignment: .leading, spacing: 9) {
                    Text(challenge.title)
                        .font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                        .lineLimit(2)
                    HStack(spacing: 8) {
                        AvatarView(seed: challenge.creatorName, size: 26)
                        Text("by \(challenge.creatorName)").font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
                        Spacer()
                        Text("“\(challenge.beatTitle)”").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textTertiary).lineLimit(1)
                    }
                    // Meta chips
                    FlowLayout(spacing: 6) {
                        CollabMetaPill(icon: "guitars", text: challenge.genre, color: VYBE.cyan)
                        CollabMetaPill(icon: "metronome", text: "\(challenge.bpm) BPM", color: VYBE.textSecondary)
                        CollabMetaPill(icon: "pianokeys", text: challenge.key, color: VYBE.textSecondary)
                        CollabMetaPill(icon: "sparkles", text: challenge.mood, color: VYBE.purple)
                    }
                    // Looking for
                    HStack(spacing: 6) {
                        Image(systemName: "magnifyingglass").font(.system(size: 10)).foregroundStyle(VYBE.gold)
                        Text("Looking for: \(challenge.lookingFor.joined(separator: ", "))")
                            .font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.gold).lineLimit(1)
                    }
                    // Footer
                    HStack(spacing: 14) {
                        Label("\(challenge.submissionCount)", systemImage: "tray.full.fill")
                            .font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.textSecondary)
                        Label(challenge.deadlineText, systemImage: "clock.fill")
                            .font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.textSecondary)
                        Spacer()
                        Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(VYBE.textTertiary)
                    }
                    .padding(.top, 2)
                }
                .padding(14)
            }
            .background(VYBE.card)
            .clipShape(.rect(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.stroke, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

struct CollabStatusPill: View {
    let status: CollabStatus
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status.icon).font(.system(size: 9, weight: .bold))
            Text(status.label).font(.system(size: 11, weight: .heavy, design: .rounded))
        }
        .foregroundStyle(status.color)
        .padding(.horizontal, 9).padding(.vertical, 5)
        .background(status.color.opacity(0.16), in: .capsule)
        .overlay(Capsule().stroke(status.color.opacity(0.4), lineWidth: 1))
    }
}

/// A row for the user's own outgoing submissions.
struct MySubmissionRow: View {
    let submission: CollabSubmission
    let challenge: CollabChallenge?
    var body: some View {
        HStack(spacing: 12) {
            HoloArt(seed: submission.previewSeed, corner: 12).frame(width: 48, height: 48)
                .overlay(Image(systemName: submission.submissionType.icon).font(.system(size: 14)).foregroundStyle(.white))
            VStack(alignment: .leading, spacing: 2) {
                Text(submission.title).font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text).lineLimit(1)
                Text("to “\(challenge?.title ?? "challenge")”").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
            }
            Spacer()
            SubmissionStatusPill(status: submission.status)
        }
        .padding(12).vybeCard(corner: 14)
    }
}

struct SubmissionStatusPill: View {
    let status: SubmissionStatus
    var body: some View {
        Text(status.label)
            .font(.system(size: 10, weight: .heavy, design: .rounded))
            .foregroundStyle(status.color)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(status.color.opacity(0.16), in: .capsule)
    }
}

/// Collaborator match row (Collaborators tab).
struct CollaboratorRow: View {
    @Environment(AppState.self) private var app
    let artist: Artist
    @State private var invited = false
    var body: some View {
        HStack(spacing: 12) {
            AvatarView(seed: artist.name, size: 46)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(artist.name).font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                    if artist.isVerified { VerifiedBadge(size: 11) }
                }
                Text("Open to Collab · \(artist.genre) · \(artist.city)")
                    .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
            }
            Spacer()
            Button {
                invited = true
                app.haptic(.light)
            } label: {
                Text(invited ? "Invited ✓" : "Invite")
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .foregroundStyle(invited ? VYBE.green : .white)
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background {
                        if invited { Capsule().fill(VYBE.green.opacity(0.15)) }
                        else { Capsule().fill(VYBE.holo) }
                    }
            }
            .buttonStyle(.plain)
        }
        .padding(12).vybeCard(corner: 16)
    }
}

/// A compact upcoming-drop row.
struct UpcomingDropRow: View {
    let drop: UpcomingDrop
    var body: some View {
        HStack(spacing: 12) {
            HoloArt(seed: drop.previewSeed, corner: 14).frame(width: 64, height: 64)
                .overlay(alignment: .topLeading) {
                    if drop.bornOnVYBE {
                        Image(systemName: "sparkles").font(.system(size: 11)).foregroundStyle(VYBE.cyan).padding(4)
                    }
                }
            VStack(alignment: .leading, spacing: 3) {
                Text(drop.title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(2)
                Text(drop.artistNames.joined(separator: " × ")).font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.magenta).lineLimit(1)
                HStack(spacing: 8) {
                    if drop.bornOnVYBE { NeonTag(text: "Born on VYBE", color: VYBE.cyan, icon: "sparkles") }
                    Text(drop.releaseText).font(.system(size: 10, weight: .bold)).foregroundStyle(VYBE.textSecondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(VYBE.textTertiary)
        }
        .padding(12).vybeCard(corner: 16)
    }
}
