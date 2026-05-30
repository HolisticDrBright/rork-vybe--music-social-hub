//
//  SupportSystem.swift
//  VYBE
//
//  Reusable support → receipt economics, plus the Fan/Artist "impact" models that
//  power the profile and artist dashboard. Every support action across the app
//  flows through `SupportEconomics`, producing a consistent, transparent
//  "money moment" and a logged `SupportEvent`.
//

import Foundation

// MARK: - Support actions

/// Every way a fan can support an artist. Associated values carry dollar/point amounts.
enum SupportAction: Hashable {
    case preview            // streamed a preview
    case save               // saved a song
    case share              // shared externally
    case boost              // amplified reach
    case tip(Int)           // tipped N dollars
    case rsvp               // RSVP'd a show
    case buyDrop(Int)       // bought an exclusive drop for N dollars
    case challenge(Int)     // completed a challenge worth N points
    case discover           // discovered + supported via Hidden Gems (Early Discoverer)

    var verb: String {
        switch self {
        case .preview: return "Streamed a preview"
        case .save: return "Saved a track"
        case .share: return "Shared"
        case .boost: return "Boosted"
        case .tip(let a): return "Tipped $\(a)"
        case .rsvp: return "RSVP'd to a show"
        case .buyDrop(let a): return "Bought a $\(a) drop"
        case .challenge: return "Completed a challenge"
        case .discover: return "Discovered early"
        }
    }
}

/// The computed result of a support action.
struct SupportOutcome {
    var artistDollars: Double
    var streams: Int
    var score: Int
    var viralBump: Int
}

enum SupportEconomics {
    /// Spotify's oft-cited per-stream payout.
    static let streamRate = 0.004

    static func outcome(for action: SupportAction) -> SupportOutcome {
        switch action {
        case .preview:           return SupportOutcome(artistDollars: 0.02, streams: 1, score: 20, viralBump: 0)
        case .save:              return SupportOutcome(artistDollars: 0.10, streams: 2, score: 50, viralBump: 0)
        case .share:             return SupportOutcome(artistDollars: 3.80, streams: 10, score: 420, viralBump: 2)
        case .boost:             return SupportOutcome(artistDollars: 6.20, streams: 18, score: 300, viralBump: 3)
        case .tip(let amt):      return SupportOutcome(artistDollars: Double(amt) * 0.9, streams: 0, score: amt * 100, viralBump: 1)
        case .rsvp:              return SupportOutcome(artistDollars: 8.0, streams: 0, score: 300, viralBump: 1)
        case .buyDrop(let amt):  return SupportOutcome(artistDollars: Double(amt) * 0.9, streams: 0, score: amt * 120, viralBump: 1)
        case .challenge(let r):  return SupportOutcome(artistDollars: 1.5, streams: 6, score: r, viralBump: 1)
        case .discover:          return SupportOutcome(artistDollars: 4.0, streams: 8, score: 200, viralBump: 2)
        }
    }

    static func multiplier(dollars: Double, streamingEquiv: Double) -> Int {
        let denom = max(streamingEquiv, streamRate)
        return min(9_999, max(1, Int((dollars / denom).rounded())))
    }

    /// Build the full, shareable receipt for an action.
    static func makeReceipt(artist: Artist,
                            action: SupportAction,
                            outcome: SupportOutcome,
                            newRank: Int,
                            songTitle: String?,
                            badge: String?) -> SupportReceipt {
        let streamingEquiv = Double(outcome.streams) * streamRate
        let mult = multiplier(dollars: outcome.artistDollars, streamingEquiv: streamingEquiv)
        let money = String(format: "$%.2f", outcome.artistDollars)
        let streamMoney = String(format: "$%.2f", streamingEquiv)

        let actionText: String = {
            if let songTitle, case .share = action { return "Shared \"\(songTitle)\"" }
            if let songTitle, case .preview = action { return "Streamed \"\(songTitle)\"" }
            if let songTitle, case .save = action { return "Saved \"\(songTitle)\"" }
            return action.verb
        }()

        let headline = "You helped \(artist.name) earn \(money). Streaming would have paid about \(streamMoney). You earned +\(outcome.score) VYBE Score and moved to #\(newRank) on \(artist.name)'s fan board."

        return SupportReceipt(
            id: UUID().uuidString,
            artistName: artist.name,
            artistHandle: artist.handle,
            amountDriven: max(1, Int(outcome.artistDollars.rounded())),
            action: actionText,
            vybeScoreEarned: outcome.score,
            rankUpdated: "Now #\(newRank) on \(artist.name)'s fan board",
            streamingComparison: "\(mult)x what streaming would've paid",
            timestamp: Date(),
            receiptSeed: "receipt-\(artist.id)-\(Int(Date().timeIntervalSince1970))",
            artistEarnedUSD: outcome.artistDollars,
            streamingEquivUSD: streamingEquiv,
            multiplier: mult,
            fanRank: newRank,
            badgeProgress: badge,
            headline: headline)
    }
}

/// A single logged support action, used by the artist dashboard feed.
struct SupportEvent: Identifiable, Hashable {
    let id: String
    var artistId: String
    var artistName: String
    var fanName: String
    var verb: String
    var dollars: Double
    var score: Int
    var minutesAgo: Int

    var dollarsLabel: String { String(format: "$%.2f", dollars) }
}

// MARK: - Fan impact (profile)

/// Aggregated view of a fan's influence — makes "supporting early = social capital" tangible.
struct FanImpact {
    var earningsDriven: Int
    var artistsFunded: Int
    var discoveredCount: Int
    var earlyWins: [Artist]
    var sceneInfluenceLabel: String
    var sceneInfluencePercent: Double
    var rankByArtist: [(artist: Artist, rank: Int)]

    static func build(_ app: AppState) -> FanImpact {
        // Early Discoverer wins = discovered artists who are underground/rising.
        let discovered = Mock.artists.filter { app.discoveredArtists.contains($0.id) }
        let earlyWins = discovered.filter { $0.isUndergroundRising || $0.popularityTier != "established" }

        // Scene influence from viral reach + sharing.
        let percent = min(1.0, Double(app.viralImpact) / 100.0 * 0.7 + min(1.0, Double(app.shareCount) / 500.0) * 0.3)
        let topPct = max(1, Int((1.0 - percent) * 18) + 1)
        let city = app.taste.city.isEmpty ? "your scene" : app.taste.city
        let label = "Top \(topPct)% tastemaker in \(city)"

        // Fan rank per artist (funded + any live ranks).
        var ranks: [String: (Artist, Int)] = [:]
        for fa in Mock.fundedArtists {
            ranks[fa.artistId] = (Mock.artist(fa.artistId), fa.rank)
        }
        for (artistId, rank) in app.fanRankByArtist {
            ranks[artistId] = (Mock.artist(artistId), rank)
        }
        let rankByArtist = ranks.values
            .map { (artist: $0.0, rank: $0.1) }
            .sorted { $0.rank < $1.rank }

        let fundedCount = Set(Mock.fundedArtists.map(\.artistId)).union(app.discoveredArtists).count

        return FanImpact(
            earningsDriven: app.totalEarningsDriven,
            artistsFunded: fundedCount,
            discoveredCount: app.discoveredArtists.count,
            earlyWins: earlyWins,
            sceneInfluenceLabel: label,
            sceneInfluencePercent: percent,
            rankByArtist: Array(rankByArtist.prefix(6)))
    }
}

// MARK: - Artist impact (dashboard)

/// Aggregated view of an artist's fan economy — the "growth engine" surface.
struct ArtistImpact {
    var artist: Artist
    var earnings: ArtistEarnings
    var multiplier: Int
    var topFans: [TopFan]
    var recentEvents: [SupportEvent]
    var risingTopFan: TopFan
    var cityHeat: [CityHeat]

    struct TopFan: Identifiable, Hashable {
        var id: String { fan.id }
        var fan: LeaderFan
        var revenueDriven: Int
        var streamsDriven: Int
        var isYou: Bool
    }
    struct CityHeat: Identifiable, Hashable {
        var id: String { city }
        var city: String
        var value: Double
        var fans: String
    }

    static func build(artistId: String, app: AppState) -> ArtistImpact {
        let artist = Mock.artist(artistId)
        let earnings = Mock.earnings(for: artistId)
        let mult = max(1, earnings.total / max(earnings.streamingEquivalent, 1))
        var gen = SeededGen(Discovery.stableHash("impact-" + artistId))

        // Top fans by revenue driven.
        var fans: [TopFan] = []
        for (idx, fan) in Array(Mock.leaderboard.prefix(5)).enumerated() {
            let revenue = gen.int(180...900) + (5 - idx) * 220
            let streams = revenue * gen.int(80...140)
            fans.append(TopFan(fan: fan, revenueDriven: revenue, streamsDriven: streams, isYou: fan.name == "you"))
        }
        // Make sure "you" appears and reflects the live session.
        if !fans.contains(where: { $0.isYou }) {
            let you = LeaderFan(id: "you", name: "you", avatarSeed: "you", score: app.vybeScore,
                                city: app.taste.city.isEmpty ? "Los Angeles" : app.taste.city, topBadge: "Early Discoverer")
            fans.append(TopFan(fan: you, revenueDriven: 240, streamsDriven: 21_000, isYou: true))
        }
        fans.sort { $0.revenueDriven > $1.revenueDriven }

        // Recent support actions: live user events for this artist + seeded fan activity.
        var events = app.supportEvents.filter { $0.artistId == artistId }
        let verbs = ["Shared", "Tipped $5", "Boosted", "RSVP'd to a show", "Bought a drop", "Streamed a preview"]
        let fanNames = ["glowqueen", "bass_devotee", "sol_seeker", "neon_nadia", "static_kid", "synthsage"]
        for i in 0..<6 {
            events.append(SupportEvent(
                id: "seed-\(artistId)-\(i)", artistId: artistId, artistName: artist.name,
                fanName: gen.pick(fanNames), verb: gen.pick(verbs),
                dollars: Double(gen.int(2...40)) + 0.50, score: gen.int(50...900),
                minutesAgo: (i + 1) * gen.int(3...11)))
        }
        events.sort { $0.minutesAgo < $1.minutesAgo }

        // City demand heat — the artist's home city is hottest.
        let cityPool = Array(([artist.city] + Discovery.cities.filter { $0 != artist.city }).prefix(8))
        var heat: [CityHeat] = []
        for (idx, city) in cityPool.enumerated() {
            let v = idx == 0 ? 1.0 : gen.double(0.25, 0.9)
            heat.append(CityHeat(city: city, value: v, fans: "\(gen.int(8...190))K fans"))
        }
        heat.sort { $0.value > $1.value }

        let rising = fans.first { $0.isYou } ?? fans[0]

        return ArtistImpact(
            artist: artist, earnings: earnings, multiplier: mult,
            topFans: Array(fans.prefix(5)), recentEvents: Array(events.prefix(6)),
            risingTopFan: rising, cityHeat: Array(heat.prefix(4)))
    }
}
