//
//  CultureMockData.swift
//  VYBE
//
//  Mock data for the music-culture enhancement layer.
//

import Foundation

extension Mock {

    // MARK: - Drop Campaigns

    static let dropCampaigns: [DropCampaign] = [
        DropCampaign(
            id: "dc-midnight", artistId: "a1", artistName: "NOVA REIGN",
            title: "Help NOVA REIGN launch \"Midnight Signal\"",
            subtitle: "The Collab Lab winner becomes a real drop.",
            status: .live, countdownText: "Live now · 4 days left",
            coverSeed: "Midnight Signal campaign", videoId: "mv-s1",
            supportGoalUSD: 2_000, raisedUSD: 1_240,
            boostGoal: 1_000, boosts: 612,
            presaveGoal: 200, presaves: 138,
            earningsGoalUSD: 1_800, missionIds: ["m-boosts", "m-tickets"],
            rewards: ["First Heard It badge", "VIP livestream invite", "Early demo unlock"],
            bornOnVYBE: true),
        DropCampaign(
            id: "dc-static", artistId: "a3", artistName: "Velvet Static",
            title: "Static & Gold (feat. LUNA TIDE)",
            subtitle: "Born on VYBE — the open-verse collab that won.",
            status: .funded, countdownText: "Funded · drops in 9 days",
            coverSeed: "Static & Gold campaign", videoId: "mv-collab",
            supportGoalUSD: 1_200, raisedUSD: 1_340,
            boostGoal: 600, boosts: 740,
            presaveGoal: 150, presaves: 168,
            earningsGoalUSD: 1_000, missionIds: ["m-share"],
            rewards: ["First Heard It badge", "Numbered zine page", "Name in the credits"],
            bornOnVYBE: true),
        DropCampaign(
            id: "dc-gravity", artistId: "a4", artistName: "LUNA TIDE",
            title: "Gravity Loves You — Sleeve Drop",
            subtitle: "A new-age cosmic sleeve with the attic demo.",
            status: .upcoming, countdownText: "Drops in 3 days",
            coverSeed: "Gravity sleeve campaign", videoId: "mv-s3",
            supportGoalUSD: 900, raisedUSD: 280,
            boostGoal: 500, boosts: 190,
            presaveGoal: 120, presaves: 64,
            earningsGoalUSD: 800, missionIds: ["m-bring", "m-vote"],
            rewards: ["First Heard It badge", "High-res gatefold print", "Attic demo unlock"],
            bornOnVYBE: false),
        DropCampaign(
            id: "dc-glitch", artistId: "a7", artistName: "GLITCHCORE KID",
            title: "lol nothing matters — Deluxe Drop",
            subtitle: "The joke that became a scene gets a deluxe edition.",
            status: .completed, countdownText: "Completed · out now",
            coverSeed: "lol deluxe campaign", videoId: "mv-s8",
            supportGoalUSD: 600, raisedUSD: 612,
            boostGoal: 400, boosts: 540,
            presaveGoal: 100, presaves: 132,
            earningsGoalUSD: 500, missionIds: ["m-vocalist"],
            rewards: ["First Heard It badge", "Printable show flyer", "40-min original render"],
            bornOnVYBE: true),
    ]
    static func dropCampaign(_ id: String) -> DropCampaign? { dropCampaigns.first { $0.id == id } }
    static func campaign(forArtist artistId: String) -> DropCampaign? { dropCampaigns.first { $0.artistId == artistId } }

    // MARK: - Fan Investment Timeline

    static let fanInvestments: [FanInvestment] = [
        FanInvestment(id: "fi1", artistId: "a4", artistName: "LUNA TIDE", artistHandle: "@lunatide", genre: "Dream Pop",
                      listenersWhenDiscovered: 3_200, listenersNow: 220_000, earningsDriven: 320, fanRank: 12,
                      firstSupportText: "Backed 7 months ago", wasEarly: true, milestone: "Booked her first national tour"),
        FanInvestment(id: "fi2", artistId: "a7", artistName: "GLITCHCORE KID", artistHandle: "@glitchcorekid", genre: "Hyperpop",
                      listenersWhenDiscovered: 1_900, listenersNow: 88_000, earningsDriven: 85, fanRank: 8,
                      firstSupportText: "Backed 4 months ago", wasEarly: true, milestone: "Crossed 500k plays on a bedroom track"),
        FanInvestment(id: "fi3", artistId: "a3", artistName: "Velvet Static", artistHandle: "@velvetstatic", genre: "Indie Rock",
                      listenersWhenDiscovered: 12_400, listenersNow: 410_000, earningsDriven: 140, fanRank: 28,
                      firstSupportText: "Backed 11 months ago", wasEarly: true, milestone: "Won an open-verse collab on VYBE"),
        FanInvestment(id: "fi4", artistId: "a1", artistName: "NOVA REIGN", artistHandle: "@novareign", genre: "Hyperpop",
                      listenersWhenDiscovered: 140_000, listenersNow: 2_840_000, earningsDriven: 1_840, fanRank: 5,
                      firstSupportText: "Backed 2 years ago", wasEarly: false, milestone: "Headlined PRISM Festival"),
    ]

    // MARK: - Artist Growth Missions

    static let artistMissions: [ArtistMission] = [
        ArtistMission(id: "m-boosts", artistId: "a1", artistName: "NOVA REIGN", title: "Get \"Midnight Signal\" to 1,000 boosts",
                      type: .boosts, goal: 1_000, progress: 612, unit: "boosts", reward: "First Heard It badge", points: 500, deadlineText: "4 days left"),
        ArtistMission(id: "m-tickets", artistId: "a1", artistName: "NOVA REIGN", title: "Help sell 50 tickets for the LA show",
                      type: .tickets, goal: 50, progress: 31, unit: "tickets", reward: "VIP livestream invite", points: 800, deadlineText: "6 days left"),
        ArtistMission(id: "m-bring", artistId: "a4", artistName: "LUNA TIDE", title: "Bring 20 fans to my Portland show",
                      type: .bringFans, goal: 20, progress: 7, unit: "fans", reward: "Backstage hello", points: 600, deadlineText: "9 days left"),
        ArtistMission(id: "m-unlock", artistId: "a2", artistName: "Kairo Sol", title: "Help unlock my next drop",
                      type: .unlockDrop, goal: 800, progress: 540, unit: "support pts", reward: "Early Side-A unlock", points: 400, deadlineText: "1 week left"),
        ArtistMission(id: "m-share", artistId: "a3", artistName: "Velvet Static", title: "Share my video premiere",
                      type: .sharePremiere, goal: 300, progress: 188, unit: "shares", reward: "Premiere Crew badge", points: 350, deadlineText: "3 days left"),
        ArtistMission(id: "m-vote", artistId: "a4", artistName: "LUNA TIDE", title: "Vote on my next sleeve art",
                      type: .voteSleeve, goal: 500, progress: 412, unit: "votes", reward: "Voter credit on the sleeve", points: 200, deadlineText: "2 days left"),
        ArtistMission(id: "m-vocalist", artistId: "a6", artistName: "Sable Mirage", title: "Find me a vocalist for this beat",
                      type: .findVocalist, goal: 25, progress: 9, unit: "submissions", reward: "Featured credit", points: 450, deadlineText: "5 days left"),
        ArtistMission(id: "m-trend", artistId: "a1", artistName: "NOVA REIGN", title: "Help this collab trend",
                      type: .trendCollab, goal: 1_000, progress: 430, unit: "shares", reward: "Collab Scout badge", points: 500, deadlineText: "8 days left"),
    ]
    static func mission(_ id: String) -> ArtistMission? { artistMissions.first { $0.id == id } }

    // MARK: - Before They Blow

    static let beforeTheyBlow: [BeforeTheyBlowAlert] = [
        BeforeTheyBlowAlert(id: "bt1", artistId: "a7", artistName: "GLITCHCORE KID", city: "Chicago", genre: "Hyperpop", mood: "Chaotic",
                            reason: "3 signs they're about to break",
                            signals: ["Shares up 240% this week", "First all-ages show sold out", "Added to 4k playlists in 7 days"],
                            listenersNow: 88_000, momentumPct: 240, anchor: "Fans who love 100 gecs are switching on"),
        BeforeTheyBlowAlert(id: "bt2", artistId: "a4", artistName: "LUNA TIDE", city: "Portland", genre: "Dream Pop", mood: "Dreamy",
                            reason: "This artist is starting to move",
                            signals: ["Local heat rising in Portland", "Sleeve opens up 180%", "Tour just announced"],
                            listenersNow: 220_000, momentumPct: 92, anchor: "Fans who love Beach House are switching on"),
        BeforeTheyBlowAlert(id: "bt3", artistId: "a3", artistName: "Velvet Static", city: "Austin", genre: "Indie Rock", mood: "Nostalgic",
                            reason: "Local heat rising",
                            signals: ["Won an open-verse collab", "Shares up 130% this week", "3 blogs picked it up"],
                            listenersNow: 410_000, momentumPct: 130, anchor: "Fans who love Tame Impala are switching on"),
        BeforeTheyBlowAlert(id: "bt4", artistId: "", artistName: "Asha Vale", city: "Oakland", genre: "Alt-R&B", mood: "Sultry",
                            reason: "She's about to break",
                            signals: ["Shares up 310% this week", "First headline show announced", "A&Rs are circling"],
                            listenersNow: 3_200, momentumPct: 310, anchor: "Fans who love SZA are switching on"),
        BeforeTheyBlowAlert(id: "bt5", artistId: "", artistName: "Cobalt Skyline", city: "Denver", genre: "Synthwave", mood: "Moody",
                            reason: "Underground heat building",
                            signals: ["Sync placement rumored", "Shares up 165% this week", "Local crews forming"],
                            listenersNow: 6_400, momentumPct: 165, anchor: "Fans who love The Midnight are switching on"),
    ]

    // MARK: - Scene Pulse

    static let scenePulses: [ScenePulse] = [
        ScenePulse(id: "sp-la", city: "Los Angeles", label: "Los Angeles Alt-R&B", genres: ["Alt-R&B", "Hyperpop"], heat: 91,
                   risingArtistIds: ["a1", "a6"], showsThisWeek: 5, openChallenges: 2, trendingDrop: "Midnight Signal",
                   fanCrews: 12, blurb: "Late-night alt-R&B and maximalist pop colliding in DIY rooms across LA."),
        ScenePulse(id: "sp-bk", city: "Brooklyn", label: "Brooklyn Afro-House", genres: ["Afro-House", "Amapiano"], heat: 88,
                   risingArtistIds: ["a2"], showsThisWeek: 4, openChallenges: 1, trendingDrop: "Log Drum Gospel",
                   fanCrews: 9, blurb: "Rooftops and basements turning Brooklyn into the US home of Afro-house."),
        ScenePulse(id: "sp-chi", city: "Chicago", label: "Chicago Hyperpop", genres: ["Hyperpop", "Glitch"], heat: 84,
                   risingArtistIds: ["a7"], showsThisWeek: 6, openChallenges: 1, trendingDrop: "lol nothing matters",
                   fanCrews: 7, blurb: "All-ages basement shows breeding the loudest, glitchiest sound in the country."),
        ScenePulse(id: "sp-pdx", city: "Portland", label: "Portland Dream Pop", genres: ["Dream Pop", "Ambient"], heat: 76,
                   risingArtistIds: ["a4"], showsThisWeek: 3, openChallenges: 1, trendingDrop: "Gravity Loves You",
                   fanCrews: 6, blurb: "Foggy, reverb-drenched dream pop and a tight-knit collector scene."),
        ScenePulse(id: "sp-det", city: "Detroit", label: "Detroit Bass", genres: ["Dubstep", "Bass"], heat: 79,
                   risingArtistIds: ["a5"], showsThisWeek: 4, openChallenges: 1, trendingDrop: "Subwoofer Gospel",
                   fanCrews: 8, blurb: "Cathedral-sized sound systems and a bass culture that never left."),
    ]
    static func scene(_ id: String) -> ScenePulse? { scenePulses.first { $0.id == id } }

    // MARK: - Fan Crews

    static let fanCrews: [FanCrew] = [
        FanCrew(id: "cr-la", name: "LA Alt-R&B Scouts", focus: .city, focusLabel: "Los Angeles · Alt-R&B", members: 1_240, impactScore: 88,
                currentMission: "Sell out Sable Mirage's Echoplex show", recentActivity: ["@glowqueen drove 14 tickets", "New rising artist flagged", "Crew hit 1,200 members"],
                blurb: "We find LA's next alt-R&B voices before the algorithms do."),
        FanCrew(id: "cr-nova", name: "NOVA REIGN Street Team", focus: .artist, focusLabel: "NOVA REIGN", members: 8_900, impactScore: 96,
                currentMission: "Get Midnight Signal to 1,000 boosts", recentActivity: ["612 / 1,000 boosts", "Tour visuals shared 4.2k times", "VIP livestream unlocked"],
                blurb: "The Reign army. Drops, boosts, and chaos — organized."),
        FanCrew(id: "cr-bk", name: "Brooklyn Warehouse Crew", focus: .city, focusLabel: "Brooklyn", members: 640, impactScore: 81,
                currentMission: "Pack Kairo Sol's rooftop set", recentActivity: ["3 warehouse shows added", "Ride-share board active", "12 new members this week"],
                blurb: "Rooftops, basements, and the rhythm that runs the night."),
        FanCrew(id: "cr-fhi", name: "First Heard It Club", focus: .genre, focusLabel: "Early Discovery", members: 3_410, impactScore: 92,
                currentMission: "Back 5 sub-5k artists this month", recentActivity: ["Asha Vale flagged at 3.2k", "Cobalt Skyline backed early", "Collector streak: 11 days"],
                blurb: "We were there before the blow-up. Taste as a badge of honor."),
        FanCrew(id: "cr-midnight", name: "Midnight Signal Launch Squad", focus: .drop, focusLabel: "Midnight Signal", members: 920, impactScore: 84,
                currentMission: "Hit $2,000 fan support", recentActivity: ["$1,240 / $2,000 raised", "138 pre-saves", "Demo unlock at 75%"],
                blurb: "Launching the Collab Lab winner into a cultural moment."),
        FanCrew(id: "cr-prism", name: "PRISM Festival Crew", focus: .event, focusLabel: "PRISM Festival 2026", members: 2_100, impactScore: 79,
                currentMission: "Coordinate meetups + ride shares", recentActivity: ["7 friends going", "Afterparty board live", "Glow squad outfits planned"],
                blurb: "Find your people on the field before the gates open."),
    ]
    static func crew(_ id: String) -> FanCrew? { fanCrews.first { $0.id == id } }

    // MARK: - Artist Need Board

    static let artistNeeds: [ArtistNeed] = [
        ArtistNeed(id: "an1", artistId: "a6", artistName: "Sable Mirage", type: .vocalist, location: "Atlanta / Remote", genre: "Alt-R&B",
                   deadlineText: "5 days left", description: "Need an airy topline vocalist for a late-night cut. Smoky, restrained, lots of space.", compensation: "Featured credit + split placeholder"),
        ArtistNeed(id: "an2", artistId: "a8", artistName: "Marisol Vega", type: .producer, location: "Miami", genre: "Reggaeton",
                   deadlineText: "9 days left", description: "Looking for a producer to build the world around my topline. Bring the dembow.", compensation: "Production credit + split placeholder"),
        ArtistNeed(id: "an3", artistId: "a1", artistName: "NOVA REIGN", type: .videographer, location: "Los Angeles", genre: "Hyperpop",
                   deadlineText: "2 weeks left", description: "Need a videographer for a one-night neon parking-structure shoot. Must love chaos.", compensation: "Paid + on-screen credit (placeholder)"),
        ArtistNeed(id: "an4", artistId: "a4", artistName: "LUNA TIDE", type: .opener, location: "Portland", genre: "Dream Pop",
                   deadlineText: "1 week left", description: "Seeking a local opener for my Portland show. Ethereal, ambient, dreamy welcome.", compensation: "Door split + exposure (placeholder)"),
        ArtistNeed(id: "an5", artistId: "a3", artistName: "Velvet Static", type: .mixEngineer, location: "Remote", genre: "Indie Rock",
                   deadlineText: "4 days left", description: "Fuzzed-out track needs a mix that keeps the grit but tames the harshness.", compensation: "Mix credit + flat fee (placeholder)"),
        ArtistNeed(id: "an6", artistId: "a7", artistName: "GLITCHCORE KID", type: .coverArt, location: "Remote", genre: "Hyperpop",
                   deadlineText: "6 days left", description: "Want a chaotic, datamoshed cover for the deluxe drop. Group-chat energy.", compensation: "Art credit + payment (placeholder)"),
        ArtistNeed(id: "an7", artistId: "a2", artistName: "Kairo Sol", type: .streetTeam, location: "Brooklyn", genre: "Afro-House",
                   deadlineText: "Open", description: "Building a street team to flyer the rooftop series and run the meetup board.", compensation: "Free entry + crew status"),
        ArtistNeed(id: "an8", artistId: "a5", artistName: "BASSLINE PROPHET", type: .remixPartner, location: "Detroit / Remote", genre: "Dubstep",
                   deadlineText: "1 week left", description: "Open the stems and flip the drop. Heaviest, cleanest flip gets an official release.", compensation: "Remix credit + split placeholder"),
    ]

    // MARK: - Video Premieres

    static let videoPremieres: [VideoPremiere] = [
        VideoPremiere(id: "vp1", videoId: "mv-s1", artistId: "a1", artistName: "NOVA REIGN", title: "Neon Bloodstream",
                      countdownText: "Tonight · 8PM PT", isLive: false, previewSeed: "Neon Bloodstream video",
                      artistIntro: "I built this whole night in a parking structure with 400 of you. Let's light it up together.",
                      reactions: 4_210, premiereStatus: "World Premiere"),
        VideoPremiere(id: "vp2", videoId: "mv-collab", artistId: "a3", artistName: "Velvet Static × LUNA TIDE", title: "Static & Gold",
                      countdownText: "Live now", isLive: true, previewSeed: "Static & Gold video",
                      artistIntro: "This started as a VYBE open-verse challenge. You made it real. Watch it with us.",
                      reactions: 3_560, premiereStatus: "Born on VYBE Premiere"),
        VideoPremiere(id: "vp3", videoId: "mv-glitch2", artistId: "a7", artistName: "GLITCHCORE KID", title: "error404heart",
                      countdownText: "Fri · 11PM CT", isLive: false, previewSeed: "error404heart video",
                      artistIntro: "a webcam premiere for 12 people became a cult clip. round two, but bigger.",
                      reactions: 620, premiereStatus: "Underground Premiere"),
    ]
    static func premiere(_ id: String) -> VideoPremiere? { videoPremieres.first { $0.id == id } }
    static var livePremiere: VideoPremiere? { videoPremieres.first { $0.isLive } ?? videoPremieres.first }
}
