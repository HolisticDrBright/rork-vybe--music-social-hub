//
//  Models.swift
//  VYBE
//
//  Core data models for the VYBE social music platform.
//

import SwiftUI

enum UserRole: String, CaseIterable, Identifiable {
    case fan = "Fan"
    case artist = "Artist"
    case admin = "Admin"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .fan: return "music.note"
        case .artist: return "guitars.fill"
        case .admin: return "shield.lefthalf.filled"
        }
    }
    var blurb: String {
        switch self {
        case .fan: return "Discover music, meet fans, earn rewards"
        case .artist: return "Grow your fanbase & launch challenges"
        case .admin: return "Moderate communities & oversee VYBE"
        }
    }
}

struct Artist: Identifiable, Hashable {
    let id: String
    var name: String
    var handle: String
    var genre: String
    var city: String
    var bio: String
    var monthlyListeners: Int
    var followers: Int
    var isVerified: Bool
    var aiEnabled: Bool
    var isUndergroundRising: Bool
    var tags: [String]
    /// Mock personality for the AI twin.
    var aiPersona: String

    // MARK: - Discovery engine sonic profile (#17 "Unknowns Like Your Favorites")
    /// Finer-grained genre tags used for content similarity.
    var subgenres: [String] = []
    /// Emotional descriptors (e.g. "Dreamy", "Euphoric").
    var moodTags: [String] = []
    /// Production / texture descriptors (e.g. "reverb-drenched", "heavy bass").
    var sonicTags: [String] = []
    /// Overall energy 0–100.
    var energy: Int = 50
    /// 1–2 famous taste-anchor artists this act sounds like.
    var soundsLike: [String] = []
    /// Direct fan-funded earnings this month (discovery signal).
    var fanFundedMonthlyUSD: Int = 0
    /// What the same activity would have earned on streaming (~$0.004/stream).
    var streamingEquivUSD: Int = 0
    /// "undiscovered" (<5k) / "underground" (5k–50k) / "rising" (50k–260k) / "established".
    var popularityTier: String = "established"

    /// Convenience: vector used by the discovery engine.
    var sonicVector: SonicVector {
        SonicVector(displayName: name, genre: genre, subgenres: subgenres,
                    sonicTags: sonicTags, moodTags: moodTags, energy: energy)
    }
}

/// A famous taste-reference point (not a navigable profile) used to anchor discovery.
struct AnchorArtist: Identifiable, Hashable {
    let id: String
    var name: String
    var genre: String
    var subgenres: [String]
    var sonicTags: [String]
    var moodTags: [String]
    var energy: Int

    var sonicVector: SonicVector {
        SonicVector(displayName: name, genre: genre, subgenres: subgenres,
                    sonicTags: sonicTags, moodTags: moodTags, energy: energy)
    }
}

/// A lightweight content-similarity vector shared by artists and anchors.
struct SonicVector: Hashable {
    var displayName: String
    var genre: String
    var subgenres: [String]
    var sonicTags: [String]
    var moodTags: [String]
    var energy: Int
}

/// One explainable "Hidden Gem" recommendation produced by the discovery engine.
struct DiscoveryResult: Identifiable, Hashable {
    var id: String { artist.id }
    let artist: Artist
    /// The favorite/anchor this result was matched against ("If you love …").
    let anchorName: String
    /// Raw content similarity 0–1 (before underground boost).
    let similarity: Double
    /// Final ranking score after the underground boost.
    let finalScore: Double
    /// True if this slot is a taste-expansion wildcard.
    let isWildcard: Bool
    /// Optional social-proof line ("fans who love X also support Y").
    let socialSignal: String?
}

struct Song: Identifiable, Hashable {
    let id: String
    var title: String
    var artistId: String
    var artistName: String
    var genre: String
    var mood: String
    var energy: Int        // 1-100
    var durationSec: Int
    var plays: Int
    var isViral: Bool
    var releasedDaysAgo: Int
}

struct Event: Identifiable, Hashable {
    let id: String
    var title: String
    var venue: String
    var city: String
    var date: Date
    var lineup: [String]
    var attending: Int
    var friendsAttending: Int
    var ticketPriceFrom: Int
    var isFestival: Bool
    var distanceMiles: Double
}

struct BoardPost: Identifiable, Hashable {
    let id: String
    var author: String
    var avatarSeed: String
    var text: String
    var minutesAgo: Int
    var likes: Int
    var replies: Int
    var channel: String   // e.g. "Meetups", "Ride Share", "VIP", "First-Timers"
    var liked: Bool = false
}

struct Badge: Identifiable, Hashable {
    let id: String
    var name: String
    var icon: String
    var desc: String
    var earned: Bool
}

struct Reward: Identifiable, Hashable {
    let id: String
    var title: String
    var subtitle: String
    var cost: Int
    var icon: String
    var category: String
    var hot: Bool
}

struct Challenge: Identifiable, Hashable {
    let id: String
    var title: String
    var artistName: String
    var reward: Int
    var participants: Int
    var icon: String
    var progress: Double   // 0...1
    var deadline: String
}

struct LeaderFan: Identifiable, Hashable {
    let id: String
    var name: String
    var avatarSeed: String
    var score: Int
    var city: String
    var topBadge: String
}

struct Community: Identifiable, Hashable {
    let id: String
    var name: String
    var kind: String       // Artist / City / Genre / Fan Group
    var members: Int
    var activeNow: Int
    var about: String
    var trendingTopic: String
}

struct FeedItem: Identifiable, Hashable {
    enum Kind: String {
        case trendingSong, artistDrop, challenge, concert, friends, communityUpdate, aiMessage, recommendation
    }
    let id: String
    var kind: Kind
    var title: String
    var subtitle: String
    var meta: String
    var seed: String
    var accentSeed: String
}

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    var fromAI: Bool
    var text: String
}

/// Artist earnings breakdown for transparency module.
struct ArtistEarnings: Identifiable, Hashable {
    let id: String
    var artistId: String
    var directSupport: Int        // tips from fans
    var dropSales: Int            // exclusive drops
    var merchRevenue: Int
    var superfanRevenue: Int
    var eventRevenue: Int
    var total: Int { directSupport + dropSales + merchRevenue + superfanRevenue + eventRevenue }
    /// What Spotify would have paid for the same streams (~$0.004/stream)
    var streamingEquivalent: Int
    var artistKeepsPercent: Int   // 90
    var streamCount: Int
}

/// A fan's support relationship with an artist.
struct FundedArtist: Identifiable, Hashable {
    let id: String
    var artistId: String
    var artistName: String
    var totalContributed: Int     // dollars the fan personally drove
    var streamsDriven: Int
    var rank: Int                 // fan rank for this artist
    var supportActions: [String]  // "Streamed", "Shared 12x", "Attended show", etc.
    var artistHandle: String
    var artistGenre: String
}

/// A shareable holographic support receipt.
struct SupportReceipt: Identifiable, Hashable {
    let id: String
    var artistName: String
    var artistHandle: String
    var amountDriven: Int
    var action: String            // "Shared Neon Bloodstream"
    var vybeScoreEarned: Int
    var rankUpdated: String       // e.g. "Top 50 fan in LA"
    var streamingComparison: String // e.g. "17x what streaming would've paid"
    var timestamp: Date
    var receiptSeed: String

    // Precise economics for the investor-demo "money moment".
    var artistEarnedUSD: Double = 0     // dollars this single action put in the artist's pocket
    var streamingEquivUSD: Double = 0   // what streaming would have paid for the same activity
    var multiplier: Int = 0             // artistEarnedUSD / streamingEquivUSD
    var fanRank: Int = 0                // the fan's new rank on this artist's board
    var badgeProgress: String? = nil    // e.g. "Early Discoverer unlocked!"
    /// Headline copy, e.g. "You supported Asha Vale directly — worth far more than streaming…".
    var headline: String = ""
}

/// Report categories for trust & safety.
struct ReportCategory: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var icon: String
    var description: String
}

/// Taste profile captured during onboarding.
struct OnboardingTaste {
    var favoriteGenres: Set<String> = []
    var favoriteMoods: Set<String> = []
    var city: String = ""
    var lookingFor: Set<String> = []  // "Discover music", "Meet fans", "Go to shows", "Support artists"
}

// MARK: - Vibe Check (Emotion-Based Discovery)

/// A mood entry in the Vibe Check mood wheel.
struct VibeMood: Identifiable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let color: Color
    let energyLow: Int
    let energyHigh: Int
    /// Whether this mood is considered "heavy" — triggers wellbeing nudges.
    var isHeavy: Bool
    /// Related mood names in the mock data for matching songs.
    var matchKeywords: [String]
}

/// A phase in a SHIFT mood journey (A → B).
struct MoodJourneyPhase: Identifiable {
    let id = UUID()
    let label: String
    let songs: [Song]
    let blendRatio: Double   // 0 = pure A, 1 = pure B
}

/// A single mood history entry saved to the fan's profile.
struct MoodHistoryEntry: Identifiable, Hashable {
    let id: String
    let moodId: String
    let moodName: String
    let timestamp: Date
    let mode: String // "match" or "shift"
}

// MARK: - Collab Lab (artist-to-artist collaboration)

/// The kind of collaboration an artist is opening up.
enum CollabChallengeType: String, CaseIterable, Identifiable, Hashable, Codable {
    case bestHook = "Best Hook"
    case openVerse = "Open Verse"
    case remixThis = "Remix This"
    case addVocals = "Add Vocals"
    case finishSong = "Finish This Song"
    case producerWanted = "Producer Wanted"
    case songwriterWanted = "Songwriter Wanted"
    var id: String { rawValue }
    var label: String { rawValue }
    var icon: String {
        switch self {
        case .bestHook: return "music.mic"
        case .openVerse: return "text.bubble.fill"
        case .remixThis: return "dial.medium.fill"
        case .addVocals: return "waveform"
        case .finishSong: return "music.note.list"
        case .producerWanted: return "slider.horizontal.3"
        case .songwriterWanted: return "pencil.and.scribble"
        }
    }
    /// The verb used on the submit CTA ("Submit your hook idea").
    var submitNoun: String {
        switch self {
        case .bestHook: return "hook idea"
        case .openVerse: return "verse"
        case .remixThis: return "remix"
        case .addVocals: return "vocal take"
        case .finishSong: return "idea"
        case .producerWanted: return "production"
        case .songwriterWanted: return "topline"
        }
    }
}

/// Lifecycle status of a collaboration challenge.
enum CollabStatus: String, Hashable, Codable {
    case open = "Open"
    case reviewing = "Reviewing"
    case winnerPicked = "Winner Picked"
    case convertedToDrop = "Upcoming Drop"
    var label: String { rawValue }
    var color: Color {
        switch self {
        case .open: return VYBE.green
        case .reviewing: return VYBE.gold
        case .winnerPicked: return VYBE.magenta
        case .convertedToDrop: return VYBE.cyan
        }
    }
    var icon: String {
        switch self {
        case .open: return "dot.radiowaves.left.and.right"
        case .reviewing: return "eye.fill"
        case .winnerPicked: return "crown.fill"
        case .convertedToDrop: return "sparkles"
        }
    }
}

/// Visibility scope for a challenge.
enum CollabVisibility: String, CaseIterable, Identifiable, Hashable, Codable {
    case publicAll = "Public"
    case sceneOnly = "Scene-only"
    case inviteOnly = "Invite-only"
    var id: String { rawValue }
    var label: String { rawValue }
    var icon: String {
        switch self {
        case .publicAll: return "globe"
        case .sceneOnly: return "mappin.and.ellipse"
        case .inviteOnly: return "lock.fill"
        }
    }
}

/// A collaborator role an artist is looking for.
enum CollabRoleNeeded: String, CaseIterable, Identifiable, Hashable {
    case vocalist = "Vocalist"
    case toplineWriter = "Topline writer"
    case rapper = "Rapper"
    case songwriter = "Songwriter"
    case producer = "Producer"
    case remixer = "Remixer"
    case instrumentalist = "Instrumentalist"
    var id: String { rawValue }
    var label: String { rawValue }
}

/// A submission's creative response type.
enum SubmissionType: String, CaseIterable, Identifiable, Hashable, Codable {
    case hook = "Hook"
    case verse = "Verse"
    case vocalIdea = "Vocal idea"
    case remix = "Remix"
    case beatFlip = "Beat flip"
    case lyrics = "Lyrics"
    var id: String { rawValue }
    var label: String { rawValue }
    var icon: String {
        switch self {
        case .hook: return "music.mic"
        case .verse: return "text.alignleft"
        case .vocalIdea: return "waveform"
        case .remix: return "dial.medium.fill"
        case .beatFlip: return "arrow.2.squarepath"
        case .lyrics: return "pencil"
        }
    }
}

/// Lifecycle state of a single submission.
enum SubmissionStatus: String, Hashable, Codable {
    case submitted = "Submitted"
    case shortlisted = "Shortlisted"
    case selected = "Winner"
    case declined = "Declined"
    var label: String { rawValue }
    var color: Color {
        switch self {
        case .submitted: return VYBE.textSecondary
        case .shortlisted: return VYBE.gold
        case .selected: return VYBE.magenta
        case .declined: return VYBE.textTertiary
        }
    }
}

/// A posted collaboration challenge (beat / hook / loop / idea).
struct CollabChallenge: Identifiable, Hashable, Codable {
    let id: String
    var creatorArtistId: String
    var creatorName: String
    var title: String
    var beatTitle: String
    var challengeType: CollabChallengeType
    var genre: String
    var mood: String
    var bpm: Int
    var key: String
    var city: String
    var description: String
    var lookingFor: [String]          // e.g. ["Vocalist", "Topline writer"]
    var reward: String
    var proposedSplit: String
    var deadlineText: String
    var status: CollabStatus
    var submissionCount: Int
    var previewSeed: String
    var visibility: CollabVisibility
    var creditNotes: String
    var selectedSubmissionId: String? = nil
}

/// A creative response submitted to a challenge.
struct CollabSubmission: Identifiable, Hashable, Codable {
    let id: String
    var challengeId: String
    var artistId: String
    var artistName: String
    var submissionType: SubmissionType
    var title: String
    var note: String
    var lyricSnippet: String
    var previewSeed: String
    var reactions: Int
    var status: SubmissionStatus
    var minutesAgo: Int = 0
}

/// An upcoming release born from a Collab Lab challenge.
struct UpcomingDrop: Identifiable, Hashable, Codable {
    let id: String
    var title: String
    var artistNames: [String]
    var originChallengeId: String?
    var bornOnVYBE: Bool
    var description: String
    var genre: String
    var earlySupporters: Int
    var previewSeed: String
    var splitNote: String
    var releaseText: String
    /// Drop Campaign this collab winner flows into (unified drop object).
    var campaignId: String? = nil
}


// MARK: - Sleeves + Videos (album-worlds: art, lore, lyrics, music videos)

/// Visual era/style of a sleeve.
enum SleeveEra: String, CaseIterable, Identifiable, Hashable, Codable {
    case vinyl70s = "70s Vinyl"
    case cd90s = "90s CD Booklet"
    case newAge = "New Age Cosmic"
    case cyberZine = "Cyber Zine"
    case handmade = "Handmade Zine"
    case sceneFlyer = "Scene Flyer"
    var id: String { rawValue }
    var label: String { rawValue }
    var tagline: String {
        switch self {
        case .vinyl70s: return "Gatefold cosmic vinyl"
        case .cd90s: return "Jewel-case booklet w/ lyrics"
        case .newAge: return "Spiritual cosmic art"
        case .cyberZine: return "Cyberpunk video single"
        case .handmade: return "Cut-and-paste zine collage"
        case .sceneFlyer: return "Local scene flyer"
        }
    }
    var icon: String {
        switch self {
        case .vinyl70s: return "circle.circle"
        case .cd90s: return "opticaldisc"
        case .newAge: return "moon.stars.fill"
        case .cyberZine: return "bolt.horizontal.circle.fill"
        case .handmade: return "scissors"
        case .sceneFlyer: return "doc.richtext.fill"
        }
    }
    /// Accent colors that tint the sleeve's pages.
    var accents: [Color] {
        switch self {
        case .vinyl70s: return [Color(red: 0.88, green: 0.52, blue: 0.18), Color(red: 0.78, green: 0.22, blue: 0.36)]
        case .cd90s: return [VYBE.cyan, VYBE.blue]
        case .newAge: return [VYBE.purple, Color(red: 0.45, green: 0.8, blue: 0.95)]
        case .cyberZine: return [VYBE.magenta, VYBE.cyan]
        case .handmade: return [VYBE.gold, VYBE.magenta]
        case .sceneFlyer: return [VYBE.green, VYBE.gold]
        }
    }
}

/// One production / credit line.
struct CreditLine: Identifiable, Hashable, Codable {
    let id: String
    var role: String
    var name: String
}

/// A block of fictional, mock lyrics (never real copyrighted lyrics).
struct LyricBlock: Identifiable, Hashable, Codable {
    let id: String
    var label: String      // "Verse 1", "Chorus", "Bridge"
    var lines: [String]
}

/// A "behind the song" story note.
struct BehindSongNote: Identifiable, Hashable, Codable {
    let id: String
    var heading: String
    var body: String
}

/// An extra inside-art / moodboard panel.
struct SleevePanel: Identifiable, Hashable, Codable {
    let id: String
    var kind: String       // "art" or "note"
    var title: String
    var artSeed: String
    var caption: String
}

/// Premiere status for a music video.
enum VideoPremiereStatus: String, Hashable {
    case premiere = "Premiere"
    case newRelease = "New"
    case bornOnVYBE = "Born on VYBE"
    case underground = "Underground"
    case classic = "Classic"
    var label: String { rawValue }
    var color: Color {
        switch self {
        case .premiere: return VYBE.magenta
        case .newRelease: return VYBE.green
        case .bornOnVYBE: return VYBE.cyan
        case .underground: return VYBE.purple
        case .classic: return VYBE.gold
        }
    }
    var icon: String {
        switch self {
        case .premiere: return "sparkles.tv.fill"
        case .newRelease: return "play.tv.fill"
        case .bornOnVYBE: return "sparkles"
        case .underground: return "eye.fill"
        case .classic: return "star.fill"
        }
    }
}

/// A music video (mock / placeholder — no real playback).
struct MusicVideo: Identifiable, Hashable {
    let id: String
    var songId: String?
    var artistId: String
    var title: String
    var artistName: String
    var durationSec: Int
    var previewSeed: String
    var status: VideoPremiereStatus
    var scene: String          // city / scene
    var behindTheVideo: String
    var reactions: Int
}

/// The full interactive sleeve for a song / drop.
struct SongSleeve: Identifiable, Hashable, Codable {
    let id: String
    var songId: String
    var artistId: String
    var title: String
    var artistName: String
    var era: SleeveEra
    var coverArtSeed: String
    var tagline: String
    var lyricExcerpt: String           // one line for previews
    var mockLyrics: [LyricBlock]       // fictional lyrics only
    var linerNotes: String
    var thankYous: String
    var behindTheSong: BehindSongNote
    var credits: [CreditLine]
    var visualSymbols: [String]        // SF symbols for hidden visual details
    var insidePanels: [SleevePanel]
    var videoId: String?
    var supporterBonus: String         // unlockable supporter content placeholder
    var fanReactions: [String]
}
