//
//  SleeveBuilderView.swift
//  VYBE
//
//  Artist-side mock creation flow: choose a sleeve era, add lyrics, liner notes,
//  credits, attach a video placeholder, preview the sleeve, and publish a drop.
//  Prototype — publishes in-session (no real persistence).
//

import SwiftUI

struct SleeveBuilderView: View {
    @Environment(AppState.self) private var app

    @State private var era: SleeveEra = .cd90s
    @State private var title = ""
    @State private var lyrics = ""
    @State private var linerNotes = ""
    @State private var thankYous = ""
    @State private var producedBy = ""
    @State private var featuring = ""
    @State private var videoAttached = false
    @State private var publishedId: String? = nil

    private var artist: Artist { Mock.artist(app.collabArtistId) }

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    intro
                    livePreview
                    Group {
                        field("Sleeve style") {
                            FlowLayout(spacing: 8) {
                                ForEach(SleeveEra.allCases) { e in
                                    SelectChip(label: e.label, icon: e.icon, isOn: era == e) { era = e }
                                }
                            }
                        }
                        field("Drop / song title") { CollabTextField(text: $title, prompt: "e.g. Midnight Signal") }
                        field("Lyrics (one line per row · fictional only)") {
                            CollabTextEditor(text: $lyrics, prompt: "Write fictional lyrics for your VYBE artist…", minHeight: 100)
                        }
                    }
                    Group {
                        field("Liner notes") { CollabTextEditor(text: $linerNotes, prompt: "The story of the recording…", minHeight: 70) }
                        field("Thank yous") { CollabTextField(text: $thankYous, prompt: "Who do you want to thank?") }
                        twoUp(
                            field("Produced by") { CollabTextField(text: $producedBy, prompt: "Producer") },
                            field("Featuring") { CollabTextField(text: $featuring, prompt: "Feature (optional)") }
                        )
                    }
                    Group {
                        videoToggle
                        rightsNote
                        publishButton
                    }
                }
                .padding(20).padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Sleeve Builder")
        .navigationBarTitleDisplayMode(.inline)
        .vybeDestinations()
    }

    private var intro: some View {
        HStack(spacing: 10) {
            Image(systemName: "rectangle.stack.badge.plus").font(.system(size: 18)).foregroundStyle(.white)
                .frame(width: 42, height: 42).background(VYBE.holo, in: .circle)
            VStack(alignment: .leading, spacing: 2) {
                Text("Build a Drop Sleeve").font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Text("Give your music art, lore, and a world.").font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
        }
    }

    private var livePreview: some View {
        VStack(spacing: 10) {
            Text("LIVE PREVIEW").font(.system(size: 10, weight: .heavy, design: .rounded)).tracking(2).foregroundStyle(era.accents[0])
            SleeveCoverCard(sleeve: draftSleeve, size: 220)
            Text(lyrics.isEmpty ? "Add lyrics to see the excerpt" : "“\(firstLine)”")
                .font(.system(size: 12, weight: .medium, design: .serif)).italic().foregroundStyle(VYBE.textSecondary)
                .lineLimit(1).padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background { ZStack { VYBE.card; HoloArt(seed: "builderbg").opacity(0.08) }.clipShape(.rect(cornerRadius: 22)) }
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(era.accents[0].opacity(0.3), lineWidth: 1))
    }

    private var videoToggle: some View {
        HStack(spacing: 12) {
            Image(systemName: "play.tv.fill").font(.system(size: 18)).foregroundStyle(VYBE.magenta)
            VStack(alignment: .leading, spacing: 2) {
                Text("Attach a music video").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                Text("Mock placeholder — links to VYBE TV").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
            Toggle("", isOn: $videoAttached).labelsHidden().tint(VYBE.magenta)
        }
        .padding(14).vybeCard(corner: 16)
    }

    private var rightsNote: some View {
        HStack(spacing: 10) {
            Image(systemName: "doc.text.magnifyingglass").font(.system(size: 14)).foregroundStyle(VYBE.gold)
            Text("Use only original or fictional lyrics. Confirm ownership of art, audio, and video before release.")
                .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(2)
        }
        .padding(12)
        .background(VYBE.gold.opacity(0.08), in: .rect(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(VYBE.gold.opacity(0.25), lineWidth: 1))
    }

    @ViewBuilder private var publishButton: some View {
        if let id = publishedId {
            VStack(spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill").foregroundStyle(VYBE.green)
                    Text("Sleeve published!").font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                }
                NavigationLink(value: Route.sleeve(id)) {
                    Label("Open your sleeve", systemImage: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                        .font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(LinearGradient(colors: era.accents, startPoint: .leading, endPoint: .trailing), in: .capsule)
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .background(VYBE.green.opacity(0.08), in: .rect(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.green.opacity(0.3), lineWidth: 1))
        } else {
            Button { publish() } label: {
                Label("Publish Drop Sleeve", systemImage: "sparkles")
                    .font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 15)
                    .background(canPublish ? AnyShapeStyle(VYBE.holo) : AnyShapeStyle(Color.white.opacity(0.1)), in: .capsule)
                    .neonGlow(canPublish ? VYBE.magenta : .clear, radius: 12)
            }
            .buttonStyle(.plain)
            .disabled(!canPublish)
        }
    }

    private var canPublish: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }
    private var firstLine: String { lyrics.split(separator: "\n").map(String.init).first ?? "" }

    private var lyricLines: [String] { lyrics.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty } }

    private var credits: [CreditLine] {
        var c: [CreditLine] = [CreditLine(id: "w", role: "Written by", name: artist.name)]
        if !producedBy.trimmingCharacters(in: .whitespaces).isEmpty { c.append(CreditLine(id: "p", role: "Produced by", name: producedBy)) }
        if !featuring.trimmingCharacters(in: .whitespaces).isEmpty { c.append(CreditLine(id: "f", role: "Featuring", name: featuring)) }
        return c
    }

    /// The sleeve as currently configured (used for the live preview).
    private var draftSleeve: SongSleeve {
        sleeve(id: "draft-preview")
    }

    private func sleeve(id: String) -> SongSleeve {
        let displayTitle = title.trimmingCharacters(in: .whitespaces).isEmpty ? "Untitled Drop" : title
        return SongSleeve(
            id: id, songId: "", artistId: artist.id, title: displayTitle, artistName: artist.name,
            era: era, coverArtSeed: displayTitle + " sleeve", tagline: era.tagline,
            lyricExcerpt: lyricLines.first ?? "(add lyrics)",
            mockLyrics: lyricLines.isEmpty ? [] : [LyricBlock(id: "l1", label: "Chorus", lines: lyricLines)],
            linerNotes: linerNotes.isEmpty ? "Liner notes go here — the story of how this drop came together." : linerNotes,
            thankYous: thankYous.isEmpty ? "Thank yous go here." : thankYous,
            behindTheSong: BehindSongNote(id: "b1", heading: "Behind the song", body: "Tell the story of this drop here."),
            credits: credits,
            visualSymbols: ["sparkles", "music.note", "photo.artframe", "heart.fill"],
            insidePanels: [SleevePanel(id: "ip1", kind: "art", title: "Inside art", artSeed: displayTitle + " inside", caption: "Your inside-art panel.")],
            videoId: nil,
            supporterBonus: "Supporters unlock bonus content for this drop (placeholder).",
            fanReactions: ["can't wait for this one", "the art is unreal", "opening this on day one"])
    }

    private func publish() {
        guard canPublish else { return }
        let id = "sl-custom-\(UUID().uuidString.prefix(6))"
        app.publishSleeve(sleeve(id: id))
        withAnimation(.snappy) { publishedId = id }
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
}
