//
//  CultureModels.swift
//  VYBE
//
//  "Music culture" enhancement layer: drop campaigns, fan-investment timeline,
//  artist growth missions, before-they-blow alerts, scene pulse, fan crews,
//  artist need board, video premieres, and the fan Music DNA.
//  All local/mock — no backend.
//

import SwiftUI

// MARK: - Drop Campaigns

enum DropStatus: String, Hashable, Codable {
    case upcoming = "Upcoming"
    case live = "Live Now"
    case funded = "Funded"
    case completed = "Completed"
    var label: String { rawValue }
    var color: Color {
        switch self {
        case .upcoming: return VYBE.gold
        case .live: return VYBE.magenta
        case .funded: return VYBE.green
        case .completed: return VYBE.cyan
        }
    }
    var icon: String {
        switch self {
        case .upcoming: return "calendar.badge.clock"
        case .live: return "dot.radiowaves.left.and.right"
        case .funded: return "checkmark.seal.fill"
        case .completed: return "flag.checkered"
        }
    }
}

struct DropCampaign: Identifiable, Hashable, Codable {
    let id: String
    var artistId: String
    var artistName: String
    var title: String
    var subtitle: String
    var status: DropStatus
    var countdownText: String
    var coverSeed: String
    var videoId: String?
    var supportGoalUSD: Int
    var raisedUSD: Int
    var boostGoal: Int
    var boosts: Int
    var presaveGoal: Int
    var presaves: Int
    var earningsGoalUSD: Int
    var missionIds: [String]
    var rewards: [String]
    var bornOnVYBE: Bool

    var fundingProgress: Double { min(1, Double(raisedUSD) / Double(max(supportGoalUSD, 1))) }
    var boostProgress: Double { min(1, Double(boosts) / Double(max(boostGoal, 1))) }
    var presaveProgress: Double { min(1, Double(presaves) / Double(max(presaveGoal, 1))) }
}

// MARK: - Fan Investment Timeline

struct FanInvestment: Identifiable, Hashable {
    let id: String
    var artistId: String
    var artistName: String
    var artistHandle: String
    var genre: String
    var listenersWhenDiscovered: Int
    var listenersNow: Int
    var earningsDriven: Int
    var fanRank: Int
    var firstSupportText: String
    var wasEarly: Bool
    var milestone: String

    /// Growth multiple since discovery (e.g. 26× ).
    var growthMultiple: Int { max(1, listenersNow / max(listenersWhenDiscovered, 1)) }
}

// MARK: - Artist Growth Missions

enum MissionType: String, Hashable, Codable {
    case tickets, boosts, bringFans, unlockDrop, sharePremiere, voteSleeve, findVocalist, trendCollab
    var icon: String {
        switch self {
        case .tickets: return "ticket.fill"
        case .boosts: return "bolt.horizontal.fill"
        case .bringFans: return "person.3.fill"
        case .unlockDrop: return "lock.open.fill"
        case .sharePremiere: return "play.tv.fill"
        case .voteSleeve: return "hand.thumbsup.fill"
        case .findVocalist: return "music.mic"
        case .trendCollab: return "flame.fill"
        }
    }
    var color: Color {
        switch self {
        case .tickets: return VYBE.blue
        case .boosts: return VYBE.magenta
        case .bringFans: return VYBE.green
        case .unlockDrop: return VYBE.gold
        case .sharePremiere: return VYBE.purple
        case .voteSleeve: return VYBE.cyan
        case .findVocalist: return VYBE.gold
        case .trendCollab: return VYBE.magenta
        }
    }
}

struct ArtistMission: Identifiable, Hashable, Codable {
    let id: String
    var artistId: String
    var artistName: String
    var title: String
    var type: MissionType
    var goal: Int
    var progress: Int
    var unit: String
    var reward: String
    var points: Int
    var deadlineText: String

    var pct: Double { min(1, Double(progress) / Double(max(goal, 1))) }
}

// MARK: - Before They Blow

struct BeforeTheyBlowAlert: Identifiable, Hashable {
    let id: String
    var artistId: String        // "" if a flavor/non-navigable artist
    var artistName: String
    var city: String
    var genre: String
    var mood: String
    var reason: String          // headline
    var signals: [String]
    var listenersNow: Int
    var momentumPct: Int        // projected weekly growth
    var anchor: String          // "Fans who love X are switching on"
}

// MARK: - Scene Pulse

struct ScenePulse: Identifiable, Hashable {
    let id: String
    var city: String
    var label: String           // "Los Angeles Alt-R&B"
    var genres: [String]
    var heat: Int               // 0–100
    var risingArtistIds: [String]
    var showsThisWeek: Int
    var openChallenges: Int
    var trendingDrop: String
    var fanCrews: Int
    var blurb: String
}

// MARK: - Fan Crews

enum CrewFocus: String, Hashable {
    case artist, city, genre, drop, event, collab
    var icon: String {
        switch self {
        case .artist: return "music.mic"
        case .city: return "mappin.and.ellipse"
        case .genre: return "guitars.fill"
        case .drop: return "shippingbox.fill"
        case .event: return "ticket.fill"
        case .collab: return "person.2.wave.2.fill"
        }
    }
    var label: String { rawValue.capitalized }
}

struct FanCrew: Identifiable, Hashable {
    let id: String
    var name: String
    var focus: CrewFocus
    var focusLabel: String
    var members: Int
    var impactScore: Int
    var currentMission: String
    var recentActivity: [String]
    var blurb: String
}

// MARK: - Artist Need Board

enum NeedType: String, CaseIterable, Identifiable, Hashable {
    case vocalist = "Vocalist"
    case producer = "Producer"
    case mixEngineer = "Mix Engineer"
    case videographer = "Videographer"
    case opener = "Show Opener"
    case streetTeam = "Street Team"
    case coverArt = "Cover Art Designer"
    case remixPartner = "Remix Partner"
    case songwriter = "Songwriter"
    case studioSpace = "Studio Space"
    var id: String { rawValue }
    var label: String { rawValue }
    var icon: String {
        switch self {
        case .vocalist: return "music.mic"
        case .producer: return "slider.horizontal.3"
        case .mixEngineer: return "dial.medium.fill"
        case .videographer: return "video.fill"
        case .opener: return "ticket.fill"
        case .streetTeam: return "megaphone.fill"
        case .coverArt: return "paintpalette.fill"
        case .remixPartner: return "arrow.2.squarepath"
        case .songwriter: return "pencil.and.scribble"
        case .studioSpace: return "building.2.fill"
        }
    }
}

struct ArtistNeed: Identifiable, Hashable {
    let id: String
    var artistId: String
    var artistName: String
    var type: NeedType
    var location: String
    var genre: String
    var deadlineText: String
    var description: String
    var compensation: String
}

// MARK: - Video Premieres (VYBE TV)

struct VideoPremiere: Identifiable, Hashable {
    let id: String
    var videoId: String?
    var artistId: String
    var artistName: String
    var title: String
    var countdownText: String   // "Tonight · 8PM PT" / "Live now"
    var isLive: Bool
    var previewSeed: String
    var artistIntro: String
    var reactions: Int
    var premiereStatus: String  // "World Premiere" / "Underground Premiere"
}

// MARK: - Music DNA / Taste Graph (computed)

struct MusicDNA {
    var topGenres: [String]
    var topMoods: [String]
    var cityScenes: [String]
    var discoveryStyle: String
    var supportStyle: String
    var artistsDiscovered: Int
    var earlySupports: Int
    var labels: [String]

    static func build(_ app: AppState) -> MusicDNA {
        let funded = Mock.fundedArtists
        var genres = Array(app.taste.favoriteGenres)
        for g in app.discoveredGenres where !genres.contains(g) { genres.append(g) }
        if genres.isEmpty { genres = ["Hyperpop", "Dream Pop", "Alt-R&B"] }
        var moods = Array(app.taste.favoriteMoods)
        if moods.isEmpty { moods = ["Euphoric", "Dreamy", "Nostalgic"] }

        let discovered = app.discoveredArtists.count + funded.filter { $0.supportActions.contains(where: { $0.lowercased().contains("early") }) }.count
        var labels: [String] = []
        if let g = genres.first { labels.append("\(g) Scout") }
        labels.append("First Heard It Fan")
        if !app.watchedVideos.isEmpty || !app.sleeveBadges.isEmpty { labels.append("Video Premiere Regular") }
        labels.append("Local Scene Builder")
        if !app.collabBadges.isEmpty || !app.discoveredArtists.isEmpty { labels.append("Collab Scout") }

        return MusicDNA(
            topGenres: Array(genres.prefix(4)),
            topMoods: Array(moods.prefix(4)),
            cityScenes: [app.taste.city.isEmpty ? "Los Angeles" : app.taste.city, "Brooklyn", "Portland"],
            discoveryStyle: "Underground-first · you back artists before they break",
            supportStyle: "Direct support — tips, drops, and shows over passive streams",
            artistsDiscovered: max(discovered, funded.count),
            earlySupports: max(app.discoveredArtists.count, 2),
            labels: Array(labels.prefix(5)))
    }
}
