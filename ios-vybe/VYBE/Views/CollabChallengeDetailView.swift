//
//  CollabChallengeDetailView.swift
//  VYBE
//
//  Detail for a single Collab Lab challenge: beat preview, brief, tags,
//  existing submissions + community reactions, and the submit / review CTA.
//

import SwiftUI

struct CollabChallengeDetailView: View {
    @Environment(AppState.self) private var app
    let challengeId: String
    @State private var showSubmit = false
    @State private var showConfirm = false

    private var challenge: CollabChallenge? { app.collabChallenge(challengeId) }
    private var isMine: Bool { challenge?.creatorArtistId == app.collabArtistId }
    private var alreadySubmitted: Bool { app.submittedChallengeIds.contains(challengeId) }
    private var convertedDrop: UpcomingDrop? { app.upcomingDrops.first { $0.originChallengeId == challengeId } }

    var body: some View {
        ZStack {
            VYBEBackground()
            if let challenge {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        CollabBeatPreview(seed: challenge.previewSeed, bpm: challenge.bpm, musicalKey: challenge.key, height: 200)
                        headerBlock(challenge)
                        creatorCard(challenge)
                        briefCard(challenge)
                        tagsBlock(challenge)
                        rewardCard(challenge)
                        CollabRightsBanner()
                        ctaBlock(challenge)
                        submissionsBlock(challenge)
                        reportLink(challenge)
                    }
                    .padding(.horizontal, 20).padding(.vertical, 16)
                }
                .scrollIndicators(.hidden)
                .sheet(isPresented: $showSubmit) {
                    SubmitToChallengeSheet(challengeId: challengeId) { showConfirm = true }
                        .environment(app)
                }
                .alert("Submission sent 🎶", isPresented: $showConfirm) {
                    Button("Nice") {}
                } message: {
                    Text("Your \(challenge.challengeType.submitNoun) was sent to \(challenge.creatorName). If they pick it, this can become a VYBE Upcoming Drop.")
                }
            } else {
                CollabEmptyState(text: "This challenge is no longer available.", icon: "music.mic")
            }
        }
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
        .vybeDestinations()
    }

    private func headerBlock(_ c: CollabChallenge) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                NeonTag(text: c.challengeType.label, color: VYBE.magenta, icon: c.challengeType.icon)
                CollabStatusPill(status: c.status)
                Spacer()
            }
            Text(c.title).font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
            HStack(spacing: 14) {
                Label("\(c.submissionCount) submissions", systemImage: "tray.full.fill")
                Label(c.deadlineText, systemImage: "clock.fill")
                Label(c.visibility.label, systemImage: c.visibility.icon)
            }
            .font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
        }
    }

    private func creatorCard(_ c: CollabChallenge) -> some View {
        let real = Mock.artists.contains { $0.id == c.creatorArtistId }
        return Group {
            if real {
                NavigationLink(value: Route.artist(c.creatorArtistId)) { creatorRow(c, chevron: true) }
                    .buttonStyle(.plain)
            } else {
                creatorRow(c, chevron: false)
            }
        }
    }

    private func creatorRow(_ c: CollabChallenge, chevron: Bool) -> some View {
        HStack(spacing: 12) {
            AvatarView(seed: c.creatorName, size: 46)
            VStack(alignment: .leading, spacing: 2) {
                Text(c.creatorName).font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Text("Posted “\(c.beatTitle)” · \(c.city)").font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
            if chevron { Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(VYBE.textTertiary) }
        }
        .padding(12).vybeCard(corner: 16)
    }

    private func briefCard(_ c: CollabChallenge) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("The brief").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.textSecondary)
            Text(c.description).font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.text).lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14).vybeCard(corner: 18)
    }

    private func tagsBlock(_ c: CollabChallenge) -> some View {
        FlowLayout(spacing: 8) {
            CollabMetaPill(icon: "guitars", text: c.genre, color: VYBE.cyan)
            CollabMetaPill(icon: "sparkles", text: c.mood, color: VYBE.purple)
            CollabMetaPill(icon: "metronome", text: "\(c.bpm) BPM", color: VYBE.textSecondary)
            CollabMetaPill(icon: "pianokeys", text: c.key, color: VYBE.textSecondary)
            ForEach(c.lookingFor, id: \.self) { role in
                CollabMetaPill(icon: "person.fill.badge.plus", text: role, color: VYBE.gold)
            }
        }
    }

    private func rewardCard(_ c: CollabChallenge) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "gift.fill").foregroundStyle(VYBE.gold)
                Text("Reward & opportunity").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
            }
            Text(c.reward).font(.system(size: 13, weight: .semibold)).foregroundStyle(VYBE.gold)
            Divider().overlay(VYBE.stroke)
            rightsRow("Proposed split", c.proposedSplit)
            rightsRow("Credit", c.creditNotes)
        }
        .padding(14)
        .background { ZStack { VYBE.card; HoloArt(seed: "reward\(c.id)").opacity(0.08) }.clipShape(.rect(cornerRadius: 18)) }
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.gold.opacity(0.25), lineWidth: 1))
    }

    private func rightsRow(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label).font(.system(size: 11, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.textSecondary).frame(width: 96, alignment: .leading)
            Text(value).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            Spacer()
        }
    }

    @ViewBuilder private func ctaBlock(_ c: CollabChallenge) -> some View {
        if isMine {
            VStack(spacing: 10) {
                NavigationLink(value: Route.collabReview(challengeId)) {
                    ctaLabel("Review \(app.submissions(for: challengeId).count) submissions", icon: "tray.full.fill", gradient: VYBE.holo)
                }
                .buttonStyle(.plain)
                if let drop = convertedDrop {
                    NavigationLink(value: Route.upcomingDrop(drop.id)) {
                        ctaLabel("View the Upcoming Drop", icon: "sparkles", gradient: VYBE.goldGrad)
                    }
                    .buttonStyle(.plain)
                }
            }
        } else if let drop = convertedDrop {
            NavigationLink(value: Route.upcomingDrop(drop.id)) {
                ctaLabel("This became an Upcoming Drop →", icon: "sparkles", gradient: VYBE.goldGrad)
            }
            .buttonStyle(.plain)
        } else if alreadySubmitted {
            ctaLabel("Submitted ✓ — you'll be notified if picked", icon: "checkmark.circle.fill", gradient: nil)
        } else {
            Button { showSubmit = true } label: {
                ctaLabel("Submit your \(c.challengeType.submitNoun)", icon: "paperplane.fill", gradient: VYBE.holo)
            }
            .buttonStyle(.plain)
        }
    }

    private func ctaLabel(_ text: String, icon: String, gradient: LinearGradient?) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 15, weight: .bold))
            Text(text).font(.system(size: 16, weight: .heavy, design: .rounded))
        }
        .foregroundStyle(gradient == nil ? VYBE.green : .white)
        .frame(maxWidth: .infinity).padding(.vertical, 15)
        .background {
            if let gradient { Capsule().fill(gradient).neonGlow(VYBE.magenta, radius: 12) }
            else { Capsule().fill(VYBE.green.opacity(0.14)).overlay(Capsule().stroke(VYBE.green.opacity(0.3), lineWidth: 1)) }
        }
    }

    private func submissionsBlock(_ c: CollabChallenge) -> some View {
        let subs = app.submissions(for: challengeId).sorted { $0.reactions > $1.reactions }
        return VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: isMine ? "Incoming submissions" : "Community submissions")
            if subs.isEmpty {
                Text("No submissions yet — be the first.")
                    .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    .frame(maxWidth: .infinity).padding(.vertical, 20)
            } else {
                ForEach(subs.prefix(isMine ? 10 : 4)) { sub in
                    CollabSubmissionRow(submission: sub, showActions: false)
                }
                if isMine {
                    NavigationLink(value: Route.collabReview(challengeId)) {
                        Text("Open review mode →").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.purple)
                            .frame(maxWidth: .infinity).padding(.vertical, 8)
                    }
                }
            }
        }
    }

    private func reportLink(_ c: CollabChallenge) -> some View {
        NavigationLink(value: Route.report(challengeId)) {
            HStack(spacing: 6) {
                Image(systemName: "flag.fill").font(.system(size: 11))
                Text("Report this challenge").font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(VYBE.textTertiary)
            .frame(maxWidth: .infinity).padding(.top, 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Submission row (shared by detail + review)

struct CollabSubmissionRow: View {
    @Environment(AppState.self) private var app
    let submission: CollabSubmission
    var showActions: Bool = false
    var onShortlist: (() -> Void)? = nil
    var onPickWinner: (() -> Void)? = nil
    var onDecline: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                HoloArt(seed: submission.previewSeed, corner: 12).frame(width: 50, height: 50)
                    .overlay(Image(systemName: "play.fill").font(.system(size: 14)).foregroundStyle(.white))
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(submission.title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(1)
                        SubmissionStatusPill(status: submission.status)
                    }
                    HStack(spacing: 6) {
                        AvatarView(seed: submission.artistName, size: 18)
                        Text(submission.artistName).font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
                        NeonTag(text: submission.submissionType.label, color: VYBE.cyan, icon: submission.submissionType.icon)
                    }
                }
                Spacer()
            }
            if !submission.note.isEmpty {
                Text(submission.note).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(3)
            }
            if !submission.lyricSnippet.isEmpty {
                Text("“\(submission.lyricSnippet)”")
                    .font(.system(size: 12, weight: .medium, design: .serif)).italic()
                    .foregroundStyle(VYBE.text.opacity(0.85))
                    .padding(10).frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.opacity(0.04), in: .rect(cornerRadius: 10))
            }
            HStack(spacing: 14) {
                Button { app.reactToSubmission(submission.id) } label: {
                    Label("\(submission.reactions)", systemImage: "flame.fill")
                        .font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.magenta)
                }
                .buttonStyle(.plain)
                Text(timeAgo(submission.minutesAgo)).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textTertiary)
                Spacer()
            }
            if showActions { actionRow }
        }
        .padding(14).vybeCard(corner: 18)
    }

    private var actionRow: some View {
        HStack(spacing: 8) {
            Button { onShortlist?() } label: {
                miniAction(submission.status == .shortlisted ? "star.fill" : "star",
                           submission.status == .shortlisted ? "Shortlisted" : "Shortlist", VYBE.gold)
            }.buttonStyle(.plain)
            Button {} label: { miniAction("bubble.left.fill", "Message", VYBE.cyan) }.buttonStyle(.plain)
            Button { onDecline?() } label: { miniAction("xmark", "Decline", VYBE.textSecondary) }.buttonStyle(.plain)
            Button { onPickWinner?() } label: {
                HStack(spacing: 5) {
                    Image(systemName: "crown.fill").font(.system(size: 12, weight: .bold))
                    Text("Pick winner").font(.system(size: 12, weight: .heavy, design: .rounded))
                }
                .foregroundStyle(.white).padding(.horizontal, 12).padding(.vertical, 9)
                .background(Capsule().fill(VYBE.holo))
            }.buttonStyle(.plain)
        }
    }

    private func timeAgo(_ minutes: Int) -> String {
        if minutes < 1 { return "just now" }
        if minutes < 60 { return "\(minutes)m ago" }
        if minutes < 1440 { return "\(minutes / 60)h ago" }
        return "\(minutes / 1440)d ago"
    }

    private func miniAction(_ icon: String, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 3) {
            Image(systemName: icon).font(.system(size: 14, weight: .bold))
            Text(label).font(.system(size: 9, weight: .bold))
        }
        .foregroundStyle(color)
        .frame(maxWidth: .infinity).padding(.vertical, 8)
        .background(.white.opacity(0.05), in: .rect(cornerRadius: 12))
    }
}

// MARK: - Submit sheet

struct SubmitToChallengeSheet: View {
    @Environment(AppState.self) private var app
    @Environment(\.dismiss) private var dismiss
    let challengeId: String
    var onSubmitted: () -> Void

    @State private var title = ""
    @State private var type: SubmissionType = .hook
    @State private var note = ""
    @State private var lyricSnippet = ""

    private var challenge: CollabChallenge? { app.collabChallenge(challengeId) }

    var body: some View {
        NavigationStack {
            ZStack {
                VYBE.bgElevated.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        if let c = challenge {
                            header(c)
                        }
                        field("Submission title") {
                            CollabTextField(text: $title, prompt: "e.g. \"hold the line\" hook")
                        }
                        field("Response type") {
                            FlowLayout(spacing: 8) {
                                ForEach(SubmissionType.allCases) { t in
                                    SelectChip(label: t.label, icon: t.icon, isOn: type == t) { type = t }
                                }
                            }
                        }
                        field("Short pitch / note") {
                            CollabTextEditor(text: $note, prompt: "Tell them what you tried and why it fits…")
                        }
                        field("Lyric snippet (optional)") {
                            CollabTextEditor(text: $lyricSnippet, prompt: "Drop a line or two…", minHeight: 70)
                        }
                        attachPlaceholder
                        submittingAs
                        CollabRightsBanner()
                    }
                    .padding(20)
                }
                .scrollIndicators(.hidden)
            }
            .navigationTitle("Submit idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() }.foregroundStyle(VYBE.textSecondary) }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Send") { send() }
                        .font(.system(size: 15, weight: .heavy)).foregroundStyle(canSend ? VYBE.magenta : VYBE.textTertiary)
                        .disabled(!canSend)
                }
            }
        }
        .presentationDetents([.large])
    }

    private var canSend: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }

    private func header(_ c: CollabChallenge) -> some View {
        HStack(spacing: 12) {
            HoloArt(seed: c.previewSeed, corner: 12).frame(width: 48, height: 48)
            VStack(alignment: .leading, spacing: 2) {
                Text("Submitting to").font(.system(size: 11, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
                Text(c.title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(2)
            }
            Spacer()
        }
        .padding(12).vybeCard(corner: 14)
    }

    private var attachPlaceholder: some View {
        HStack(spacing: 12) {
            Image(systemName: "waveform.badge.plus").font(.system(size: 20)).foregroundStyle(VYBE.cyan)
            VStack(alignment: .leading, spacing: 2) {
                Text("Attach a preview").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                Text("Mock audio placeholder — no upload in this prototype").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
            Image(systemName: "plus.circle.fill").font(.system(size: 22)).foregroundStyle(VYBE.cyan.opacity(0.6))
        }
        .padding(14)
        .background(VYBE.card, in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(VYBE.cyan.opacity(0.25), style: StrokeStyle(lineWidth: 1, dash: [5])))
    }

    private var submittingAs: some View {
        HStack(spacing: 10) {
            AvatarView(seed: "you", size: 36)
            VStack(alignment: .leading, spacing: 1) {
                Text("Submitting as You").font(.system(size: 13, weight: .bold)).foregroundStyle(VYBE.text)
                Text("Your profile is attached to this submission").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
        }
        .padding(12).vybeCard(corner: 14)
    }

    private func field<Content: View>(_ label: String, @ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.textSecondary)
            content()
        }
    }

    private func send() {
        guard canSend, let c = challenge else { return }
        let sub = CollabSubmission(
            id: "sub-you-\(UUID().uuidString.prefix(6))",
            challengeId: c.id, artistId: "", artistName: "You",
            submissionType: type, title: title.trimmingCharacters(in: .whitespaces),
            note: note.trimmingCharacters(in: .whitespaces),
            lyricSnippet: lyricSnippet.trimmingCharacters(in: .whitespaces),
            previewSeed: "you-\(c.id)-\(title)", reactions: 0, status: .submitted, minutesAgo: 0)
        app.submit(sub)
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { onSubmitted() }
    }
}

// MARK: - Small form controls

struct SelectChip: View {
    let label: String
    var icon: String? = nil
    let isOn: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let icon { Image(systemName: icon).font(.system(size: 10, weight: .bold)) }
                Text(label).font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .foregroundStyle(isOn ? .white : VYBE.textSecondary)
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background {
                if isOn { Capsule().fill(VYBE.holo) }
                else { Capsule().fill(.white.opacity(0.06)).overlay(Capsule().stroke(VYBE.stroke, lineWidth: 1)) }
            }
        }
        .buttonStyle(.plain)
    }
}

struct CollabTextField: View {
    @Binding var text: String
    let prompt: String
    var body: some View {
        TextField("", text: $text, prompt: Text(prompt).foregroundColor(VYBE.textTertiary))
            .foregroundStyle(VYBE.text)
            .padding(13)
            .background(VYBE.card, in: .rect(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(VYBE.stroke, lineWidth: 1))
    }
}

struct CollabTextEditor: View {
    @Binding var text: String
    let prompt: String
    var minHeight: CGFloat = 90
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(prompt).foregroundStyle(VYBE.textTertiary).font(.system(size: 15)).padding(.horizontal, 5).padding(.vertical, 9)
            }
            TextEditor(text: $text)
                .foregroundStyle(VYBE.text)
                .scrollContentBackground(.hidden)
                .frame(minHeight: minHeight)
        }
        .padding(8)
        .background(VYBE.card, in: .rect(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(VYBE.stroke, lineWidth: 1))
    }
}
