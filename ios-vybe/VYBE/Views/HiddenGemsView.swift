//
//  HiddenGemsView.swift
//  VYBE
//
//  Feature #17 — "Unknowns Like Your Favorites".
//  Pick famous taste anchors (or type "Sounds like ___") and the engine surfaces
//  lesser-known artists who sound like them, re-ranked so obscure acts rise.
//  Every result is an explainable card with one-tap Support + Early Discoverer bonus.
//

import SwiftUI

struct HiddenGemsView: View {
    @Environment(AppState.self) private var app
    /// When set (via "Sounds Like…"), the engine seeds with this anchor instead of the fan's follows.
    var seedAnchor: String? = nil
    @State private var activeAnchors: [String] = []
    @State private var query: String = ""
    @State private var celebration: SupportReceipt? = nil
    @State private var didInit = false

    /// Resolved similarity vectors for the currently active anchors.
    private var favorites: [SonicVector] {
        activeAnchors.compactMap { Mock.anchorVector(named: $0) }
    }

    private var results: [DiscoveryResult] {
        Discovery.hiddenGems(
            favorites: favorites,
            excluding: app.followedArtists.union(app.discoveredArtists))
    }

    /// Anchors offered in the browse picker, taste-relevant ones first.
    private var browsableAnchors: [AnchorArtist] {
        let favGenres = Set(app.taste.favoriteGenres.map { $0.lowercased() })
        return Mock.anchors.sorted { a, b in
            let aR = favGenres.contains(a.genre.lowercased())
            let bR = favGenres.contains(b.genre.lowercased())
            if aR != bR { return aR }
            return a.name < b.name
        }
    }

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    intro
                    soundsLikeSearch
                    activeAnchorsSection
                    anchorPicker
                    resultsSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Hidden Gems")
        .navigationBarTitleDisplayMode(.large)
        .vybeDestinations()
        .onAppear {
            guard !didInit else { return }
            didInit = true
            if let seed = seedAnchor, Mock.anchorVector(named: seed) != nil {
                activeAnchors = [seed]
            } else {
                activeAnchors = Discovery
                    .defaultFavorites(followed: app.followedArtists, taste: app.taste)
                    .map(\.displayName)
            }
        }
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

    // MARK: - Intro

    private var intro: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                NeonTag(text: "DISCOVERY ENGINE", color: VYBE.cyan, icon: "sparkle.magnifyingglass")
                Spacer()
            }
            Text("Unknowns like your favorites")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(VYBE.text)
            Text("We find lesser-known artists who sound like the names you love — then push the most obscure ones to the top. Support one early and earn the **Early Discoverer** bonus.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
                .lineSpacing(3)
        }
        .padding(16)
        .background {
            ZStack { VYBE.card; HoloArt(seed: "hiddengems").opacity(0.12) }
                .clipShape(.rect(cornerRadius: 20))
        }
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.cyan.opacity(0.25), lineWidth: 1))
    }

    // MARK: - "Sounds like ___" search

    private var soundsLikeSearch: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sounds like…")
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.textSecondary)
            HStack(spacing: 10) {
                Image(systemName: "waveform").foregroundStyle(VYBE.purple)
                TextField("", text: $query,
                          prompt: Text("Type an artist or genre…").foregroundColor(VYBE.textTertiary))
                    .foregroundStyle(VYBE.text)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .onSubmit(addQuery)
                Button(action: addQuery) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(resolvable ? VYBE.cyan : VYBE.textTertiary)
                }
                .buttonStyle(.plain)
                .disabled(!resolvable)
            }
            .padding(14)
            .background(VYBE.card, in: .rect(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(VYBE.stroke, lineWidth: 1))
        }
    }

    private var resolvable: Bool {
        !query.trimmingCharacters(in: .whitespaces).isEmpty && Mock.anchorVector(named: query) != nil
    }

    private func addQuery() {
        let term = query.trimmingCharacters(in: .whitespaces)
        guard !term.isEmpty, let v = Mock.anchorVector(named: term) else { return }
        if !activeAnchors.contains(where: { $0.lowercased() == v.displayName.lowercased() }) {
            withAnimation(.snappy) { activeAnchors.append(v.displayName) }
            app.haptic(.light)
        }
        query = ""
    }

    // MARK: - Active anchors (the favorites driving results)

    @ViewBuilder private var activeAnchorsSection: some View {
        if !activeAnchors.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Matching against")
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundStyle(VYBE.textSecondary)
                FlowLayout(spacing: 8) {
                    ForEach(activeAnchors, id: \.self) { name in
                        Button {
                            withAnimation(.snappy) { activeAnchors.removeAll { $0 == name } }
                            app.haptic(.light)
                        } label: {
                            HStack(spacing: 6) {
                                Text(name).font(.system(size: 13, weight: .bold, design: .rounded))
                                Image(systemName: "xmark.circle.fill").font(.system(size: 12))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Capsule().fill(VYBE.holo).neonGlow(VYBE.purple, radius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Anchor picker

    private var anchorPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Add favorites")
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.textSecondary)
            FlowLayout(spacing: 8) {
                ForEach(browsableAnchors) { anchor in
                    let on = activeAnchors.contains { $0.lowercased() == anchor.name.lowercased() }
                    Button {
                        withAnimation(.snappy) {
                            if on { activeAnchors.removeAll { $0.lowercased() == anchor.name.lowercased() } }
                            else { activeAnchors.append(anchor.name) }
                        }
                        app.haptic(.light)
                    } label: {
                        Text(anchor.name)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(on ? .white : VYBE.textSecondary)
                            .padding(.horizontal, 12).padding(.vertical, 7)
                            .background {
                                if on { Capsule().fill(VYBE.purple.opacity(0.9)) }
                                else { Capsule().fill(.white.opacity(0.06)).overlay(Capsule().stroke(VYBE.stroke, lineWidth: 1)) }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Results

    @ViewBuilder private var resultsSection: some View {
        if favorites.isEmpty {
            emptyState
        } else {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Text("💎 Hidden Gems For You")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundStyle(VYBE.text)
                    Spacer()
                    Text("\(results.count) found")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(VYBE.textSecondary)
                }
                if results.isEmpty {
                    Text("No close matches yet — try adding another favorite above.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(VYBE.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 30)
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(results) { result in
                            DiscoveryGemCard(result: result) {
                                celebration = app.supportDiscovery(result.artist)
                            }
                        }
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "sparkle.magnifyingglass")
                .font(.system(size: 34)).foregroundStyle(VYBE.textTertiary)
            Text("Add a favorite artist to discover hidden gems")
                .font(.system(size: 15, weight: .bold)).foregroundStyle(VYBE.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 50)
    }
}

// MARK: - Discovery Gem Card

struct DiscoveryGemCard: View {
    @Environment(AppState.self) private var app
    let result: DiscoveryResult
    let onSupport: () -> Void
    @State private var showWhy = false

    private var artist: Artist { result.artist }
    private var discovered: Bool { app.discoveredArtists.contains(artist.id) }
    private var earningsRatio: Int {
        max(1, artist.fanFundedMonthlyUSD / max(artist.streamingEquivUSD, 1))
    }
    private var tierColor: Color {
        switch artist.popularityTier {
        case "undiscovered": return VYBE.green
        case "underground": return VYBE.cyan
        default: return VYBE.gold
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // "If you love X" + wildcard flag
            HStack(spacing: 8) {
                HStack(spacing: 5) {
                    Image(systemName: "sparkles").font(.system(size: 10, weight: .bold))
                    Text("If you love ") .font(.system(size: 12, weight: .semibold))
                        + Text(result.anchorName).font(.system(size: 12, weight: .heavy, design: .rounded))
                }
                .foregroundStyle(VYBE.purple)
                Spacer()
                if result.isWildcard {
                    NeonTag(text: "WILDCARD", color: VYBE.gold, icon: "dice.fill")
                }
            }

            // Artist header → profile
            NavigationLink(value: Route.artist(artist.id)) {
                HStack(spacing: 12) {
                    AvatarView(seed: artist.name, size: 54)
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 4) {
                            Text(artist.name).font(.system(size: 16, weight: .heavy, design: .rounded))
                                .foregroundStyle(VYBE.text).lineLimit(1)
                            if artist.isVerified { VerifiedBadge(size: 12) }
                        }
                        Text("\(artist.monthlyListeners.compact) listeners · \(artist.city)")
                            .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    }
                    Spacer()
                    VStack(spacing: 2) {
                        Text("\(Int((result.similarity * 100).rounded()))%")
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .foregroundStyle(VYBE.cyan)
                        Text("match").font(.system(size: 9, weight: .semibold)).foregroundStyle(VYBE.textTertiary)
                    }
                }
            }
            .buttonStyle(.plain)

            // Sonic tags + tier
            FlowLayout(spacing: 6) {
                Text(artist.popularityTier.uppercased())
                    .font(.system(size: 9, weight: .heavy, design: .rounded)).tracking(0.5)
                    .foregroundStyle(tierColor)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(tierColor.opacity(0.16), in: .capsule)
                ForEach(artist.sonicTags.prefix(3), id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(VYBE.textSecondary)
                        .padding(.horizontal, 9).padding(.vertical, 4)
                        .background(.white.opacity(0.05), in: .capsule)
                }
            }

            // Earnings transparency signal
            HStack(spacing: 6) {
                Image(systemName: "dollarsign.circle.fill").font(.system(size: 11)).foregroundStyle(VYBE.green)
                Text("Fan-funded $\(artist.fanFundedMonthlyUSD.compact)/mo")
                    .font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.green)
                Text("· \(earningsRatio)x vs streaming")
                    .font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.textSecondary)
            }

            if let signal = result.socialSignal {
                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill").font(.system(size: 10)).foregroundStyle(VYBE.magenta)
                    Text(signal).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(2)
                }
            }

            // Why you're seeing this
            Button {
                withAnimation(.snappy) { showWhy.toggle() }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "questionmark.circle")
                    Text("Why you're seeing this").font(.system(size: 11, weight: .bold))
                    Image(systemName: showWhy ? "chevron.up" : "chevron.down").font(.system(size: 9))
                }
                .foregroundStyle(VYBE.textTertiary)
            }
            .buttonStyle(.plain)

            if showWhy {
                Text(whyText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(VYBE.textSecondary)
                    .lineSpacing(3)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // Support
            Button(action: { if !discovered { onSupport() } }) {
                HStack(spacing: 7) {
                    Image(systemName: discovered ? "checkmark.circle.fill" : "heart.fill")
                        .font(.system(size: 14, weight: .bold))
                    Text(discovered ? "Discovered by you ✓" : "Support · Early Discoverer bonus")
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                }
                .foregroundStyle(discovered ? VYBE.green : .white)
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background {
                    if discovered { Capsule().fill(VYBE.green.opacity(0.15)) }
                    else { Capsule().fill(VYBE.holo).neonGlow(VYBE.magenta, radius: 10) }
                }
            }
            .buttonStyle(.plain)
            .disabled(discovered)
        }
        .padding(16)
        .background {
            ZStack {
                VYBE.card
                if result.isWildcard { HoloArt(seed: "wild\(artist.id)").opacity(0.08) }
            }
            .clipShape(.rect(cornerRadius: 20))
        }
        .overlay(RoundedRectangle(cornerRadius: 20)
            .stroke(result.isWildcard ? VYBE.gold.opacity(0.3) : VYBE.stroke, lineWidth: 1))
    }

    private var whyText: String {
        if result.isWildcard {
            return "Outside your usual genres — a taste-expanding pick with only \(artist.monthlyListeners.compact) listeners. Sometimes the best discoveries come from left field."
        }
        let overlap = artist.sonicTags.prefix(2).joined(separator: " & ")
        return "Shares \(artist.genre)'s DNA with \(result.anchorName) — \(overlap) textures at similar energy. With just \(artist.monthlyListeners.compact) listeners, you'd be in early."
    }
}

// MARK: - Flow layout for wrapping chips

/// Simple left-to-right wrapping layout (iOS 16+).
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let maxW = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowH: CGFloat = 0
        for s in subviews {
            let sz = s.sizeThatFits(.unspecified)
            if x > 0 && x + sz.width > maxW { x = 0; y += rowH + spacing; rowH = 0 }
            x += sz.width + spacing
            rowH = max(rowH, sz.height)
        }
        return CGSize(width: proposal.width ?? x, height: y + rowH)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let maxW = bounds.width
        var x: CGFloat = bounds.minX, y: CGFloat = bounds.minY, rowH: CGFloat = 0
        for s in subviews {
            let sz = s.sizeThatFits(.unspecified)
            if x > bounds.minX && x + sz.width > bounds.minX + maxW { x = bounds.minX; y += rowH + spacing; rowH = 0 }
            s.place(at: CGPoint(x: x, y: y), anchor: .topLeading, proposal: ProposedViewSize(sz))
            x += sz.width + spacing
            rowH = max(rowH, sz.height)
        }
    }
}
