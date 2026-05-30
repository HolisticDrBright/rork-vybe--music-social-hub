//
//  VYBEDataStore.swift
//  VYBE
//
//  Canonical local data layer.
//
//  Loads the canonical `vybe_mock_data.json` from the app bundle when present
//  (the dataset shipped in Assets/VYBE/), normalizes it into the app's models,
//  and falls back to the rich built-in dataset otherwise. Every screen reads
//  data through `Mock`, which now sources from this store — so dropping the
//  canonical JSON into the target instantly upgrades the whole app with no
//  further code changes.
//
//  To use the canonical dataset: add `vybe_mock_data.json` to the VYBE target
//  (anywhere under ios-vybe/VYBE/ — the synchronized file group bundles it).
//

import Foundation

final class VYBEDataStore {
    static let shared = VYBEDataStore()

    let artists: [Artist]
    let songs: [Song]
    let anchors: [AnchorArtist]
    let moods: [String]
    let genres: [String]
    let cities: [String]
    /// Human-readable provenance for debugging / the settings screen.
    let source: String

    private init() {
        if let raw = Self.loadCanonical(), let mapped = Self.adapt(raw), !mapped.artists.isEmpty {
            artists = mapped.artists
            songs = mapped.songs
            anchors = mapped.anchors.isEmpty ? Discovery.anchors : mapped.anchors
            moods = mapped.moods.isEmpty ? Mock.moods : mapped.moods
            genres = mapped.genres.isEmpty ? Array(Set(mapped.artists.map(\.genre))).sorted() : mapped.genres
            cities = mapped.cities.isEmpty ? Array(Set(mapped.artists.map(\.city))).sorted() : mapped.cities
            source = "canonical vybe_mock_data.json (\(mapped.artists.count) artists, \(mapped.songs.count) songs)"
        } else {
            artists = Mock.featuredArtists + Discovery.generatedArtists
            songs = Mock.featuredSongs + Discovery.generatedSongs
            anchors = Discovery.anchors
            moods = Mock.moods
            genres = Mock.genres
            cities = Discovery.cities
            source = "built-in dataset (\(artists.count) artists)"
        }
    }

    // MARK: - Bundle loading

    private static func loadCanonical() -> RawDataset? {
        guard let url = Bundle.main.url(forResource: "vybe_mock_data", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(RawDataset.self, from: data)
    }

    // MARK: - Normalization / adapter

    private struct Mapped {
        var artists: [Artist]
        var songs: [Song]
        var anchors: [AnchorArtist]
        var moods: [String]
        var genres: [String]
        var cities: [String]
    }

    private static func adapt(_ raw: RawDataset) -> Mapped? {
        let rawArtists = raw.artists ?? []
        guard !rawArtists.isEmpty else { return nil }

        var artists: [Artist] = []
        var songs: [Song] = []

        for (i, ra) in rawArtists.enumerated() {
            let id = ra.id ?? "j\(i)"
            let name = ra.name ?? "Unknown Artist"
            let genre = ra.genre ?? "Music"
            let city = ra.city ?? "—"
            let listeners = ra.monthlyListeners ?? 0
            let subgenres = ra.subgenres ?? []
            let tier = ra.popularityTier ?? derivedTier(listeners)
            let rising = ra.isUndergroundRising ?? ra.isRising ?? (tier == "rising" || tier == "underground")

            let artist = Artist(
                id: id,
                name: name,
                handle: ra.handle ?? ("@" + name.lowercased().replacingOccurrences(of: " ", with: "")),
                genre: genre,
                city: city,
                bio: ra.bio ?? "\(genre) artist from \(city).",
                monthlyListeners: listeners,
                followers: ra.followers ?? Int(Double(listeners) * 0.4),
                isVerified: ra.isVerified ?? ra.verified ?? false,
                aiEnabled: ra.aiEnabled ?? false,
                isUndergroundRising: rising,
                tags: ra.tags ?? ([genre] + Array(subgenres.prefix(1))),
                aiPersona: ra.aiPersona ?? "Independent \(genre.lowercased()) artist who talks craft, scene, and connecting with fans.",
                subgenres: subgenres,
                moodTags: ra.moodTags ?? [],
                sonicTags: ra.sonicTags ?? [],
                energy: ra.energy ?? 50,
                soundsLike: ra.soundsLike ?? [],
                fanFundedMonthlyUSD: Int((ra.fanFundedMonthlyUSD ?? 0).rounded()),
                streamingEquivUSD: Int((ra.streamingEquivUSD ?? max(1, Double(listeners) * 0.012)).rounded()),
                popularityTier: tier)
            artists.append(artist)

            // Nested songs inherit artist context.
            for (j, rs) in (ra.songs ?? []).enumerated() {
                songs.append(adaptSong(rs, index: j, parent: artist))
            }
        }

        // Top-level songs (if the dataset stores them separately).
        let nameById = Dictionary(artists.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        for (k, rs) in (raw.songs ?? []).enumerated() {
            let parent = rs.artistId.flatMap { nameById[$0] }
            songs.append(adaptSong(rs, index: k, parent: parent))
        }

        let anchors: [AnchorArtist] = (raw.anchors ?? raw.anchorArtists ?? []).enumerated().map { i, ra in
            AnchorArtist(
                id: ra.id ?? "anchor-\(i)",
                name: ra.name ?? "Anchor",
                genre: ra.genre ?? "Music",
                subgenres: ra.subgenres ?? [],
                sonicTags: ra.sonicTags ?? [],
                moodTags: ra.moodTags ?? [],
                energy: ra.energy ?? 50)
        }

        return Mapped(
            artists: artists,
            songs: songs,
            anchors: anchors,
            moods: raw.moods ?? [],
            genres: raw.genres ?? [],
            cities: raw.cities ?? [])
    }

    private static func adaptSong(_ rs: RawSong, index: Int, parent: Artist?) -> Song {
        let artistId = rs.artistId ?? parent?.id ?? "?"
        return Song(
            id: rs.id ?? "\(artistId)-s\(index)",
            title: rs.title ?? "Untitled",
            artistId: artistId,
            artistName: rs.artistName ?? parent?.name ?? "Unknown",
            genre: rs.genre ?? parent?.genre ?? "Music",
            mood: rs.mood ?? rs.moodTags?.first ?? parent?.moodTags.first ?? "Euphoric",
            energy: rs.energy ?? parent?.energy ?? 50,
            durationSec: rs.durationSec ?? 210,
            plays: rs.plays ?? max(120, (parent?.monthlyListeners ?? 1000) * 2),
            isViral: rs.isViral ?? false,
            releasedDaysAgo: rs.releasedDaysAgo ?? 30)
    }

    private static func derivedTier(_ listeners: Int) -> String {
        switch listeners {
        case ..<5_000: return "undiscovered"
        case ..<50_000: return "underground"
        case ..<260_000: return "rising"
        default: return "established"
        }
    }
}

// MARK: - Tolerant JSON DTOs

/// All fields optional so partial / evolving datasets never crash the loader.
private struct RawDataset: Decodable {
    var artists: [RawArtist]?
    var songs: [RawSong]?
    var anchors: [RawAnchor]?
    var anchorArtists: [RawAnchor]?
    var moods: [String]?
    var genres: [String]?
    var cities: [String]?
}

private struct RawArtist: Decodable {
    var id: String?
    var name: String?
    var handle: String?
    var genre: String?
    var subgenres: [String]?
    var moodTags: [String]?
    var sonicTags: [String]?
    var energy: Int?
    var tempo: Int?
    var city: String?
    var popularityTier: String?
    var monthlyListeners: Int?
    var followers: Int?
    var isRising: Bool?
    var isUndergroundRising: Bool?
    var verified: Bool?
    var isVerified: Bool?
    var aiEnabled: Bool?
    var fanFundedMonthlyUSD: Double?
    var streamingEquivUSD: Double?
    var supporters: Int?
    var soundsLike: [String]?
    var bio: String?
    var headerColor: String?
    var aiPersona: String?
    var tags: [String]?
    var songs: [RawSong]?
}

private struct RawSong: Decodable {
    var id: String?
    var title: String?
    var artistId: String?
    var artistName: String?
    var genre: String?
    var mood: String?
    var moodTags: [String]?
    var energy: Int?
    var durationSec: Int?
    var plays: Int?
    var isViral: Bool?
    var releasedDaysAgo: Int?
}

private struct RawAnchor: Decodable {
    var id: String?
    var name: String?
    var genre: String?
    var subgenres: [String]?
    var sonicTags: [String]?
    var moodTags: [String]?
    var energy: Int?
}
