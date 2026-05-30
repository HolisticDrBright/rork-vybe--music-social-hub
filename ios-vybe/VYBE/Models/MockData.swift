//
//  MockData.swift
//  VYBE
//
//  Realistic mock data demonstrating the full VYBE vision.
//

import SwiftUI

enum Mock {
    /// The hand-authored "hero" artists used throughout the demo flows.
    static let featuredArtists: [Artist] = [
        Artist(id: "a1", name: "NOVA REIGN", handle: "@novareign", genre: "Hyperpop", city: "Los Angeles",
               bio: "Genre-bending hyperpop visionary. Lights, lasers, and lyrics that hit different.",
               monthlyListeners: 2_840_000, followers: 1_210_000, isVerified: true, aiEnabled: true,
               isUndergroundRising: false, tags: ["Hyperpop", "Electronic", "Pop"],
               aiPersona: "Bold, playful, neon-obsessed. Loves talking about studio experiments and crowd energy.",
               subgenres: ["Electropop", "Glitch Pop"], moodTags: ["Euphoric", "Hype", "Chaotic"],
               sonicTags: ["maximalist", "autotuned", "synthetic", "explosive"], energy: 92,
               soundsLike: ["Charli XCX", "SOPHIE"], fanFundedMonthlyUSD: 281_700, streamingEquivUSD: 16_500,
               popularityTier: "established"),
        Artist(id: "a2", name: "Kairo Sol", handle: "@kairosol", genre: "Afro-House", city: "Brooklyn",
               bio: "Brooklyn-based producer fusing Afro-house with late-night soul.",
               monthlyListeners: 980_000, followers: 420_000, isVerified: true, aiEnabled: true,
               isUndergroundRising: false, tags: ["Afro-House", "Soul", "Dance"],
               aiPersona: "Warm, philosophical, rhythm-first. Speaks about heritage, groove, and connection.",
               subgenres: ["Amapiano", "Deep House"], moodTags: ["Groovy", "Flowing", "Euphoric"],
               sonicTags: ["percussive", "hypnotic", "soulful", "log-drum"], energy: 74,
               soundsLike: ["Black Coffee", "Bonobo"], fanFundedMonthlyUSD: 69_200, streamingEquivUSD: 3_900,
               popularityTier: "established"),
        Artist(id: "a3", name: "Velvet Static", handle: "@velvetstatic", genre: "Indie Rock", city: "Austin",
               bio: "Fuzzed-out indie rock with a heart of static and gold.",
               monthlyListeners: 410_000, followers: 188_000, isVerified: true, aiEnabled: false,
               isUndergroundRising: true, tags: ["Indie", "Rock", "Shoegaze"],
               aiPersona: "Dry humor, introspective. Talks gear, garages, and emotional honesty.",
               subgenres: ["Shoegaze", "Garage Rock"], moodTags: ["Nostalgic", "Moody", "Inspired"],
               sonicTags: ["fuzzy guitars", "reverb-drenched", "lo-fi", "analog warmth"], energy: 60,
               soundsLike: ["Tame Impala", "DIIV"], fanFundedMonthlyUSD: 30_800, streamingEquivUSD: 1_640,
               popularityTier: "established"),
        Artist(id: "a4", name: "LUNA TIDE", handle: "@lunatide", genre: "Dream Pop", city: "Portland",
               bio: "Ethereal dream pop washed in reverb and moonlight.",
               monthlyListeners: 220_000, followers: 96_000, isVerified: false, aiEnabled: true,
               isUndergroundRising: true, tags: ["Dream Pop", "Ambient"],
               aiPersona: "Soft-spoken, poetic, dreamy. Loves imagery, oceans, and quiet inspiration.",
               subgenres: ["Ambient Pop", "Shoegaze"], moodTags: ["Dreamy", "Calm", "Nostalgic"],
               sonicTags: ["reverb-drenched", "ethereal", "hazy", "lush"], energy: 34,
               soundsLike: ["Beach House", "Cocteau Twins"], fanFundedMonthlyUSD: 27_100, streamingEquivUSD: 880,
               popularityTier: "rising"),
        Artist(id: "a5", name: "BASSLINE PROPHET", handle: "@basslineprophet", genre: "Dubstep", city: "Detroit",
               bio: "Detroit bass merchant. The drop is a religion.",
               monthlyListeners: 1_540_000, followers: 670_000, isVerified: true, aiEnabled: false,
               isUndergroundRising: false, tags: ["Dubstep", "Bass", "EDM"],
               aiPersona: "High energy, hype, technical. Lives for sound design and festival mayhem.",
               subgenres: ["Riddim", "Bass Music"], moodTags: ["Aggressive", "Hype", "Chaotic"],
               sonicTags: ["heavy bass", "wobble", "distorted", "explosive"], energy: 97,
               soundsLike: ["Excision", "Skrillex"], fanFundedMonthlyUSD: 196_000, streamingEquivUSD: 6_160,
               popularityTier: "established"),
        Artist(id: "a6", name: "Sable Mirage", handle: "@sablemirage", genre: "R&B", city: "Atlanta",
               bio: "Smooth, smoky R&B for 3am thoughts.",
               monthlyListeners: 760_000, followers: 305_000, isVerified: true, aiEnabled: true,
               isUndergroundRising: false, tags: ["R&B", "Soul", "Neo-Soul"],
               aiPersona: "Smooth, candid, intimate. Opens up about vulnerability and writing love songs.",
               subgenres: ["Neo-Soul", "Alt R&B"], moodTags: ["Intimate", "Sultry", "Romantic"],
               sonicTags: ["smooth", "velvety", "sultry", "warm"], energy: 44,
               soundsLike: ["SZA", "Sade"], fanFundedMonthlyUSD: 56_200, streamingEquivUSD: 3_040,
               popularityTier: "established"),
        Artist(id: "a7", name: "GLITCHCORE KID", handle: "@glitchcorekid", genre: "Hyperpop", city: "Chicago",
               bio: "Internet-core chaos. Made in a bedroom, played in stadiums soon.",
               monthlyListeners: 88_000, followers: 41_000, isVerified: false, aiEnabled: false,
               isUndergroundRising: true, tags: ["Hyperpop", "Glitch", "Experimental"],
               aiPersona: "Chaotic, funny, terminally online. Talks memes, samples, and DIY culture.",
               subgenres: ["Glitchcore", "Digicore"], moodTags: ["Chaotic", "Hype", "Euphoric"],
               sonicTags: ["glitchy", "distorted", "hyper", "synthetic"], energy: 90,
               soundsLike: ["100 gecs", "SOPHIE"], fanFundedMonthlyUSD: 6_800, streamingEquivUSD: 352,
               popularityTier: "rising"),
        Artist(id: "a8", name: "Marisol Vega", handle: "@marisolvega", genre: "Reggaeton", city: "Miami",
               bio: "Miami heat in every beat. Reggaeton with a global pulse.",
               monthlyListeners: 3_100_000, followers: 1_500_000, isVerified: true, aiEnabled: true,
               isUndergroundRising: false, tags: ["Reggaeton", "Latin", "Pop"],
               aiPersona: "Fiery, confident, bilingual flair. Loves dancing, culture, and her fans (la familia).",
               subgenres: ["Latin Pop", "Dembow"], moodTags: ["Sultry", "Hype", "Confident"],
               sonicTags: ["dembow", "bilingual", "percussive", "sultry"], energy: 82,
               soundsLike: ["Bad Bunny", "Rosalía"], fanFundedMonthlyUSD: 305_000, streamingEquivUSD: 12_400,
               popularityTier: "established"),
    ]

    /// All artists in the app: hand-authored heroes + 90+ procedurally-generated
    /// underground acts (see DiscoveryEngine.swift) so every list feels full and the
    /// "Hidden Gems" engine has a deep, lesser-known pool to surface.
    /// The full artist pool — sourced from the canonical JSON when present,
    /// otherwise the built-in hero + generated catalog (see VYBEDataStore).
    static let artists: [Artist] = VYBEDataStore.shared.artists

    static func artist(_ id: String) -> Artist { artists.first { $0.id == id } ?? artists[0] }

    /// Hand-authored "hero" songs used by curated demo rows (trending / viral / search).
    static let featuredSongs: [Song] = [
        Song(id: "s1", title: "Neon Bloodstream", artistId: "a1", artistName: "NOVA REIGN", genre: "Hyperpop", mood: "Euphoric", energy: 94, durationSec: 198, plays: 12_400_000, isViral: true, releasedDaysAgo: 4),
        Song(id: "s2", title: "Midnight Caracas", artistId: "a8", artistName: "Marisol Vega", genre: "Reggaeton", mood: "Sultry", energy: 82, durationSec: 211, plays: 28_900_000, isViral: true, releasedDaysAgo: 12),
        Song(id: "s3", title: "Gravity Loves You", artistId: "a4", artistName: "LUNA TIDE", genre: "Dream Pop", mood: "Dreamy", energy: 38, durationSec: 247, plays: 1_220_000, isViral: false, releasedDaysAgo: 2),
        Song(id: "s4", title: "Subwoofer Gospel", artistId: "a5", artistName: "BASSLINE PROPHET", genre: "Dubstep", mood: "Aggressive", energy: 99, durationSec: 176, plays: 9_800_000, isViral: true, releasedDaysAgo: 8),
        Song(id: "s5", title: "Static & Gold", artistId: "a3", artistName: "Velvet Static", genre: "Indie Rock", mood: "Nostalgic", energy: 64, durationSec: 233, plays: 2_010_000, isViral: false, releasedDaysAgo: 1),
        Song(id: "s6", title: "Heritage (feat. Ami)", artistId: "a2", artistName: "Kairo Sol", genre: "Afro-House", mood: "Groovy", energy: 78, durationSec: 264, plays: 4_500_000, isViral: false, releasedDaysAgo: 6),
        Song(id: "s7", title: "3AM Confessions", artistId: "a6", artistName: "Sable Mirage", genre: "R&B", mood: "Intimate", energy: 42, durationSec: 219, plays: 6_700_000, isViral: false, releasedDaysAgo: 20),
        Song(id: "s8", title: "lol nothing matters", artistId: "a7", artistName: "GLITCHCORE KID", genre: "Hyperpop", mood: "Chaotic", energy: 91, durationSec: 142, plays: 540_000, isViral: true, releasedDaysAgo: 3),
        Song(id: "s9", title: "Solar Flare", artistId: "a1", artistName: "NOVA REIGN", genre: "Hyperpop", mood: "Euphoric", energy: 88, durationSec: 205, plays: 7_300_000, isViral: false, releasedDaysAgo: 30),
        Song(id: "s10", title: "Lunar Echoes", artistId: "a4", artistName: "LUNA TIDE", genre: "Ambient", mood: "Calm", energy: 24, durationSec: 312, plays: 880_000, isViral: false, releasedDaysAgo: 15),
    ]

    /// Alias kept for curated demo rows that intentionally use the hero set.
    static let songs: [Song] = featuredSongs

    /// Every song across the whole catalog (canonical JSON or built-in).
    static let allSongs: [Song] = VYBEDataStore.shared.songs

    static func songs(for artistId: String) -> [Song] {
        allSongs.filter { $0.artistId == artistId }
    }

    static let moods = ["Euphoric", "Dreamy", "Aggressive", "Groovy", "Intimate", "Nostalgic", "Chaotic", "Calm"]

    // MARK: - Vibe Check Moods

    /// Complete mood wheel for Vibe Check feature.
    static let vibeMoods: [VibeMood] = [
        VibeMood(id: "happy", name: "Happy", emoji: "😊", color: VYBE.gold, energyLow: 70, energyHigh: 92, isHeavy: false, matchKeywords: ["Euphoric", "Groovy"]),
        VibeMood(id: "sad", name: "Sad", emoji: "😢", color: Color(red: 0.4, green: 0.5, blue: 0.9), energyLow: 10, energyHigh: 35, isHeavy: true, matchKeywords: ["Nostalgic", "Intimate"]),
        VibeMood(id: "hype", name: "Hype", emoji: "🔥", color: VYBE.magenta, energyLow: 85, energyHigh: 100, isHeavy: false, matchKeywords: ["Euphoric", "Chaotic"]),
        VibeMood(id: "calm", name: "Calm", emoji: "😌", color: VYBE.cyan, energyLow: 8, energyHigh: 32, isHeavy: false, matchKeywords: ["Calm", "Dreamy"]),
        VibeMood(id: "dreamy", name: "Dreamy", emoji: "💭", color: Color(red: 0.7, green: 0.55, blue: 0.95), energyLow: 22, energyHigh: 48, isHeavy: false, matchKeywords: ["Dreamy", "Calm"]),
        VibeMood(id: "confident", name: "Confident", emoji: "💪", color: VYBE.purple, energyLow: 62, energyHigh: 88, isHeavy: false, matchKeywords: ["Groovy", "Euphoric"]),
        VibeMood(id: "moody", name: "Moody", emoji: "🖤", color: Color(red: 0.35, green: 0.2, blue: 0.55), energyLow: 18, energyHigh: 42, isHeavy: true, matchKeywords: ["Chaotic", "Aggressive"]),
        VibeMood(id: "euphoric", name: "Euphoric", emoji: "🥳", color: VYBE.magenta, energyLow: 88, energyHigh: 100, isHeavy: false, matchKeywords: ["Euphoric", "Groovy"]),
        VibeMood(id: "romantic", name: "Romantic", emoji: "💕", color: Color(red: 0.95, green: 0.45, blue: 0.65), energyLow: 35, energyHigh: 62, isHeavy: false, matchKeywords: ["Intimate", "Sultry"]),
        VibeMood(id: "angry", name: "Angry", emoji: "😤", color: Color(red: 0.95, green: 0.25, blue: 0.25), energyLow: 78, energyHigh: 98, isHeavy: true, matchKeywords: ["Aggressive", "Chaotic"]),
        VibeMood(id: "flowing", name: "Flowing", emoji: "🌊", color: VYBE.cyan, energyLow: 42, energyHigh: 68, isHeavy: false, matchKeywords: ["Groovy", "Dreamy"]),
        VibeMood(id: "inspired", name: "Inspired", emoji: "✨", color: VYBE.gold, energyLow: 52, energyHigh: 78, isHeavy: false, matchKeywords: ["Euphoric", "Groovy"]),
    ]

    /// Songs with rich mood/energy tags specifically for Vibe Check.
    static let vibeCheckSongs: [Song] = [
        Song(id: "vs1", title: "First Light", artistId: "a4", artistName: "LUNA TIDE", genre: "Dream Pop", mood: "Dreamy", energy: 28, durationSec: 234, plays: 890_000, isViral: false, releasedDaysAgo: 8),
        Song(id: "vs2", title: "Daybreak Protocol", artistId: "a1", artistName: "NOVA REIGN", genre: "Hyperpop", mood: "Euphoric", energy: 91, durationSec: 187, plays: 3_200_000, isViral: true, releasedDaysAgo: 3),
        Song(id: "vs3", title: "Blue Hour", artistId: "a3", artistName: "Velvet Static", genre: "Indie Rock", mood: "Nostalgic", energy: 42, durationSec: 256, plays: 1_450_000, isViral: false, releasedDaysAgo: 12),
        Song(id: "vs4", title: "Overdrive Saints", artistId: "a5", artistName: "BASSLINE PROPHET", genre: "Dubstep", mood: "Aggressive", energy: 97, durationSec: 164, plays: 6_800_000, isViral: true, releasedDaysAgo: 5),
        Song(id: "vs5", title: "Golden Hour", artistId: "a2", artistName: "Kairo Sol", genre: "Afro-House", mood: "Groovy", energy: 72, durationSec: 278, plays: 2_900_000, isViral: false, releasedDaysAgo: 18),
        Song(id: "vs6", title: "Satin Shadows", artistId: "a6", artistName: "Sable Mirage", genre: "R&B", mood: "Intimate", energy: 38, durationSec: 241, plays: 4_100_000, isViral: false, releasedDaysAgo: 9),
        Song(id: "vs7", title: "error404heart", artistId: "a7", artistName: "GLITCHCORE KID", genre: "Hyperpop", mood: "Chaotic", energy: 88, durationSec: 133, plays: 320_000, isViral: true, releasedDaysAgo: 1),
        Song(id: "vs8", title: "Ocean Floor", artistId: "a4", artistName: "LUNA TIDE", genre: "Ambient", mood: "Calm", energy: 18, durationSec: 298, plays: 620_000, isViral: false, releasedDaysAgo: 22),
        Song(id: "vs9", title: "Phoenix Mode", artistId: "a1", artistName: "NOVA REIGN", genre: "Hyperpop", mood: "Euphoric", energy: 95, durationSec: 172, plays: 5_100_000, isViral: true, releasedDaysAgo: 6),
        Song(id: "vs10", title: "Low Tide Confession", artistId: "a3", artistName: "Velvet Static", genre: "Indie Rock", mood: "Intimate", energy: 25, durationSec: 289, plays: 780_000, isViral: false, releasedDaysAgo: 14),
        Song(id: "vs11", title: "Concrete Jungle", artistId: "a5", artistName: "BASSLINE PROPHET", genre: "Dubstep", mood: "Aggressive", energy: 99, durationSec: 148, plays: 4_400_000, isViral: true, releasedDaysAgo: 2),
        Song(id: "vs12", title: "Serenity Pulse", artistId: "a2", artistName: "Kairo Sol", genre: "Afro-House", mood: "Calm", energy: 30, durationSec: 305, plays: 1_100_000, isViral: false, releasedDaysAgo: 25),
        Song(id: "vs13", title: "Velvet Skyline", artistId: "a6", artistName: "Sable Mirage", genre: "R&B", mood: "Sultry", energy: 55, durationSec: 224, plays: 3_300_000, isViral: false, releasedDaysAgo: 11),
        Song(id: "vs14", title: "pixelcrush.exe", artistId: "a7", artistName: "GLITCHCORE KID", genre: "Hyperpop", mood: "Chaotic", energy: 82, durationSec: 156, plays: 190_000, isViral: false, releasedDaysAgo: 4),
        Song(id: "vs15", title: "Carnival Heat", artistId: "a8", artistName: "Marisol Vega", genre: "Reggaeton", mood: "Sultry", energy: 86, durationSec: 198, plays: 18_200_000, isViral: true, releasedDaysAgo: 7),
    ]

    /// "N fans feeling this right now" — mock social layer data.
    static let vibeSocialCounts: [String: Int] = [
        "happy": 12_400, "sad": 3_200, "hype": 28_100, "calm": 8_900,
        "dreamy": 15_600, "confident": 19_300, "moody": 6_700, "euphoric": 31_800,
        "romantic": 9_400, "angry": 2_100, "flowing": 11_200, "inspired": 22_500,
    ]

    /// Friends' current vibes for social layer.
    static let friendsVibes: [(name: String, moodId: String)] = [
        ("glowqueen", "euphoric"), ("bass_devotee", "hype"), ("dreampop_dani", "dreamy"),
        ("neon_nadia", "confident"), ("sol_seeker", "flowing"),
    ]

    /// Map moods to relevant community IDs for Vibe Check mood rooms.
    static let moodCommunities: [String: [String]] = [
        "happy": ["cm4", "cm3"],
        "sad": ["cm3", "cm1"],
        "hype": ["cm4", "cm6"],
        "calm": ["cm3", "cm5"],
        "dreamy": ["cm3", "cm1"],
        "confident": ["cm1", "cm4"],
        "moody": ["cm3", "cm5"],
        "euphoric": ["cm4", "cm6"],
        "romantic": ["cm1", "cm3"],
        "angry": ["cm6", "cm3"],
        "flowing": ["cm5", "cm3"],
        "inspired": ["cm1", "cm4"],
    ]

    /// Returns communities relevant to a given mood.
    static func communitiesForMood(_ moodId: String) -> [Community] {
        let ids = moodCommunities[moodId] ?? ["cm3"]
        return ids.compactMap { id in communities.first { $0.id == id } }
    }

    /// SHIFT journey templates: mood A → mood B with 3-phase transition labels.
    static let shiftTemplates: [(from: String, to: String, phases: [String])] = [
        ("sad", "happy", ["Lifting Off", "Breaking Through", "Sunlight"]),
        ("angry", "calm", ["Release Valve", "Cooling Down", "Still Waters"]),
        ("moody", "inspired", ["Emerging", "Finding Light", "Full Bloom"]),
        ("calm", "hype", ["Warm Up", "Building Energy", "Peak Drop"]),
        ("dreamy", "confident", ["Waking Up", "Stepping Forward", "Standing Tall"]),
        ("sad", "euphoric", ["First Light", "Rising", "Euphoria"]),
    ]
    static let genres = ["Hyperpop", "Reggaeton", "Afro-House", "Dream Pop", "Dubstep", "Indie Rock", "R&B", "Ambient"]

    // MARK: - Artist Earnings Data

    static let artistEarnings: [ArtistEarnings] = [
        ArtistEarnings(id: "ae1", artistId: "a1", directSupport: 84_200, dropSales: 31_500, merchRevenue: 22_000, superfanRevenue: 48_000, eventRevenue: 96_000, streamingEquivalent: 16_500, artistKeepsPercent: 90, streamCount: 4_120_000),
        ArtistEarnings(id: "ae2", artistId: "a2", directSupport: 18_400, dropSales: 8_200, merchRevenue: 11_000, superfanRevenue: 9_600, eventRevenue: 22_000, streamingEquivalent: 3_900, artistKeepsPercent: 90, streamCount: 980_000),
        ArtistEarnings(id: "ae3", artistId: "a3", directSupport: 9_100, dropSales: 4_300, merchRevenue: 5_800, superfanRevenue: 3_200, eventRevenue: 8_400, streamingEquivalent: 1_640, artistKeepsPercent: 90, streamCount: 410_000),
        ArtistEarnings(id: "ae4", artistId: "a4", directSupport: 11_200, dropSales: 5_800, merchRevenue: 3_200, superfanRevenue: 2_100, eventRevenue: 4_800, streamingEquivalent: 880, artistKeepsPercent: 90, streamCount: 220_000),
        ArtistEarnings(id: "ae5", artistId: "a5", directSupport: 42_000, dropSales: 18_000, merchRevenue: 28_000, superfanRevenue: 36_000, eventRevenue: 72_000, streamingEquivalent: 6_160, artistKeepsPercent: 90, streamCount: 1_540_000),
        ArtistEarnings(id: "ae6", artistId: "a6", directSupport: 14_800, dropSales: 6_200, merchRevenue: 9_400, superfanRevenue: 7_800, eventRevenue: 18_000, streamingEquivalent: 3_040, artistKeepsPercent: 90, streamCount: 760_000),
        ArtistEarnings(id: "ae7", artistId: "a7", directSupport: 2_400, dropSales: 900, merchRevenue: 1_100, superfanRevenue: 600, eventRevenue: 1_800, streamingEquivalent: 352, artistKeepsPercent: 90, streamCount: 88_000),
        ArtistEarnings(id: "ae8", artistId: "a8", directSupport: 72_000, dropSales: 28_000, merchRevenue: 40_000, superfanRevenue: 55_000, eventRevenue: 110_000, streamingEquivalent: 12_400, artistKeepsPercent: 90, streamCount: 3_100_000),
    ]

    static func earnings(for artistId: String) -> ArtistEarnings {
        if let explicit = artistEarnings.first(where: { $0.artistId == artistId }) { return explicit }
        // Synthesize a consistent breakdown from the artist's discovery-profile totals
        // so generated/underground artists show honest, non-placeholder economics.
        let a = artist(artistId)
        let total = max(a.fanFundedMonthlyUSD, 1)
        return ArtistEarnings(
            id: "ae-\(artistId)", artistId: artistId,
            directSupport: Int(Double(total) * 0.34),
            dropSales: Int(Double(total) * 0.16),
            merchRevenue: Int(Double(total) * 0.18),
            superfanRevenue: Int(Double(total) * 0.12),
            eventRevenue: Int(Double(total) * 0.20),
            streamingEquivalent: max(a.streamingEquivUSD, 1),
            artistKeepsPercent: 90,
            streamCount: max(a.monthlyListeners * 3, 1)
        )
    }

    // MARK: - Anchor Artists (famous taste reference points for #17)

    /// Famous reference artists used purely as taste anchors in the discovery engine.
    /// These are reference points only — never navigable profiles.
    static let anchors: [AnchorArtist] = VYBEDataStore.shared.anchors

    /// Resolve a typed/selected anchor name (or genre) into a similarity vector.
    static func anchorVector(named raw: String) -> SonicVector? {
        let q = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return nil }
        // 1) Exact/contains match against famous anchors.
        if let a = anchors.first(where: { $0.name.lowercased() == q })
            ?? anchors.first(where: { $0.name.lowercased().contains(q) || q.contains($0.name.lowercased()) }) {
            return a.sonicVector
        }
        // 2) Match against an artist already in the app.
        if let art = artists.first(where: { $0.name.lowercased() == q })
            ?? artists.first(where: { $0.name.lowercased().contains(q) }) {
            return art.sonicVector
        }
        // 3) Fall back to a genre-family vector ("sounds like dream pop").
        if let fam = Discovery.family(matching: q) {
            return SonicVector(displayName: raw, genre: fam.genre, subgenres: fam.subgenres,
                               sonicTags: fam.sonicTags, moodTags: fam.moodTags, energy: fam.baseEnergy)
        }
        return nil
    }

    // MARK: - Funded Artists (for fan profile)

    static let fundedArtists: [FundedArtist] = [
        FundedArtist(id: "fa1", artistId: "a4", artistName: "LUNA TIDE", totalContributed: 320, streamsDriven: 18_400, rank: 12, supportActions: ["Early discoverer", "Shared 24x", "Attended Portland show", "Tip $10"], artistHandle: "@lunatide", artistGenre: "Dream Pop"),
        FundedArtist(id: "fa2", artistId: "a1", artistName: "NOVA REIGN", totalContributed: 1_840, streamsDriven: 84_200, rank: 5, supportActions: ["Top 5 fan", "Shared 142x", "Attended 3 shows", "Tip $50", "Bought merch"], artistHandle: "@novareign", artistGenre: "Hyperpop"),
        FundedArtist(id: "fa3", artistId: "a3", artistName: "Velvet Static", totalContributed: 140, streamsDriven: 6_200, rank: 28, supportActions: ["Shared 12x", "Playlist add", "Attended Austin show"], artistHandle: "@velvetstatic", artistGenre: "Indie Rock"),
        FundedArtist(id: "fa4", artistId: "a7", artistName: "GLITCHCORE KID", totalContributed: 85, streamsDriven: 3_100, rank: 8, supportActions: ["Early discoverer", "Shared 18x", "Tip $5"], artistHandle: "@glitchcorekid", artistGenre: "Hyperpop"),
    ]

    // MARK: - Report Categories

    static let reportCategories: [ReportCategory] = [
        ReportCategory(name: "Harassment", icon: "exclamationmark.shield.fill", description: "Bullying, threats, or targeted abuse"),
        ReportCategory(name: "Doxing / PII", icon: "person.crop.circle.badge.exclamationmark", description: "Sharing private info without consent"),
        ReportCategory(name: "Spam", icon: "megaphone.fill", description: "Repetitive, unwanted, or promotional content"),
        ReportCategory(name: "Hate Speech", icon: "nosign", description: "Hateful content targeting identity or group"),
        ReportCategory(name: "Impersonation", icon: "person.fill.questionmark", description: "Pretending to be someone else"),
        ReportCategory(name: "Other", icon: "ellipsis.circle.fill", description: "Something else concerning"),
    ]

    // MARK: - Onboarding Taste Options

    static let tasteGenres = ["Hyperpop", "Afro-House", "Indie Rock", "Dream Pop", "Dubstep", "R&B", "Reggaeton", "Ambient", "Hip-Hop", "Electronic", "K-Pop", "Latin"]
    static let tasteMoods = ["Euphoric", "Dreamy", "Aggressive", "Groovy", "Intimate", "Nostalgic", "Chaotic", "Calm", "Sultry", "Hype", "Happy", "Confident", "Flowing", "Inspired"]
    static let tasteLookingFor = ["Discover music", "Meet fans", "Go to shows", "Support artists", "Earn rewards", "Join communities"]

    // MARK: - Events

    static let events: [Event] = [
        Event(id: "e1", title: "PRISM Festival 2026", venue: "Sahara Tent", city: "Los Angeles",
              date: Date().addingTimeInterval(86400 * 12), lineup: ["NOVA REIGN", "BASSLINE PROPHET", "Marisol Vega", "Kairo Sol"],
              attending: 48_200, friendsAttending: 7, ticketPriceFrom: 189, isFestival: true, distanceMiles: 8.4),
        Event(id: "e2", title: "NOVA REIGN — Neon Bloodstream Tour", venue: "The Novo", city: "Los Angeles",
              date: Date().addingTimeInterval(86400 * 5), lineup: ["NOVA REIGN", "GLITCHCORE KID"],
              attending: 3_100, friendsAttending: 4, ticketPriceFrom: 65, isFestival: false, distanceMiles: 3.1),
        Event(id: "e3", title: "Brooklyn Afro-House Night", venue: "Elsewhere Rooftop", city: "Brooklyn",
              date: Date().addingTimeInterval(86400 * 2), lineup: ["Kairo Sol", "Sable Mirage"],
              attending: 720, friendsAttending: 2, ticketPriceFrom: 30, isFestival: false, distanceMiles: 14.0),
        Event(id: "e4", title: "Velvet Static Live", venue: "Mohawk", city: "Austin",
              date: Date().addingTimeInterval(86400 * 9), lineup: ["Velvet Static", "LUNA TIDE"],
              attending: 540, friendsAttending: 1, ticketPriceFrom: 25, isFestival: false, distanceMiles: 2.0),
        Event(id: "e5", title: "BASS CATHEDRAL", venue: "Masonic Temple", city: "Detroit",
              date: Date().addingTimeInterval(86400 * 18), lineup: ["BASSLINE PROPHET"],
              attending: 5_400, friendsAttending: 3, ticketPriceFrom: 55, isFestival: false, distanceMiles: 6.6),
    ]

    // MARK: - Board Posts

    static let boardPosts: [BoardPost] = [
        BoardPost(id: "p1", author: "rave_riley", avatarSeed: "riley", text: "Who's pulling up Friday? Trying to find my crew before the gates open 🔥", minutesAgo: 8, likes: 42, replies: 12, channel: "Meetups"),
        BoardPost(id: "p2", author: "synthsage", avatarSeed: "sage", text: "Driving from San Diego, 2 seats open. Gas split + good playlists guaranteed.", minutesAgo: 23, likes: 18, replies: 6, channel: "Ride Share"),
        BoardPost(id: "p3", author: "first_timer_fae", avatarSeed: "fae", text: "First festival ever!! any tips for staying hydrated + where to meet people??", minutesAgo: 41, likes: 67, replies: 24, channel: "First-Timers"),
        BoardPost(id: "p4", author: "vip_vera", avatarSeed: "vera", text: "VIP cabana 7 doing a pre-set toast at 6. Pull through, the view is unreal.", minutesAgo: 55, likes: 31, replies: 9, channel: "VIP"),
        BoardPost(id: "p5", author: "afterdark_ace", avatarSeed: "ace", text: "Afterparty intel: warehouse off 4th, doors at midnight. DM for the addy 👀", minutesAgo: 72, likes: 88, replies: 30, channel: "Afterparty"),
        BoardPost(id: "p6", author: "neon_nadia", avatarSeed: "nadia", text: "Made matching holographic outfits for our group — come find the glow squad!", minutesAgo: 95, likes: 120, replies: 18, channel: "Meetups"),
    ]

    static let boardChannels = ["All", "Meetups", "Ride Share", "First-Timers", "VIP", "Afterparty"]

    // MARK: - Badges

    static let badges: [Badge] = [
        Badge(id: "b1", name: "Founder Fan", icon: "flag.checkered.2.crossed", desc: "Joined VYBE in the first wave", earned: true),
        Badge(id: "b2", name: "Music Scout", icon: "binoculars.fill", desc: "Discovered 25+ rising artists", earned: true),
        Badge(id: "b3", name: "Festival Veteran", icon: "tent.2.fill", desc: "Attended 10+ live events", earned: true),
        Badge(id: "b4", name: "Artist Ambassador", icon: "megaphone.fill", desc: "Top promoter for an artist", earned: true),
        Badge(id: "b5", name: "Top Fan", icon: "crown.fill", desc: "Reached an artist's top 10", earned: false),
        Badge(id: "b6", name: "Viral Promoter", icon: "bolt.horizontal.fill", desc: "Drove 100k+ streams from shares", earned: true),
        Badge(id: "b7", name: "Concert Crew Leader", icon: "person.3.fill", desc: "Organized 5+ meetups", earned: false),
        Badge(id: "b8", name: "Early Discoverer", icon: "sparkle.magnifyingglass", desc: "Found a song before it went viral", earned: true),
        Badge(id: "b9", name: "Superfan", icon: "heart.circle.fill", desc: "Engaged 100+ days in a row", earned: false),
        Badge(id: "b10", name: "Tastemaker", icon: "wand.and.stars", desc: "Your playlists shaped the charts", earned: false),
        Badge(id: "b11", name: "First Opened It", icon: "rectangle.portrait.on.rectangle.portrait.angled.fill", desc: "Opened a song's sleeve", earned: false),
        Badge(id: "b12", name: "Sleeve Collector", icon: "rectangle.stack.fill", desc: "Opened & supported 3+ sleeves", earned: false),
        Badge(id: "b13", name: "Video Premiere Crew", icon: "play.tv.fill", desc: "Caught a video premiere on VYBE TV", earned: false),
        Badge(id: "b14", name: "First Heard It", icon: "bolt.heart.fill", desc: "Backed a drop before it broke", earned: false),
        Badge(id: "b15", name: "Collab Scout", icon: "person.2.wave.2.fill", desc: "Joined a crew or backed a collab", earned: false),
    ]

    // MARK: - Rewards

    static let rewards: [Reward] = [
        Reward(id: "r1", title: "Free Concert Ticket", subtitle: "Any show under $80", cost: 12_000, icon: "ticket.fill", category: "Tickets", hot: true),
        Reward(id: "r2", title: "VIP Festival Pass", subtitle: "PRISM Festival 2026", cost: 45_000, icon: "star.circle.fill", category: "VIP", hot: true),
        Reward(id: "r3", title: "Meet & Greet", subtitle: "With NOVA REIGN", cost: 30_000, icon: "person.2.wave.2.fill", category: "Access", hot: false),
        Reward(id: "r4", title: "Backstage Pass", subtitle: "Selected tour dates", cost: 38_000, icon: "key.fill", category: "Access", hot: false),
        Reward(id: "r5", title: "Signed Merch Drop", subtitle: "Limited holographic tee", cost: 9_000, icon: "tshirt.fill", category: "Merch", hot: true),
        Reward(id: "r6", title: "Exclusive Track", subtitle: "Unreleased Kairo Sol cut", cost: 6_000, icon: "music.note.list", category: "Content", hot: false),
        Reward(id: "r7", title: "Artist Voice Note", subtitle: "Personal shoutout", cost: 15_000, icon: "waveform", category: "Content", hot: false),
        Reward(id: "r8", title: "Merch Discount 25%", subtitle: "Any artist store", cost: 4_000, icon: "tag.fill", category: "Merch", hot: false),
        Reward(id: "r9", title: "Early Access Drops", subtitle: "48h before everyone", cost: 7_500, icon: "clock.badge.fill", category: "Access", hot: false),
    ]

    static let rewardCategories = ["All", "Tickets", "VIP", "Access", "Merch", "Content"]

    // MARK: - Challenges

    static let challenges: [Challenge] = [
        Challenge(id: "c1", title: "Share \"Neon Bloodstream\"", artistName: "NOVA REIGN", reward: 500, participants: 14_200, icon: "square.and.arrow.up.fill", progress: 0.7, deadline: "3 days left"),
        Challenge(id: "c2", title: "Help sell out the LA show", artistName: "NOVA REIGN", reward: 1500, participants: 3_400, icon: "flame.fill", progress: 0.82, deadline: "5 days left"),
        Challenge(id: "c3", title: "Make a video with this beat", artistName: "Marisol Vega", reward: 1000, participants: 22_800, icon: "video.fill", progress: 0.45, deadline: "1 week left"),
        Challenge(id: "c4", title: "Add \"Heritage\" to a playlist", artistName: "Kairo Sol", reward: 300, participants: 8_900, icon: "text.badge.plus", progress: 0.6, deadline: "2 days left"),
        Challenge(id: "c5", title: "Invite 3 friends to BASS CATHEDRAL", artistName: "BASSLINE PROPHET", reward: 800, participants: 1_900, icon: "person.badge.plus.fill", progress: 0.33, deadline: "10 days left"),
    ]

    // MARK: - Leaderboard

    static let leaderboard: [LeaderFan] = [
        LeaderFan(id: "l1", name: "glowqueen", avatarSeed: "glow", score: 184_200, city: "Los Angeles", topBadge: "Superfan"),
        LeaderFan(id: "l2", name: "bass_devotee", avatarSeed: "bassd", score: 171_050, city: "Detroit", topBadge: "Concert Crew Leader"),
        LeaderFan(id: "l3", name: "marisol_mvp", avatarSeed: "mvp", score: 158_900, city: "Miami", topBadge: "Viral Promoter"),
        LeaderFan(id: "l4", name: "dreampop_dani", avatarSeed: "dani", score: 142_300, city: "Portland", topBadge: "Tastemaker"),
        LeaderFan(id: "l5", name: "you", avatarSeed: "you", score: 128_450, city: "Los Angeles", topBadge: "Artist Ambassador"),
        LeaderFan(id: "l6", name: "sol_seeker", avatarSeed: "seek", score: 119_700, city: "Brooklyn", topBadge: "Music Scout"),
        LeaderFan(id: "l7", name: "static_kid", avatarSeed: "static", score: 98_400, city: "Austin", topBadge: "Early Discoverer"),
        LeaderFan(id: "l8", name: "neon_nomad", avatarSeed: "nomad", score: 87_200, city: "Chicago", topBadge: "Festival Veteran"),
    ]

    // MARK: - Communities

    static let communities: [Community] = [
        Community(id: "cm1", name: "NOVA REIGN Collective", kind: "Artist", members: 412_000, activeNow: 3_240, about: "The official home for the Reign army. Drops, theories, and chaos.", trendingTopic: "Tour visuals leaked 👀"),
        Community(id: "cm2", name: "LA Underground", kind: "City", members: 88_400, activeNow: 980, about: "Everything happening in the LA scene — shows, warehouses, rising acts.", trendingTopic: "Best DIY venues right now"),
        Community(id: "cm3", name: "Hyperpop Heaven", kind: "Genre", members: 234_000, activeNow: 2_100, about: "Glitch, autotune, and maximalism. The future is loud.", trendingTopic: "Is glitchcore back?"),
        Community(id: "cm4", name: "Festival Fam", kind: "Fan Group", members: 156_000, activeNow: 1_540, about: "Lineup leaks, packing lists, and finding your people on the field.", trendingTopic: "PRISM set times debate"),
        Community(id: "cm5", name: "Brooklyn Afro-House", kind: "City", members: 41_000, activeNow: 410, about: "Rooftops, basements, and the rhythm that runs the night.", trendingTopic: "Kairo Sol rooftop recap"),
        Community(id: "cm6", name: "Bassheads United", kind: "Genre", members: 198_000, activeNow: 1_870, about: "If the floor isn't shaking, we don't want it.", trendingTopic: "Cleanest drop of 2026?"),
    ]

    // MARK: - Feed

    static let feed: [FeedItem] = [
        FeedItem(id: "f1", kind: .trendingSong, title: "Neon Bloodstream", subtitle: "NOVA REIGN · Trending #1", meta: "12.4M plays this week", seed: "Neon Bloodstream", accentSeed: "trend"),
        FeedItem(id: "f2", kind: .aiMessage, title: "AI NOVA REIGN", subtitle: "\"Just dropped a secret demo for my top fans — wanna hear the story behind it?\"", meta: "Official AI version · tap to chat", seed: "NOVA REIGN", accentSeed: "ai"),
        FeedItem(id: "f3", kind: .friends, title: "7 friends going to PRISM Festival", subtitle: "glowqueen, bass_devotee +5", meta: "In 12 days · Los Angeles", seed: "PRISM Festival 2026", accentSeed: "friends"),
        FeedItem(id: "f4", kind: .challenge, title: "Help sell out the LA show", subtitle: "NOVA REIGN challenge · +1500 pts", meta: "82% to goal · 5 days left", seed: "challenge2", accentSeed: "chal"),
        FeedItem(id: "f5", kind: .artistDrop, title: "Velvet Static dropped \"Static & Gold\"", subtitle: "New single · Indie Rock", meta: "Released 1 day ago", seed: "Static & Gold", accentSeed: "drop"),
        FeedItem(id: "f6", kind: .concert, title: "Brooklyn Afro-House Night", subtitle: "Kairo Sol · Elsewhere Rooftop", meta: "In 2 days · 14 mi away", seed: "Brooklyn Afro-House Night", accentSeed: "concert"),
        FeedItem(id: "f7", kind: .recommendation, title: "Because you're feeling Euphoric", subtitle: "Solar Flare · NOVA REIGN", meta: "Mood-matched for you", seed: "Solar Flare", accentSeed: "rec"),
        FeedItem(id: "f8", kind: .communityUpdate, title: "Hyperpop Heaven is buzzing", subtitle: "\"Is glitchcore back?\" · 2.1k active", meta: "Community update", seed: "Hyperpop Heaven", accentSeed: "comm"),
    ]

    // MARK: - AI Chat

    static let aiStarters = [
        "What inspired your latest single?",
        "Tell me a wild tour story.",
        "What's your creative process?",
        "Who are your biggest influences?",
    ]

    /// Generates a mock AI reply for an artist based on persona + question.
    static func aiReply(for artist: Artist, to question: String) -> String {
        let q = question.lowercased()
        let intro = "🤖 Official AI \(artist.name) here — "
        if q.contains("inspir") || q.contains("single") || q.contains("song") {
            return intro + "honestly that track came from a 4am studio session where everything felt electric. \(artist.aiPersona.components(separatedBy: ".").first ?? "") I wanted it to feel like the moment right before the drop at a festival — pure anticipation."
        } else if q.contains("tour") || q.contains("story") {
            return intro + "one night in \(artist.city) the power cut mid-set, so the whole crowd lit up their phones and sang the chorus a cappella. Goosebumps. That's the kind of magic VYBE is built on."
        } else if q.contains("process") || q.contains("creat") || q.contains("write") {
            return intro + "I usually start with a feeling, not a melody. \(artist.genre) lets me sculpt mood first, then I chase the hook. I'll loop one idea for hours until it gives me chills."
        } else if q.contains("influen") || q.contains("inspire you") {
            return intro + "so many — but the thread is anyone who took risks. I blend my \(artist.genre) roots with whatever's moving me that week. Genres are just suggestions."
        } else {
            return intro + "love that question. As the artist-approved AI version of \(artist.name), I'm here to talk lyrics, inspiration, and the stories behind the music. Ask me anything 💜"
        }
    }

    // MARK: - Scene Spotlights (editorial discovery cards)

    static let sceneSpotlights: [(title: String, subtitle: String, description: String, accent: String)] = [
        ("The LA Warehouse Revival", "Underground electronic scene", "DIY venues and secret-location raves are redefining LA nightlife. Hyperpop, techno, and genre-fluid acts lead the charge.", "LA"),
        ("Hyperpop's Second Wave", "Genre evolution", "The glitchy, maximalist sound of 2020-2024 is giving way to something more melodic — but just as chaotic. Meet the artists shaping it.", "Hyperpop"),
        ("Brooklyn's Afro-House Moment", "Global rhythms, local rooms", "From Elsewhere rooftop to basement parties, Brooklyn is becoming the US home for Afro-house, amapiano, and diasporic dance music.", "Brooklyn"),
    ]

    // MARK: - Settings / Fan-First Values

    static let fanFirstValues: [(icon: String, title: String, description: String)] = [
        ("hand.thumbsup.fill", "No Forced Ads", "Premium tiers never see ads. Even free-tier ads are music-related and non-intrusive."),
        ("shuffle", "Honest Shuffle", "When you hit shuffle, it's truly random. No payola, no algorithmic bias."),
        ("lock.shield.fill", "Your Data Is Yours", "We don't sell your listening data. Period. Your taste profile stays private."),
        ("heart.text.square.fill", "Artist-First Economics", "Artists keep 90% of fan support — VYBE takes a 10% platform fee (plus card processing). Compare: Spotify pays ~$0.004 per stream."),
        ("eye.slash.fill", "No Dark Patterns", "Every action is intentional. We never trick you into engagement or purchases."),
        ("person.2.badge.gearshape.fill", "Community-Moderated", "Real humans + smart tools keep VYBE safe. Report anything, anytime."),
    ]

    // MARK: - Collab Lab

    /// The artist whose dashboard the demo is presenting (the "you, the artist" side).
    static let collabArtistId = "a1"

    /// Rights/splits disclaimer surfaced across the Collab Lab.
    static let collabRightsNotice = "Splits and rights are placeholders in this prototype. Artists should confirm ownership before release."

    static let collabChallenges: [CollabChallenge] = [
        // The current artist's own beat — used for the review → winner → drop demo.
        CollabChallenge(
            id: "ch1", creatorArtistId: "a1", creatorName: "NOVA REIGN",
            title: "Best Hook on \"Midnight Signal\"", beatTitle: "Midnight Signal",
            challengeType: .bestHook, genre: "Hyperpop", mood: "Cinematic / late-night",
            bpm: 92, key: "A minor", city: "Los Angeles",
            description: "Cold synth arp, big sub, space for one unforgettable topline. I want a hook that sounds like a city at 3am. Best hook gets the feature on the final song + a launch push on VYBE.",
            lookingFor: ["Vocalist", "Topline writer"],
            reward: "Featured artist credit + split placeholder + launch push on VYBE",
            proposedSplit: "50/50 (placeholder)", deadlineText: "5 days left",
            status: .reviewing, submissionCount: 37, previewSeed: "Midnight Signal",
            visibility: .publicAll, creditNotes: "Co-write + featured credit. Confirm ownership before release."),

        CollabChallenge(
            id: "ch2", creatorArtistId: "a6", creatorName: "Sable Mirage",
            title: "Best Hook on this Alt-R&B beat", beatTitle: "Velvet Static",
            challengeType: .bestHook, genre: "Alt-R&B", mood: "Late-night / cinematic",
            bpm: 92, key: "A minor", city: "Atlanta",
            description: "Smoky chords, brushed drums, lots of air. Looking for a vocalist or topline writer who can make the chorus ache. Featured collaborator becomes part of the release.",
            lookingFor: ["Vocalist", "Topline writer"],
            reward: "Featured artist credit + split placeholder + launch push on VYBE",
            proposedSplit: "60/40 (placeholder)", deadlineText: "5 days left",
            status: .open, submissionCount: 37, previewSeed: "Velvet Static beat",
            visibility: .publicAll, creditNotes: "Featured credit. Confirm ownership before release."),

        CollabChallenge(
            id: "ch3", creatorArtistId: "a2", creatorName: "Kairo Sol",
            title: "Open verse on this Afro-House groove", beatTitle: "Log Drum Gospel",
            challengeType: .openVerse, genre: "Afro-House", mood: "Groovy / hypnotic",
            bpm: 118, key: "F minor", city: "Brooklyn",
            description: "Rolling log drums and a late-night groove. Drop a verse or topline that rides the pocket. Open to rappers and songwriters.",
            lookingFor: ["Rapper", "Songwriter"],
            reward: "Split placeholder + co-release + rooftop show slot",
            proposedSplit: "50/50 (placeholder)", deadlineText: "3 days left",
            status: .open, submissionCount: 21, previewSeed: "Log Drum Gospel",
            visibility: .sceneOnly, creditNotes: "Co-write credit. Confirm ownership before release."),

        CollabChallenge(
            id: "ch4", creatorArtistId: "a5", creatorName: "BASSLINE PROPHET",
            title: "Remix this dubstep drop", beatTitle: "Subwoofer Gospel",
            challengeType: .remixThis, genre: "Dubstep", mood: "Aggressive",
            bpm: 150, key: "E minor", city: "Detroit",
            description: "Take the stems and flip the drop. Heaviest, cleanest remix gets an official release + festival play.",
            lookingFor: ["Producer", "Remixer"],
            reward: "Official remix release + festival play + split placeholder",
            proposedSplit: "Remix split (placeholder)", deadlineText: "1 week left",
            status: .open, submissionCount: 54, previewSeed: "Subwoofer Gospel",
            visibility: .publicAll, creditNotes: "Remix credit. Confirm ownership before release."),

        CollabChallenge(
            id: "ch5", creatorArtistId: "a4", creatorName: "LUNA TIDE",
            title: "Add vocals to this dream pop loop", beatTitle: "Slow Halo",
            challengeType: .addVocals, genre: "Dream Pop", mood: "Ethereal / hazy",
            bpm: 80, key: "C major", city: "Portland",
            description: "Reverb-drenched loop that needs a voice floating on top. Looking for an ethereal vocalist to finish it with me.",
            lookingFor: ["Vocalist"],
            reward: "Featured credit + split placeholder + tour support slot",
            proposedSplit: "50/50 (placeholder)", deadlineText: "6 days left",
            status: .open, submissionCount: 12, previewSeed: "Slow Halo",
            visibility: .publicAll, creditNotes: "Featured credit. Confirm ownership before release."),

        CollabChallenge(
            id: "ch6", creatorArtistId: "a7", creatorName: "GLITCHCORE KID",
            title: "Finish this glitch sketch", beatTitle: "error404heart",
            challengeType: .finishSong, genre: "Hyperpop", mood: "Chaotic",
            bpm: 160, key: "G minor", city: "Chicago",
            description: "Half a song, all chaos. Producers + songwriters — help me turn this sketch into a real drop.",
            lookingFor: ["Producer", "Songwriter"],
            reward: "Co-artist credit + split placeholder",
            proposedSplit: "Even split (placeholder)", deadlineText: "4 days left",
            status: .open, submissionCount: 9, previewSeed: "error404heart",
            visibility: .publicAll, creditNotes: "Co-artist credit. Confirm ownership before release."),

        CollabChallenge(
            id: "ch7", creatorArtistId: "a8", creatorName: "Marisol Vega",
            title: "Producer wanted for reggaeton topline", beatTitle: "Calor de Verano",
            challengeType: .producerWanted, genre: "Reggaeton", mood: "Sultry / hype",
            bpm: 95, key: "D minor", city: "Miami",
            description: "I have the topline and the energy — I need a producer to build the world around it. Bring the dembow.",
            lookingFor: ["Producer"],
            reward: "Production credit + split placeholder + music video feature",
            proposedSplit: "Producer split (placeholder)", deadlineText: "9 days left",
            status: .open, submissionCount: 18, previewSeed: "Calor de Verano",
            visibility: .publicAll, creditNotes: "Production credit. Confirm ownership before release."),

        // An already-completed collab that became a drop — seeds "Born on VYBE".
        CollabChallenge(
            id: "ch8", creatorArtistId: "a3", creatorName: "Velvet Static",
            title: "Open verse on \"Static & Gold\"", beatTitle: "Static & Gold",
            challengeType: .openVerse, genre: "Indie Rock", mood: "Nostalgic",
            bpm: 104, key: "D major", city: "Austin",
            description: "Fuzzed-out guitars looking for a second voice. Winner became a featured collaborator.",
            lookingFor: ["Vocalist", "Songwriter"],
            reward: "Featured credit + split placeholder",
            proposedSplit: "50/50 (placeholder)", deadlineText: "Closed",
            status: .convertedToDrop, submissionCount: 44, previewSeed: "Static & Gold",
            visibility: .publicAll, creditNotes: "Featured credit. Confirm ownership before release.",
            selectedSubmissionId: "sub-ch8-win"),
    ]

    static let collabSubmissions: [CollabSubmission] = [
        // Submissions on the current artist's "Midnight Signal" — for the review demo.
        CollabSubmission(id: "sub-ch1-1", challengeId: "ch1", artistId: "a4", artistName: "LUNA TIDE",
                         submissionType: .hook, title: "\"hold the line\" hook",
                         note: "Tried an airy falsetto hook that leans into the late-night feel — left space for your synth arp to breathe.",
                         lyricSnippet: "hold the line / the city's calling out my name / midnight signal in my veins",
                         previewSeed: "hook-luna-mid", reactions: 41, status: .submitted, minutesAgo: 22),
        CollabSubmission(id: "sub-ch1-2", challengeId: "ch1", artistId: "a6", artistName: "Sable Mirage",
                         submissionType: .hook, title: "smoky alt-r&b topline",
                         note: "Lower register, a little ache in the chorus. Could double it with harmonies for the drop.",
                         lyricSnippet: "signal fading, still I stay / midnight told me run away",
                         previewSeed: "hook-sable-mid", reactions: 33, status: .shortlisted, minutesAgo: 47),
        CollabSubmission(id: "sub-ch1-3", challengeId: "ch1", artistId: "a7", artistName: "GLITCHCORE KID",
                         submissionType: .hook, title: "glitched-out chant hook",
                         note: "Went chaotic — chopped vocal chant that could be the post-drop moment. Very online energy.",
                         lyricSnippet: "mid-mid-midnight / signal in the noise",
                         previewSeed: "hook-glitch-mid", reactions: 58, status: .submitted, minutesAgo: 63),
        CollabSubmission(id: "sub-ch1-4", challengeId: "ch1", artistId: "", artistName: "Aria Vale",
                         submissionType: .vocalIdea, title: "cinematic oohs + topline",
                         note: "Layered wordless oohs for the intro then a simple, sticky chorus. Trying to keep it haunting.",
                         lyricSnippet: "(wordless intro) → so don't let go of midnight",
                         previewSeed: "hook-aria-mid", reactions: 27, status: .submitted, minutesAgo: 90),
        CollabSubmission(id: "sub-ch1-5", challengeId: "ch1", artistId: "", artistName: "Kid Cassette",
                         submissionType: .verse, title: "8-bar opener verse",
                         note: "Wrote a quick verse to set up the hook — happy to adjust the cadence to your arp.",
                         lyricSnippet: "neon on the dashboard, ghost in the machine / chasing a frequency nobody's seen",
                         previewSeed: "hook-kid-mid", reactions: 19, status: .declined, minutesAgo: 140),

        // A couple of public submissions on the Alt-R&B challenge (ch2).
        CollabSubmission(id: "sub-ch2-1", challengeId: "ch2", artistId: "a4", artistName: "LUNA TIDE",
                         submissionType: .hook, title: "breathy chorus idea",
                         note: "Floating chorus that sits back in the mix. Could fit the cinematic brief.",
                         lyricSnippet: "velvet static on the radio / love me slow, love me slow",
                         previewSeed: "hook-luna-r&b", reactions: 24, status: .submitted, minutesAgo: 35),
        CollabSubmission(id: "sub-ch2-2", challengeId: "ch2", artistId: "", artistName: "Noah Reverb",
                         submissionType: .vocalIdea, title: "harmony stack",
                         note: "Stacked 3-part harmony for the pre-chorus lift.",
                         lyricSnippet: "stay in the static with me",
                         previewSeed: "hook-noah-r&b", reactions: 15, status: .submitted, minutesAgo: 80),

        // The winning submission that became the "Static & Gold" collab drop (ch8).
        CollabSubmission(id: "sub-ch8-win", challengeId: "ch8", artistId: "a4", artistName: "LUNA TIDE",
                         submissionType: .verse, title: "second-voice verse",
                         note: "Added a dreamy counter-melody verse. Felt like it completed the song.",
                         lyricSnippet: "we were static, we were gold / two voices in the cold",
                         previewSeed: "hook-luna-static", reactions: 88, status: .selected, minutesAgo: 4320),
    ]

    static let upcomingDrops: [UpcomingDrop] = [
        UpcomingDrop(
            id: "ud-static", title: "Static & Gold (feat. LUNA TIDE)",
            artistNames: ["Velvet Static", "LUNA TIDE"], originChallengeId: "ch8",
            bornOnVYBE: true,
            description: "Started as a Velvet Static open-verse challenge. LUNA TIDE's second voice won the feature — now it's a real release.",
            genre: "Indie Rock × Dream Pop", earlySupporters: 1_284,
            previewSeed: "Static & Gold drop", splitNote: "50/50 (placeholder)",
            releaseText: "Drops in 9 days"),
    ]

    static func collabChallenge(_ id: String) -> CollabChallenge? { collabChallenges.first { $0.id == id } }

    // MARK: - Sleeves (interactive song art + lore). All lyrics are fictional/mock.

    static let sleeves: [SongSleeve] = [
        // New Age cosmic — LUNA TIDE · Gravity Loves You
        SongSleeve(
            id: "sl-s3", songId: "s3", artistId: "a4", title: "Gravity Loves You", artistName: "LUNA TIDE",
            era: .newAge, coverArtSeed: "Gravity Loves You sleeve",
            tagline: "Side A · a love letter to the tide",
            lyricExcerpt: "gravity loves you / so I let myself fall",
            mockLyrics: [
                LyricBlock(id: "ly1", label: "Verse 1", lines: [
                    "soft static on the shoreline glow",
                    "the moon keeps time, the tide moves slow",
                    "I traced your name in silver foam",
                    "the ocean hummed and called us home"]),
                LyricBlock(id: "ly2", label: "Chorus", lines: [
                    "gravity loves you, so I let myself fall",
                    "no need for a reason, no need at all",
                    "spinning in the quiet, weightless and true",
                    "gravity loves you, and so do I too"]),
                LyricBlock(id: "ly3", label: "Bridge", lines: [
                    "if the stars go out, I'll still know where you are",
                    "you're the low blue light, the nearest far"]),
            ],
            linerNotes: "Recorded over three foggy nights in a Portland attic with the windows open. We left the reverb tails long on purpose — the room was part of the band. Play it loud, then play it quiet, then play it again at 3am.",
            thankYous: "Endless love to mom, to the attic, to everyone who ever lent us a tape machine. To you, holding this sleeve — you made it real.",
            behindTheSong: BehindSongNote(id: "bs1", heading: "The night it arrived",
                body: "It started as a voice memo of waves and a half-asleep melody. I almost deleted it. Instead I sang the chorus into a broken mic and the whole song fell out in twenty minutes. Some songs you write; this one we just caught."),
            credits: [
                CreditLine(id: "c1", role: "Written by", name: "LUNA TIDE"),
                CreditLine(id: "c2", role: "Produced by", name: "LUNA TIDE & Hollow Gauze"),
                CreditLine(id: "c3", role: "Mixed by", name: "Pale Light Audio"),
                CreditLine(id: "c4", role: "Cover art", name: "Aria Vale (collage)"),
            ],
            visualSymbols: ["moon.stars.fill", "drop.fill", "sparkle", "waveform.path.ecg"],
            insidePanels: [
                SleevePanel(id: "p1", kind: "art", title: "Inside spread", artSeed: "luna inside spread", caption: "A double-page wash of tide-pool blues."),
                SleevePanel(id: "p2", kind: "note", title: "Hidden detail", artSeed: "luna hidden", caption: "Look closely at the foam — there's a tiny constellation only fans noticed."),
            ],
            videoId: "mv-s3",
            supporterBonus: "Supporters unlock the attic demo + a high-res gatefold print (placeholder).",
            fanReactions: ["this is the cover of the year", "the hidden constellation made me cry", "first thing I've wanted to OWN in years"]),

        // Handmade zine — Velvet Static · Static & Gold
        SongSleeve(
            id: "sl-s5", songId: "s5", artistId: "a3", title: "Static & Gold", artistName: "Velvet Static",
            era: .handmade, coverArtSeed: "Static & Gold sleeve",
            tagline: "cut + paste / xeroxed at the laundromat",
            lyricExcerpt: "we were static, we were gold / two voices in the cold",
            mockLyrics: [
                LyricBlock(id: "ly1", label: "Verse 1", lines: [
                    "amp hum and a busted fuzz",
                    "we played too loud just because",
                    "the ceiling rattled, the cat ran",
                    "we caught it live on a borrowed cam"]),
                LyricBlock(id: "ly2", label: "Chorus", lines: [
                    "we were static, we were gold",
                    "two voices in the cold",
                    "turn it up until it breaks",
                    "that's the sound a young heart makes"]),
            ],
            linerNotes: "Glued together at the kitchen table at 2am. The smudges are real. If the lyric sheet is crooked, that's because it is. We wouldn't change a thing.",
            thankYous: "Thanks to the laundromat that let us use the copier, to Mohawk for the floor space, and to LUNA TIDE for the second voice that finished the song.",
            behindTheSong: BehindSongNote(id: "bs1", heading: "A zine, not a product",
                body: "We grew up trading hand-made zines in record-store stairwells. This sleeve is our love letter to that — staples, marker, and all."),
            credits: [
                CreditLine(id: "c1", role: "Written by", name: "Velvet Static"),
                CreditLine(id: "c2", role: "Feature", name: "LUNA TIDE"),
                CreditLine(id: "c3", role: "Recorded by", name: "Garage Static"),
                CreditLine(id: "c4", role: "Collage", name: "the whole band, badly"),
            ],
            visualSymbols: ["scissors", "guitars", "flame.fill", "doc.on.doc"],
            insidePanels: [
                SleevePanel(id: "p1", kind: "art", title: "Lyric scrawl", artSeed: "static scrawl", caption: "Handwritten lyrics, coffee-stained on purpose."),
            ],
            videoId: "mv-collab",
            supporterBonus: "Supporters get a numbered, hand-stamped zine page (placeholder).",
            fanReactions: ["the staples!! the SMUDGES!!", "feels like a record store stairwell in 2003", "bought it just to hold it"]),

        // Cyber zine — NOVA REIGN · Neon Bloodstream
        SongSleeve(
            id: "sl-s1", songId: "s1", artistId: "a1", title: "Neon Bloodstream", artistName: "NOVA REIGN",
            era: .cyberZine, coverArtSeed: "Neon Bloodstream sleeve",
            tagline: "single + video / system overload",
            lyricExcerpt: "neon in my bloodstream / running like a live wire",
            mockLyrics: [
                LyricBlock(id: "ly1", label: "Drop", lines: [
                    "neon in my bloodstream",
                    "running like a live wire",
                    "city's a circuit, I'm the spark",
                    "burning every monitor in the dark"]),
                LyricBlock(id: "ly2", label: "Chorus", lines: [
                    "overload, overload",
                    "watch the whole grid glow",
                    "I don't fade, I don't dim",
                    "I'm the surge, I'm the hymn"]),
            ],
            linerNotes: "Built entirely in the box at 4am with the lights off. Every sound is a screenshot of a feeling. Render it at full brightness.",
            thankYous: "To the crowd that lights their phones when the power cuts — you ARE the bloodstream.",
            behindTheSong: BehindSongNote(id: "bs1", heading: "Maximalism on purpose",
                body: "People said it was too much. That was the point. I wanted a song that felt like a city overclocking."),
            credits: [
                CreditLine(id: "c1", role: "Written & produced by", name: "NOVA REIGN"),
                CreditLine(id: "c2", role: "Vocal design", name: "GLITCHCORE KID"),
                CreditLine(id: "c3", role: "Video directed by", name: "Chrome Highway Films"),
            ],
            visualSymbols: ["bolt.fill", "cpu.fill", "tv.fill", "sparkles"],
            insidePanels: [
                SleevePanel(id: "p1", kind: "art", title: "Glitch spread", artSeed: "nova glitch", caption: "Datamoshed self-portrait. Stare for the hidden frame."),
                SleevePanel(id: "p2", kind: "note", title: "Easter egg", artSeed: "nova egg", caption: "A QR-style sigil that 'unlocks' the alt mix (placeholder)."),
            ],
            videoId: "mv-s1",
            supporterBonus: "Supporters unlock the alt 'overclock' mix + animated cover loop (placeholder).",
            fanReactions: ["this should be on a TV wall", "the datamosh frame is unreal", "first single that felt like a WORLD"]),

        // 90s CD booklet — Sable Mirage · 3AM Confessions
        SongSleeve(
            id: "sl-s7", songId: "s7", artistId: "a6", title: "3AM Confessions", artistName: "Sable Mirage",
            era: .cd90s, coverArtSeed: "3AM Confessions sleeve",
            tagline: "Track 4 · liner notes inside",
            lyricExcerpt: "3am, the city's confession booth / I tell the dark the honest truth",
            mockLyrics: [
                LyricBlock(id: "ly1", label: "Verse 1", lines: [
                    "phone face down, the ceiling fan",
                    "I rehearse the words I never can",
                    "smoke curls slow in the streetlight gold",
                    "the quiet keeps the things I hold"]),
                LyricBlock(id: "ly2", label: "Chorus", lines: [
                    "3am, the city's confession booth",
                    "I tell the dark the honest truth",
                    "no one answers, that's alright",
                    "some prayers are just for the night"]),
                LyricBlock(id: "ly3", label: "Outro", lines: [
                    "fade the fan, fade the gold",
                    "keep the secrets, let them fold"]),
            ],
            linerNotes: "Tracked to tape, then bounced to a CD-R and listened to in a parked car — that's the real test. Read the lyrics with the booklet open like it's 1997.",
            thankYous: "Special thanks to the late-night radio host who played the demo, to my sister for the harmonies, and to anyone who's ever confessed something to an empty room.",
            behindTheSong: BehindSongNote(id: "bs1", heading: "Recorded in one take",
                body: "I'd written it three times and hated it. The version you hear is the throwaway take at 3am with the wrong mic. Sometimes tired tells the truth."),
            credits: [
                CreditLine(id: "c1", role: "Written by", name: "Sable Mirage"),
                CreditLine(id: "c2", role: "Produced by", name: "Velvet Hour"),
                CreditLine(id: "c3", role: "Harmonies", name: "Amani Mirage"),
                CreditLine(id: "c4", role: "Mastered by", name: "Smoke & Mirrors Mastering"),
            ],
            visualSymbols: ["opticaldisc", "moon.fill", "smoke.fill", "music.mic"],
            insidePanels: [
                SleevePanel(id: "p1", kind: "art", title: "Booklet pages", artSeed: "sable booklet", caption: "Four-panel fold-out with full lyrics + photos."),
                SleevePanel(id: "p2", kind: "note", title: "Tray card", artSeed: "sable tray", caption: "Thank-yous hidden under the disc tray, the old-school way."),
            ],
            videoId: "mv-s7",
            supporterBonus: "Supporters unlock the booklet PDF + the parked-car demo (placeholder).",
            fanReactions: ["I can smell the CD booklet", "the one-take take is everything", "this belongs in a jewel case"]),

        // 70s cosmic vinyl gatefold — Kairo Sol · Heritage
        SongSleeve(
            id: "sl-s6", songId: "s6", artistId: "a2", title: "Heritage (feat. Ami)", artistName: "Kairo Sol",
            era: .vinyl70s, coverArtSeed: "Heritage sleeve",
            tagline: "Gatefold · Side A / cosmic groove",
            lyricExcerpt: "log drum gospel, ancestral light / we dance the diaspora into the night",
            mockLyrics: [
                LyricBlock(id: "ly1", label: "Movement I", lines: [
                    "log drum gospel, ancestral light",
                    "we dance the diaspora into the night",
                    "hands in the air like a prayer set free",
                    "the rhythm remembers what the books can't see"]),
                LyricBlock(id: "ly2", label: "Refrain", lines: [
                    "heritage, heritage, carry it on",
                    "from the rooftop sunrise to the basement dawn"]),
            ],
            linerNotes: "Cut for vinyl and meant for a gatefold. Lay the sleeve open, drop the needle, and let Side A play all the way through. This is a record, not a playlist.",
            thankYous: "To the elders, the rooftops, and Ami's voice. To Brooklyn at 2am. To the groove that connects us.",
            behindTheSong: BehindSongNote(id: "bs1", heading: "A continuous Side A",
                body: "We built the whole side as one journey — no skips. The log drum is sampled from a session with three generations of players in one room."),
            credits: [
                CreditLine(id: "c1", role: "Written by", name: "Kairo Sol & Ami"),
                CreditLine(id: "c2", role: "Featured vocals", name: "Ami"),
                CreditLine(id: "c3", role: "Percussion", name: "The Heritage Players"),
                CreditLine(id: "c4", role: "Lacquer cut by", name: "Golden Pulse Mastering"),
            ],
            visualSymbols: ["sun.max.fill", "circle.circle", "hands.sparkles.fill", "music.quarternote.3"],
            insidePanels: [
                SleevePanel(id: "p1", kind: "art", title: "Gatefold interior", artSeed: "heritage gatefold", caption: "Sun-drenched interior painting that wraps both panels."),
                SleevePanel(id: "p2", kind: "note", title: "Liner essay", artSeed: "heritage essay", caption: "A short essay on diaspora dance printed on the inner sleeve."),
            ],
            videoId: "mv-s6",
            supporterBonus: "Supporters unlock the full continuous Side A + gatefold artwork (placeholder).",
            fanReactions: ["a GATEFOLD. in 2026. yes.", "played Side A straight through, no skips", "the inner essay is a keeper"]),

        // Scene flyer — GLITCHCORE KID · lol nothing matters
        SongSleeve(
            id: "sl-s8", songId: "s8", artistId: "a7", title: "lol nothing matters", artistName: "GLITCHCORE KID",
            era: .sceneFlyer, coverArtSeed: "lol nothing matters sleeve",
            tagline: "DIY flyer / basement show single",
            lyricExcerpt: "lol nothing matters / so I scream it til it does",
            mockLyrics: [
                LyricBlock(id: "ly1", label: "Yell", lines: [
                    "alarm clock heart, dead phone soul",
                    "i made a hit in a bedroom hole",
                    "everyone's online, no one's awake",
                    "i'll be a legend for the irony's sake"]),
                LyricBlock(id: "ly2", label: "Chorus", lines: [
                    "lol nothing matters",
                    "so i scream it til it does",
                    "turn the autotune to glass",
                    "and shatter it just because"]),
            ],
            linerNotes: "Designed like a basement-show flyer because that's where this lives. Photocopy it, tape it to a pole, come to the show.",
            thankYous: "shoutout to the group chat, the one venue that books all-ages, and everyone who screamed the words back.",
            behindTheSong: BehindSongNote(id: "bs1", heading: "Made in 40 minutes",
                body: "Made it as a joke for the group chat. The joke got 540k plays. The joke is on me, and I love it."),
            credits: [
                CreditLine(id: "c1", role: "Everything by", name: "GLITCHCORE KID"),
                CreditLine(id: "c2", role: "Flyer design", name: "the group chat"),
                CreditLine(id: "c3", role: "Moral support", name: "energy drinks"),
            ],
            visualSymbols: ["doc.richtext.fill", "bolt.heart.fill", "person.3.fill", "exclamationmark.bubble.fill"],
            insidePanels: [
                SleevePanel(id: "p1", kind: "art", title: "Flyer back", artSeed: "glitch flyer back", caption: "Show dates + a maze you can actually solve."),
            ],
            videoId: "mv-s8",
            supporterBonus: "Supporters get a printable show flyer + the 40-minute original render (placeholder).",
            fanReactions: ["taped this to my locker", "the maze on the back is solvable??", "a JOKE that became a SCENE"]),
    ]

    static func sleeve(_ id: String) -> SongSleeve? { sleeves.first { $0.id == id } }
    static func sleeve(forSong songId: String) -> SongSleeve? { sleeves.first { $0.songId == songId } }

    // MARK: - Music Videos (VYBE TV / Video Lounge — mock placeholders)

    static let musicVideos: [MusicVideo] = [
        MusicVideo(id: "mv-s1", songId: "s1", artistId: "a1", title: "Neon Bloodstream", artistName: "NOVA REIGN",
                   durationSec: 198, previewSeed: "Neon Bloodstream video", status: .premiere, scene: "Los Angeles",
                   behindTheVideo: "Shot on one neon-lit night in a downtown parking structure. 400 fans showed up to be the crowd.", reactions: 4_210),
        MusicVideo(id: "mv-s3", songId: "s3", artistId: "a4", title: "Gravity Loves You", artistName: "LUNA TIDE",
                   durationSec: 247, previewSeed: "Gravity Loves You video", status: .newRelease, scene: "Portland",
                   behindTheVideo: "Filmed at dawn on the coast with a single handheld camera and a lot of fog.", reactions: 1_980),
        MusicVideo(id: "mv-collab", songId: nil, artistId: "a3", title: "Static & Gold (feat. LUNA TIDE)", artistName: "Velvet Static × LUNA TIDE",
                   durationSec: 233, previewSeed: "Static & Gold video", status: .bornOnVYBE, scene: "Austin",
                   behindTheVideo: "The collab that started as a VYBE Collab Lab challenge — shot on Super-8 in a laundromat.", reactions: 3_560),
        MusicVideo(id: "mv-s8", songId: "s8", artistId: "a7", title: "lol nothing matters", artistName: "GLITCHCORE KID",
                   durationSec: 142, previewSeed: "lol nothing matters video", status: .underground, scene: "Chicago",
                   behindTheVideo: "Filmed on three phones at an all-ages basement show. The mosh pit is real.", reactions: 980),
        MusicVideo(id: "mv-s6", songId: "s6", artistId: "a2", title: "Heritage (feat. Ami)", artistName: "Kairo Sol",
                   durationSec: 264, previewSeed: "Heritage video", status: .newRelease, scene: "Brooklyn",
                   behindTheVideo: "A rooftop-to-basement single take following the dance from sunset to sunrise.", reactions: 2_640),
        MusicVideo(id: "mv-s7", songId: "s7", artistId: "a6", title: "3AM Confessions", artistName: "Sable Mirage",
                   durationSec: 219, previewSeed: "3AM Confessions video", status: .classic, scene: "Atlanta",
                   behindTheVideo: "One static shot of a parked car at 3am. Nothing happens. Everything happens.", reactions: 5_120),
        MusicVideo(id: "mv-s4", songId: "s4", artistId: "a5", title: "Subwoofer Gospel", artistName: "BASSLINE PROPHET",
                   durationSec: 176, previewSeed: "Subwoofer Gospel video", status: .premiere, scene: "Detroit",
                   behindTheVideo: "Filmed inside a cathedral with a sound system that shook dust off the rafters.", reactions: 3_010),
        MusicVideo(id: "mv-s2", songId: "s2", artistId: "a8", title: "Midnight Caracas", artistName: "Marisol Vega",
                   durationSec: 211, previewSeed: "Midnight Caracas video", status: .classic, scene: "Miami",
                   behindTheVideo: "A block-party shoot that turned into an actual block party.", reactions: 8_900),
        MusicVideo(id: "mv-glitch2", songId: nil, artistId: "a7", title: "error404heart", artistName: "GLITCHCORE KID",
                   durationSec: 133, previewSeed: "error404heart video", status: .underground, scene: "Chicago",
                   behindTheVideo: "A webcam premiere streamed to 12 people. Now it's a cult clip.", reactions: 620),
    ]

    static func video(_ id: String) -> MusicVideo? { musicVideos.first { $0.id == id } }
    static func videos(for artistId: String) -> [MusicVideo] { musicVideos.filter { $0.artistId == artistId } }
}
