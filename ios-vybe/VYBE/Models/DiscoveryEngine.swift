//
//  DiscoveryEngine.swift
//  VYBE
//
//  Feature #17 — "Unknowns Like Your Favorites".
//
//  Generates a deep pool of lesser-known artists with full sonic profiles, and
//  scores them against a fan's favorites so obscure acts that *sound like* the
//  favorites rise to the top:
//
//    similarity = 0.40·genre + 0.25·sonicTags + 0.20·moodTags + 0.15·energy-closeness
//    score      = similarity · (1 + 0.6·(1 − normalizedMonthlyListeners))   ← underground boost
//
//  Plus a min-similarity filter, a per-genre/per-city diversity cap, and a
//  ~1-in-6 wildcard slot for taste expansion. Everything is deterministic so the
//  catalog and rankings are stable across launches.
//

import SwiftUI

// MARK: - Deterministic RNG

/// Tiny SplitMix64-style generator so mock data is rich yet reproducible.
struct SeededGen {
    private var state: UInt64
    init(_ seed: UInt64) { state = seed &+ 0x9E3779B97F4A7C15 }

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
    mutating func int(_ range: ClosedRange<Int>) -> Int {
        let span = UInt64(range.upperBound - range.lowerBound + 1)
        return range.lowerBound + Int(next() % span)
    }
    mutating func double(_ a: Double, _ b: Double) -> Double {
        a + (b - a) * (Double(next() % 100_000) / 100_000.0)
    }
    mutating func pick<T>(_ arr: [T]) -> T { arr[Int(next() % UInt64(arr.count))] }
    mutating func chance(_ p: Double) -> Bool { double(0, 1) < p }
}

// MARK: - Genre families

/// A genre "family" that seeds both the anchor artists and the generated catalog.
struct GenreFamily {
    let genre: String
    let subgenres: [String]
    let sonicTags: [String]
    let moodTags: [String]
    let baseEnergy: Int
    let anchors: [String]          // famous taste reference points
    let adjectives: [String]
    let nouns: [String]
    let songWords: [String]
    let bio: String                // "{genre}" / "{city}" templated
}

enum Discovery {

    /// Stable, process-independent hash (FNV-1a) so seeded data is reproducible.
    /// (Swift's `String.hashValue` is randomized per launch and can trap on `abs`.)
    static func stableHash(_ s: String) -> UInt64 {
        var h: UInt64 = 1_469_598_103_934_665_603
        for b in s.utf8 { h = (h ^ UInt64(b)) &* 1_099_511_628_211 }
        return h
    }

    static let families: [GenreFamily] = [
        GenreFamily(
            genre: "Hyperpop",
            subgenres: ["Electropop", "Glitch Pop", "Digicore"],
            sonicTags: ["maximalist", "autotuned", "synthetic", "explosive"],
            moodTags: ["Euphoric", "Hype", "Chaotic"], baseEnergy: 88,
            anchors: ["Charli XCX", "SOPHIE", "100 gecs", "A. G. Cook"],
            adjectives: ["Neon", "Hyper", "Cyber", "Sugar", "Plastic", "Laser"],
            nouns: ["Bloom", "Crush", "Angel", "Riot", "Candy", "Static"],
            songWords: ["Sugar Rush", "Hyperreal", "Plastic Heart", "Neon Cry", "Overclocked", "Candy Static"],
            bio: "Maximalist {genre} made loud in a {city} bedroom — autotune, glitter, and glitch."),
        GenreFamily(
            genre: "Dream Pop",
            subgenres: ["Ambient Pop", "Shoegaze", "Slowcore"],
            sonicTags: ["reverb-drenched", "ethereal", "hazy", "lush"],
            moodTags: ["Dreamy", "Calm", "Nostalgic"], baseEnergy: 35,
            anchors: ["Beach House", "Cocteau Twins", "Mazzy Star", "Slowdive"],
            adjectives: ["Velvet", "Lunar", "Pale", "Soft", "Hollow", "Gauze"],
            nouns: ["Tide", "Haze", "Bloom", "Halo", "Glass", "Echo"],
            songWords: ["Slow Halo", "Underwater", "Pale Light", "Reverie", "Soft Static", "Moonlit"],
            bio: "Ethereal {genre} from {city} — reverb, longing, and slow-motion color."),
        GenreFamily(
            genre: "Indie Rock",
            subgenres: ["Shoegaze", "Garage Rock", "Post-Punk"],
            sonicTags: ["fuzzy guitars", "lo-fi", "jangly", "analog warmth"],
            moodTags: ["Nostalgic", "Moody", "Inspired"], baseEnergy: 60,
            anchors: ["Tame Impala", "The Strokes", "Phoebe Bridgers", "DIIV"],
            adjectives: ["Paper", "Rust", "Wild", "Static", "Amber", "Loose"],
            nouns: ["Tigers", "Houses", "Wires", "Gold", "Saints", "Echoes"],
            songWords: ["Paper Tigers", "Rust & Gold", "Slow Burn", "Amber Light", "Loose Wires", "Hometown Static"],
            bio: "Fuzzed-out {genre} out of {city} — analog warmth and emotional honesty."),
        GenreFamily(
            genre: "R&B",
            subgenres: ["Neo-Soul", "Alt R&B", "Bedroom Soul"],
            sonicTags: ["smooth", "velvety", "sultry", "warm"],
            moodTags: ["Intimate", "Sultry", "Romantic"], baseEnergy: 45,
            anchors: ["SZA", "Frank Ocean", "Sade", "Steve Lacy"],
            adjectives: ["Silk", "Velvet", "Honey", "Midnight", "Smoke", "Amber"],
            nouns: ["Hour", "Confession", "Skyline", "Letter", "Mirror", "Slow"],
            songWords: ["Velvet Hour", "Slow Confession", "Honey Skyline", "3AM Letter", "Smoke & Mirrors", "Amber Slow"],
            bio: "Smooth, smoky {genre} for 3am thoughts — recorded late in {city}."),
        GenreFamily(
            genre: "Afro-House",
            subgenres: ["Amapiano", "Deep House", "Afrobeats"],
            sonicTags: ["percussive", "hypnotic", "soulful", "log-drum"],
            moodTags: ["Groovy", "Flowing", "Euphoric"], baseEnergy: 73,
            anchors: ["Black Coffee", "Burna Boy", "Major League DJz", "DJ Lag"],
            adjectives: ["Golden", "Sun", "Night", "River", "Soul", "Heritage"],
            nouns: ["Drum", "Pulse", "Groove", "Tide", "Heat", "Ritual"],
            songWords: ["Log Drum Gospel", "Golden Pulse", "Night Ritual", "River Groove", "Soul Heat", "Heritage"],
            bio: "Late-night {genre} from {city} — log drums, soul, and connection."),
        GenreFamily(
            genre: "Dubstep",
            subgenres: ["Riddim", "Bass Music", "Tearout"],
            sonicTags: ["heavy bass", "wobble", "distorted", "explosive"],
            moodTags: ["Aggressive", "Hype", "Chaotic"], baseEnergy: 96,
            anchors: ["Skrillex", "Excision", "Flux Pavilion", "Subtronics"],
            adjectives: ["Concrete", "Iron", "Void", "Seismic", "Brute", "Sub"],
            nouns: ["Gospel", "Cathedral", "Quake", "Prophet", "Engine", "Throne"],
            songWords: ["Subwoofer Gospel", "Seismic", "Void Engine", "Concrete Quake", "Iron Throne", "Tearout"],
            bio: "{city} bass merchant — the drop is a religion and the floor is shaking."),
        GenreFamily(
            genre: "Reggaeton",
            subgenres: ["Latin Pop", "Dembow", "Neoperreo"],
            sonicTags: ["dembow", "bilingual", "percussive", "sultry"],
            moodTags: ["Sultry", "Hype", "Confident"], baseEnergy: 82,
            anchors: ["Bad Bunny", "Rosalía", "J Balvin", "Tokischa"],
            adjectives: ["Fuego", "Calor", "Luna", "Reina", "Ritmo", "Sabor"],
            nouns: ["Caracas", "Verano", "Perreo", "Corazón", "Noche", "Fiebre"],
            songWords: ["Calor de Verano", "Perreo Intenso", "Luna Llena", "Ritmo y Sabor", "Fiebre", "Corazón Frío"],
            bio: "Heat in every beat — {genre} from {city} with a global pulse."),
        GenreFamily(
            genre: "Ambient",
            subgenres: ["Downtempo", "Drone", "New Age"],
            sonicTags: ["atmospheric", "textural", "meditative", "slow-build"],
            moodTags: ["Calm", "Dreamy", "Flowing"], baseEnergy: 20,
            anchors: ["Bonobo", "Tycho", "Brian Eno", "Jon Hopkins"],
            adjectives: ["Glacier", "Quiet", "Slow", "Deep", "Still", "Aero"],
            nouns: ["Field", "Drift", "Floor", "Bloom", "Current", "Horizon"],
            songWords: ["Quiet Field", "Slow Drift", "Ocean Floor", "Still Bloom", "Deep Current", "Horizon Line"],
            bio: "Textural {genre} from {city} — built for headphones and quiet hours."),
        GenreFamily(
            genre: "Electronic",
            subgenres: ["Future Bass", "Melodic House", "Synthwave"],
            sonicTags: ["lush synths", "euphoric build", "melodic", "cinematic"],
            moodTags: ["Euphoric", "Flowing", "Inspired"], baseEnergy: 75,
            anchors: ["ODESZA", "Flume", "Disclosure", "The Midnight"],
            adjectives: ["Aurora", "Prism", "Solar", "Chrome", "Crystal", "Vapor"],
            nouns: ["Bloom", "Drive", "Skyline", "Pulse", "Mirage", "Signal"],
            songWords: ["Aurora Drive", "Prism Bloom", "Solar Skyline", "Chrome Pulse", "Crystal Signal", "Vapor"],
            bio: "Lush, euphoric {genre} from {city} — built for the build and the drop."),
        GenreFamily(
            genre: "Hip-Hop",
            subgenres: ["Cloud Rap", "Boom Bap", "Jazz Rap"],
            sonicTags: ["boom-bap", "lyrical", "jazzy samples", "hazy"],
            moodTags: ["Confident", "Moody", "Inspired"], baseEnergy: 62,
            anchors: ["Tyler, the Creator", "Earl Sweatshirt", "MF DOOM", "Mac Miller"],
            adjectives: ["Velour", "Dusty", "Late", "Gold", "Smoke", "Loose"],
            nouns: ["Tape", "Bodega", "Cipher", "Vinyl", "Block", "Daydream"],
            songWords: ["Dusty Tape", "Bodega Daydream", "Gold Cipher", "Late Vinyl", "Smoke Break", "Block Diary"],
            bio: "Jazzy, lyrical {genre} from {city} — dusty samples and a real pen."),
        GenreFamily(
            genre: "Bedroom Pop",
            subgenres: ["Lo-fi Pop", "Indie Pop", "Jangle Pop"],
            sonicTags: ["lo-fi", "intimate", "warm", "DIY"],
            moodTags: ["Dreamy", "Intimate", "Nostalgic"], baseEnergy: 42,
            anchors: ["Clairo", "Cuco", "Rex Orange County", "boy pablo"],
            adjectives: ["Peach", "Soft", "Cozy", "Pastel", "Sweater", "Slow"],
            nouns: ["Diary", "Window", "Polaroid", "Sunday", "Crush", "Backseat"],
            songWords: ["Peach Diary", "Slow Sunday", "Polaroid", "Backseat Crush", "Soft Window", "Sweater Weather"],
            bio: "DIY {genre} recorded in a {city} bedroom — warm, intimate, and honest."),
        GenreFamily(
            genre: "Synthwave",
            subgenres: ["Darkwave", "Retrowave", "Outrun"],
            sonicTags: ["retro synths", "neon", "driving", "cinematic"],
            moodTags: ["Moody", "Confident", "Nostalgic"], baseEnergy: 68,
            anchors: ["The Midnight", "Crystal Castles", "HEALTH", "Kavinsky"],
            adjectives: ["Chrome", "Midnight", "Vapor", "Neon", "Electric", "Cobalt"],
            nouns: ["Highway", "Mirage", "Arcade", "Ghost", "Drive", "Skyline"],
            songWords: ["Chrome Highway", "Neon Ghost", "Midnight Drive", "Arcade Mirage", "Cobalt Skyline", "Outrun"],
            bio: "Neon-lit {genre} from {city} — retro synths and cinematic drive."),
    ]

    /// Find a family by genre or subgenre keyword (used for "sounds like <genre>" search).
    static func family(matching q: String) -> GenreFamily? {
        let needle = q.lowercased()
        return families.first { fam in
            fam.genre.lowercased() == needle
                || fam.genre.lowercased().contains(needle)
                || needle.contains(fam.genre.lowercased())
                || fam.subgenres.contains { $0.lowercased().contains(needle) || needle.contains($0.lowercased()) }
        }
    }

    // MARK: - Anchor artists (famous reference points only)

    static let anchors: [AnchorArtist] = {
        var out: [AnchorArtist] = []
        for fam in families {
            for (i, name) in fam.anchors.enumerated() {
                var g = SeededGen(stableHash(name))
                let energy = max(8, min(100, fam.baseEnergy + g.int(-8...8)))
                out.append(AnchorArtist(
                    id: "anchor-\(fam.genre.lowercased())-\(i)",
                    name: name, genre: fam.genre, subgenres: fam.subgenres,
                    sonicTags: fam.sonicTags, moodTags: fam.moodTags, energy: energy))
            }
        }
        return out
    }()

    // MARK: - Procedural underground catalog

    static let cities = ["Los Angeles", "Brooklyn", "Austin", "Portland", "Detroit", "Atlanta",
                         "Chicago", "Miami", "Seattle", "Oakland", "Nashville", "Denver",
                         "New Orleans", "Philadelphia", "Minneapolis", "Toronto", "London",
                         "Berlin", "Mexico City", "São Paulo"]

    /// ~90 generated underground/undiscovered artists with full sonic profiles.
    static let generatedArtists: [Artist] = {
        var out: [Artist] = []
        var usedNames = Set<String>(["NOVA REIGN", "Kairo Sol", "Velvet Static", "LUNA TIDE",
                                     "BASSLINE PROPHET", "Sable Mirage", "GLITCHCORE KID", "Marisol Vega"])
        var idx = 0
        for (fi, fam) in families.enumerated() {
            let perFamily = 8
            for k in 0..<perFamily {
                var g = SeededGen(UInt64(fi * 1000 + k * 7 + 31))

                // Unique on-brand name.
                var name = ""
                for _ in 0..<8 {
                    let candidate = "\(g.pick(fam.adjectives)) \(g.pick(fam.nouns))"
                    if !usedNames.contains(candidate) { name = candidate; break }
                }
                if name.isEmpty { name = "\(g.pick(fam.adjectives)) \(g.pick(fam.nouns)) \(k)" }
                usedNames.insert(name)
                idx += 1
                let id = "g\(idx)"

                // Tier distribution: 50% undiscovered, 35% underground, 15% rising.
                let roll = g.double(0, 1)
                let tier: String
                let listeners: Int
                if roll < 0.50 { tier = "undiscovered"; listeners = g.int(420...4_900) }
                else if roll < 0.85 { tier = "underground"; listeners = g.int(5_200...49_000) }
                else { tier = "rising"; listeners = g.int(52_000...248_000) }

                let energy = max(8, min(100, fam.baseEnergy + g.int(-12...12)))
                let supporters = max(20, Int(Double(listeners) * g.double(0.025, 0.06)))
                let fanFunded = supporters * g.int(9...24)
                let streamingEquiv = max(1, Int(Double(listeners) * 0.012))   // ~3 streams · $0.004
                let followers = Int(Double(listeners) * g.double(0.28, 0.5))

                // 1–2 taste anchors.
                let nAnchors = g.chance(0.55) ? 2 : 1
                var soundsLike: [String] = []
                for _ in 0..<nAnchors {
                    let a = g.pick(fam.anchors)
                    if !soundsLike.contains(a) { soundsLike.append(a) }
                }

                let subs = Array(fam.subgenres.shuffledSeeded(&g).prefix(2))
                let moods = Array(fam.moodTags.shuffledSeeded(&g).prefix(g.chance(0.5) ? 3 : 2))
                let sonics = Array(fam.sonicTags.shuffledSeeded(&g).prefix(3))

                let rising = tier == "rising" || (tier == "underground" && g.chance(0.35))

                out.append(Artist(
                    id: id, name: name, handle: "@" + name.lowercased().replacingOccurrences(of: " ", with: ""),
                    genre: fam.genre, city: g.pick(cities),
                    bio: fam.bio.replacingOccurrences(of: "{genre}", with: fam.genre),
                    monthlyListeners: listeners, followers: followers,
                    isVerified: tier == "rising" && g.chance(0.35),
                    aiEnabled: g.chance(0.22),
                    isUndergroundRising: rising,
                    tags: [fam.genre] + Array(subs.prefix(1)),
                    aiPersona: "Independent \(fam.genre.lowercased()) artist. Talks craft, the local scene, and building a real fanbase.",
                    subgenres: subs, moodTags: moods, sonicTags: sonics, energy: energy,
                    soundsLike: soundsLike, fanFundedMonthlyUSD: fanFunded,
                    streamingEquivUSD: streamingEquiv, popularityTier: tier))
            }
        }
        // Fill in {city} in bios now that each artist has a city.
        return out.map { a in
            var a = a
            a.bio = a.bio.replacingOccurrences(of: "{city}", with: a.city)
            return a
        }
    }()

    /// 2–3 tracks per generated artist so their profiles never feel empty.
    static let generatedSongs: [Song] = {
        var out: [Song] = []
        for art in generatedArtists {
            guard let fam = families.first(where: { $0.genre == art.genre }) else { continue }
            var g = SeededGen(stableHash(art.id))
            let count = g.int(2...3)
            var titles = Set<String>()
            for j in 0..<count {
                var title = g.pick(fam.songWords)
                var guard0 = 0
                while titles.contains(title) && guard0 < 6 { title = g.pick(fam.songWords); guard0 += 1 }
                titles.insert(title)
                out.append(Song(
                    id: "sg-\(art.id)-\(j)", title: title, artistId: art.id, artistName: art.name,
                    genre: art.genre, mood: g.pick(art.moodTags.isEmpty ? ["Euphoric"] : art.moodTags),
                    energy: max(5, min(100, art.energy + g.int(-8...8))),
                    durationSec: g.int(148...312),
                    plays: max(120, art.monthlyListeners * g.int(1...5)),
                    isViral: art.isUndergroundRising && g.chance(0.12),
                    releasedDaysAgo: g.int(1...140)))
            }
        }
        return out
    }()

    // MARK: - Similarity scoring

    static let listenersCap = 260_000.0

    private static func jaccard(_ a: [String], _ b: [String]) -> Double {
        if a.isEmpty && b.isEmpty { return 0 }
        let sa = Set(a.map { $0.lowercased() })
        let sb = Set(b.map { $0.lowercased() })
        let uni = sa.union(sb).count
        return uni == 0 ? 0 : Double(sa.intersection(sb).count) / Double(uni)
    }

    /// Content similarity in 0…1 using the spec's weighting.
    static func similarity(_ candidate: SonicVector, _ anchor: SonicVector) -> Double {
        let genreScore: Double = candidate.genre.lowercased() == anchor.genre.lowercased()
            ? 1.0 : jaccard(candidate.subgenres, anchor.subgenres)
        let sonicScore = jaccard(candidate.sonicTags, anchor.sonicTags)
        let moodScore = jaccard(candidate.moodTags, anchor.moodTags)
        let energyCloseness = 1.0 - Double(abs(candidate.energy - anchor.energy)) / 100.0
        return 0.40 * genreScore + 0.25 * sonicScore + 0.20 * moodScore + 0.15 * energyCloseness
    }

    /// Underground boost: obscure acts get multiplied up so a 3k-listener artist
    /// can outrank a near-identical 250k one.
    static func undergroundBoost(_ listeners: Int) -> Double {
        let norm = min(1.0, Double(listeners) / listenersCap)
        return 1.0 + 0.6 * (1.0 - norm)
    }

    private static let socialFans = ["glowqueen", "bass_devotee", "sol_seeker", "dreampop_dani",
                                     "neon_nadia", "static_kid", "marisol_mvp", "synthsage"]

    private static func socialSignal(for art: Artist, anchor: String) -> String? {
        var g = SeededGen(stableHash(art.id) ^ stableHash(anchor))
        guard g.chance(0.55) else { return nil }
        let fan = g.pick(socialFans)
        let others = g.int(40...860)
        return "\(fan) +\(others) fans who love \(anchor) also support this artist"
    }

    // MARK: - The engine

    /// Rank lesser-known artists that sound like the fan's favorites.
    static func hiddenGems(favorites: [SonicVector],
                           excluding excluded: Set<String> = [],
                           limit: Int = 24) -> [DiscoveryResult] {
        guard !favorites.isEmpty else { return [] }

        // Candidate pool = lesser-known artists only.
        let pool = Mock.artists.filter { $0.monthlyListeners < Int(listenersCap) && !excluded.contains($0.id) }

        var scored: [DiscoveryResult] = []
        for art in pool {
            var bestSim = -1.0
            var bestName = favorites[0].displayName
            for fav in favorites {
                let s = similarity(art.sonicVector, fav)
                if s > bestSim { bestSim = s; bestName = fav.displayName }
            }
            guard bestSim >= 0.25 else { continue }   // filter weak matches
            let final = bestSim * undergroundBoost(art.monthlyListeners)
            scored.append(DiscoveryResult(
                artist: art, anchorName: bestName, similarity: bestSim, finalScore: final,
                isWildcard: false, socialSignal: socialSignal(for: art, anchor: bestName)))
        }
        scored.sort { $0.finalScore > $1.finalScore }

        // Diversity cap: max 3 per genre and per city.
        var genreCount: [String: Int] = [:]
        var cityCount: [String: Int] = [:]
        var mains: [DiscoveryResult] = []
        var leftovers: [DiscoveryResult] = []
        for r in scored {
            if (genreCount[r.artist.genre] ?? 0) < 3 && (cityCount[r.artist.city] ?? 0) < 3 {
                genreCount[r.artist.genre, default: 0] += 1
                cityCount[r.artist.city, default: 0] += 1
                mains.append(r)
            } else {
                leftovers.append(r)
            }
        }

        // Wildcards: most-obscure acts from genres OUTSIDE the favorites, for taste expansion.
        let favGenres = Set(favorites.map { $0.genre.lowercased() })
        let wildcardPool = scored
            .filter { !favGenres.contains($0.artist.genre.lowercased()) }
            .sorted { $0.artist.monthlyListeners < $1.artist.monthlyListeners }

        // Interleave a wildcard after every 5 mains (~1 in 6).
        var result: [DiscoveryResult] = []
        var wIdx = 0
        for (i, r) in mains.enumerated() {
            result.append(r)
            if result.count >= limit { break }
            if (i + 1) % 5 == 0 {
                while wIdx < wildcardPool.count {
                    let w = wildcardPool[wIdx]; wIdx += 1
                    if result.contains(where: { $0.id == w.id }) { continue }
                    result.append(DiscoveryResult(
                        artist: w.artist, anchorName: w.anchorName, similarity: w.similarity,
                        finalScore: w.finalScore, isWildcard: true,
                        socialSignal: "Wildcard — outside your usual, worth a listen"))
                    break
                }
            }
        }
        if result.count < limit {
            for r in leftovers where !result.contains(where: { $0.id == r.id }) {
                result.append(r)
                if result.count >= limit { break }
            }
        }
        return Array(result.prefix(limit))
    }

    /// Build a fan's default favorites from who they follow (preferring the famous
    /// anchors those artists sound like), falling back to their onboarding taste.
    static func defaultFavorites(followed: Set<String>, taste: OnboardingTaste) -> [SonicVector] {
        var favs: [SonicVector] = []
        var seenNames = Set<String>()
        for art in Mock.artists where followed.contains(art.id) {
            let display = art.soundsLike.first ?? art.name
            guard !seenNames.contains(display) else { continue }
            seenNames.insert(display)
            var v = art.sonicVector
            v.displayName = display
            favs.append(v)
        }
        if favs.isEmpty {
            for genre in taste.favoriteGenres {
                if let fam = family(matching: genre) {
                    favs.append(SonicVector(displayName: fam.anchors.first ?? genre, genre: fam.genre,
                                            subgenres: fam.subgenres, sonicTags: fam.sonicTags,
                                            moodTags: fam.moodTags, energy: fam.baseEnergy))
                }
            }
        }
        // Last resort so the section is never empty in a fresh demo.
        if favs.isEmpty, let fam = families.first {
            favs.append(SonicVector(displayName: fam.anchors.first ?? fam.genre, genre: fam.genre,
                                    subgenres: fam.subgenres, sonicTags: fam.sonicTags,
                                    moodTags: fam.moodTags, energy: fam.baseEnergy))
        }
        return favs
    }
}

private extension Array {
    /// Deterministic Fisher–Yates shuffle driven by a SeededGen.
    func shuffledSeeded(_ g: inout SeededGen) -> [Element] {
        var a = self
        guard a.count > 1 else { return a }
        for i in stride(from: a.count - 1, to: 0, by: -1) {
            let j = g.int(0...i)
            a.swapAt(i, j)
        }
        return a
    }
}
