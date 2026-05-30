//
//  CreateCollabChallengeView.swift
//  VYBE
//
//  Polished mock flow for an artist to open a collaboration challenge.
//

import SwiftUI

struct CreateCollabChallengeView: View {
    @Environment(AppState.self) private var app
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var beatTitle = ""
    @State private var type: CollabChallengeType = .bestHook
    @State private var genre = ""
    @State private var mood = ""
    @State private var bpm: Double = 92
    @State private var key = "A minor"
    @State private var city = ""
    @State private var roles: Set<CollabRoleNeeded> = []
    @State private var deadline = "5 days left"
    @State private var reward = ""
    @State private var split = "50/50 (placeholder)"
    @State private var creditNotes = "Featured credit. Confirm ownership before release."
    @State private var visibility: CollabVisibility = .publicAll

    private let keys = ["A minor", "C major", "D minor", "E minor", "F minor", "G minor", "A major", "C minor", "D major", "G major", "B minor"]
    private let deadlines = ["3 days left", "5 days left", "1 week left", "2 weeks left", "Open-ended"]

    private var canPost: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && !beatTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VYBE.bgElevated.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Group {
                            intro
                            attachPlaceholder
                            field("Challenge title") { CollabTextField(text: $title, prompt: "e.g. Best Hook on \"Midnight Signal\"") }
                            field("Beat / song idea title") { CollabTextField(text: $beatTitle, prompt: "e.g. Midnight Signal") }
                            field("Challenge type") {
                                FlowLayout(spacing: 8) {
                                    ForEach(CollabChallengeType.allCases) { t in
                                        SelectChip(label: t.label, icon: t.icon, isOn: type == t) { type = t }
                                    }
                                }
                            }
                        }
                        Group {
                            twoUp(
                                field("Genre") { CollabTextField(text: $genre, prompt: "Hyperpop") },
                                field("Mood") { CollabTextField(text: $mood, prompt: "Cinematic / late-night") }
                            )
                            bpmField
                            twoUp(
                                field("Key") { keyMenu },
                                field("City / scene") { CollabTextField(text: $city, prompt: "Los Angeles") }
                            )
                        }
                        Group {
                            field("What I'm looking for") {
                                FlowLayout(spacing: 8) {
                                    ForEach(CollabRoleNeeded.allCases) { role in
                                        SelectChip(label: role.label, isOn: roles.contains(role)) { toggle(role) }
                                    }
                                }
                            }
                            field("Deadline") { deadlineMenu }
                            field("Reward / opportunity") { CollabTextEditor(text: $reward, prompt: "Featured credit + split placeholder + launch push on VYBE", minHeight: 64) }
                        }
                        Group {
                            twoUp(
                                field("Proposed split") { CollabTextField(text: $split, prompt: "50/50 (placeholder)") },
                                field("Visibility") { visibilityChips }
                            )
                            field("Credit notes") { CollabTextField(text: $creditNotes, prompt: "Featured credit. Confirm ownership.") }
                            CollabRightsBanner()
                        }
                    }
                    .padding(20)
                }
                .scrollIndicators(.hidden)
            }
            .navigationTitle("Create Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() }.foregroundStyle(VYBE.textSecondary) }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Post") { post() }
                        .font(.system(size: 15, weight: .heavy)).foregroundStyle(canPost ? VYBE.magenta : VYBE.textTertiary)
                        .disabled(!canPost)
                }
            }
        }
        .presentationDetents([.large])
    }

    private var intro: some View {
        HStack(spacing: 10) {
            Image(systemName: "person.2.wave.2.fill").font(.system(size: 18)).foregroundStyle(.white)
                .frame(width: 42, height: 42).background(VYBE.holo, in: .circle)
            VStack(alignment: .leading, spacing: 2) {
                Text("Open a collaboration").font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Text("Post your beat or idea and let artists submit.").font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
        }
    }

    private var attachPlaceholder: some View {
        HStack(spacing: 12) {
            Image(systemName: "waveform.badge.plus").font(.system(size: 20)).foregroundStyle(VYBE.cyan)
            VStack(alignment: .leading, spacing: 2) {
                Text("Attach preview clip").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                Text("Mock audio placeholder — no upload in this prototype").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
            Image(systemName: "plus.circle.fill").font(.system(size: 22)).foregroundStyle(VYBE.cyan.opacity(0.6))
        }
        .padding(14)
        .background(VYBE.card, in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(VYBE.cyan.opacity(0.25), style: StrokeStyle(lineWidth: 1, dash: [5])))
    }

    private var bpmField: some View {
        field("BPM · \(Int(bpm))") {
            Slider(value: $bpm, in: 60...200, step: 1).tint(VYBE.magenta)
        }
    }

    private var keyMenu: some View {
        Menu {
            ForEach(keys, id: \.self) { k in Button(k) { key = k } }
        } label: {
            menuLabel(key)
        }
    }

    private var deadlineMenu: some View {
        Menu {
            ForEach(deadlines, id: \.self) { d in Button(d) { deadline = d } }
        } label: {
            menuLabel(deadline)
        }
    }

    private func menuLabel(_ text: String) -> some View {
        HStack {
            Text(text).font(.system(size: 15, weight: .semibold)).foregroundStyle(VYBE.text)
            Spacer()
            Image(systemName: "chevron.up.chevron.down").font(.system(size: 12)).foregroundStyle(VYBE.textSecondary)
        }
        .padding(13)
        .background(VYBE.card, in: .rect(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(VYBE.stroke, lineWidth: 1))
    }

    private var visibilityChips: some View {
        HStack(spacing: 6) {
            ForEach(CollabVisibility.allCases) { v in
                SelectChip(label: v.label, icon: v.icon, isOn: visibility == v) { visibility = v }
            }
        }
    }

    private func toggle(_ role: CollabRoleNeeded) {
        if roles.contains(role) { roles.remove(role) } else { roles.insert(role) }
    }

    private func twoUp<A: View, B: View>(_ a: A, _ b: B) -> some View {
        HStack(alignment: .top, spacing: 12) {
            a.frame(maxWidth: .infinity, alignment: .leading)
            b.frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func field<Content: View>(_ label: String, @ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.textSecondary)
            content()
        }
    }

    private func post() {
        guard canPost else { return }
        let creator = Mock.artist(app.collabArtistId)
        let lookingFor = roles.isEmpty ? ["Open to all"] : CollabRoleNeeded.allCases.filter { roles.contains($0) }.map(\.label)
        let challenge = CollabChallenge(
            id: "ch-\(UUID().uuidString.prefix(6))",
            creatorArtistId: creator.id, creatorName: creator.name,
            title: title.trimmingCharacters(in: .whitespaces),
            beatTitle: beatTitle.trimmingCharacters(in: .whitespaces),
            challengeType: type,
            genre: genre.isEmpty ? creator.genre : genre,
            mood: mood.isEmpty ? "Open" : mood,
            bpm: Int(bpm),
            key: key,
            city: city.isEmpty ? creator.city : city,
            description: "\(type.label) challenge on “\(beatTitle.trimmingCharacters(in: .whitespaces))”. Looking for \(lookingFor.joined(separator: ", ").lowercased()). Submit your best idea.",
            lookingFor: lookingFor,
            reward: reward.isEmpty ? "Featured credit + split placeholder + launch push on VYBE" : reward,
            proposedSplit: split,
            deadlineText: deadline,
            status: .open,
            submissionCount: 0,
            previewSeed: beatTitle.isEmpty ? "new-challenge" : beatTitle,
            visibility: visibility,
            creditNotes: creditNotes)
        app.createChallenge(challenge)
        dismiss()
    }
}
