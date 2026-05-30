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

