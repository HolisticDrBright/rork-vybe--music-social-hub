//
//  SubmissionReviewView.swift
//  VYBE
//
//  Creator review mode: play submissions, shortlist, react, decline, and pick a
//  winner — which turns the challenge into an Upcoming Drop.
//

import SwiftUI

struct SubmissionReviewView: View {
    @Environment(AppState.self) private var app
    let challengeId: String
    @State private var filter = "All"
    @State private var startedDrop: UpcomingDrop? = nil

    private let filters = ["All", "Shortlisted"]
    private var challenge: CollabChallenge? { app.collabChallenge(challengeId) }
    private var converted: Bool { challenge?.status == .convertedToDrop }

    private var subs: [CollabSubmission] {
        let all = app.submissions(for: challengeId)
        let filtered = filter == "Shortlisted"
            ? all.filter { $0.status == .shortlisted || $0.status == .selected }
            : all
        return filtered.sorted { rankOrder($0) > rankOrder($1) }
    }

    private func rankOrder(_ s: CollabSubmission) -> Int {
        let base: Int
        switch s.status {
        case .selected: base = 4_000_000
        case .shortlisted: base = 3_000_000
        case .submitted: base = 1_000_000
        case .declined: base = 0
        }
        return base + s.reactions
    }

    var body: some View {
        ZStack {
            VYBEBackground()
            if let c = challenge {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        header(c)
                        if converted, let drop = app.upcomingDrops.first(where: { $0.originChallengeId == challengeId }) {
                            convertedBanner(drop)
                        }
                        ChipRow(items: filters, selection: $filter).padding(.horizontal, -20)
                        CollabRightsBanner()
                        LazyVStack(spacing: 14) {
                            ForEach(subs) { sub in
                                CollabSubmissionRow(
                                    submission: sub,
                                    showActions: !converted,
                                    onShortlist: { app.toggleShortlist(sub.id) },
                                    onPickWinner: { pickWinner(sub, c) },
                                    onDecline: { app.declineSubmission(sub.id) })
                            }
                        }
                    }
                    .padding(.horizontal, 20).padding(.vertical, 16)
                }
                .scrollIndicators(.hidden)
            } else {
                CollabEmptyState(text: "This challenge is no longer available.", icon: "tray.full.fill")
            }
        }
        .navigationTitle("Review Submissions")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $startedDrop) { drop in WinnerStartedSheet(drop: drop).environment(app) }
        .vybeDestinations()
    }

    private func pickWinner(_ sub: CollabSubmission, _ c: CollabChallenge) {
        let drop = app.pickWinner(submissionId: sub.id, challengeId: c.id)
        startedDrop = drop
    }

    private func header(_ c: CollabChallenge) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(c.title).font(.system(size: 20, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
            HStack(spacing: 10) {
                CollabStatusPill(status: c.status)
                Text("\(app.submissions(for: challengeId).count) submissions")
                    .font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func convertedBanner(_ drop: UpcomingDrop) -> some View {
        NavigationLink(value: Route.upcomingDrop(drop.id)) {
            HStack(spacing: 12) {
                Image(systemName: "sparkles").font(.system(size: 18)).foregroundStyle(.white)
                    .frame(width: 42, height: 42).background(VYBE.holo, in: .circle)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Winner picked — collab started!").font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Text(drop.artistNames.joined(separator: " × ")).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.cyan)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
            }
            .padding(14)
            .background { ZStack { VYBE.card; HoloArt(seed: "won\(drop.id)").opacity(0.12) }.clipShape(.rect(cornerRadius: 18)) }
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.cyan.opacity(0.35), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Winner "moment" sheet

struct WinnerStartedSheet: View {
    @Environment(\.dismiss) private var dismiss
    let drop: UpcomingDrop
    @State private var appeared = false

    var body: some View {
        NavigationStack {
            ZStack {
                VYBE.bg.ignoresSafeArea()
                RadialGradient(colors: [VYBE.magenta.opacity(0.3), .clear], center: .top, startRadius: 5, endRadius: 420).ignoresSafeArea()
                VStack(spacing: 22) {
                    Spacer()
                    ZStack {
                        Circle().fill(VYBE.holo).frame(width: 110, height: 110).neonGlow(VYBE.magenta, radius: 26)
                            .scaleEffect(appeared ? 1 : 0.6)
                        Image(systemName: "crown.fill").font(.system(size: 46, weight: .bold)).foregroundStyle(.white)
                    }
                    VStack(spacing: 10) {
                        Text("Collab started 🎉")
                            .font(.system(size: 26, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                        Text("\(drop.artistNames.joined(separator: " + ")) are turning this into an Upcoming Drop.")
                            .font(.system(size: 15, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                            .multilineTextAlignment(.center).padding(.horizontal, 30).lineSpacing(3)
                    }
                    NeonTag(text: "Born on VYBE", color: VYBE.cyan, icon: "sparkles")
                    Spacer()
                    NavigationLink(value: Route.upcomingDrop(drop.id)) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles").font(.system(size: 15, weight: .bold))
                            Text("View the Upcoming Drop").font(.system(size: 16, weight: .heavy, design: .rounded))
                        }
                        .foregroundStyle(.white).frame(maxWidth: .infinity).padding(.vertical, 15)
                        .background(VYBE.holo, in: .capsule).neonGlow(VYBE.magenta, radius: 14)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 24)
                    Button("Back to review") { dismiss() }
                        .font(.system(size: 14, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
                        .padding(.bottom, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() }.foregroundStyle(VYBE.text) } }
            .vybeDestinations()
        }
        .onAppear { withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { appeared = true } }
    }
}
