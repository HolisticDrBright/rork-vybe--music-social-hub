//
//  AppState.swift
//  VYBE
//
//  Observable app-wide state: role, onboarding, social/viral tracking, saved/followed,
//  earnings tracking, VYBE Loop, support actions, trust & safety.
//

import SwiftUI
import Observation

@Observable
final class AppState {
    var hasOnboarded = false
    var role: UserRole = .fan
    var selectedMoodFilter: String? = nil

    // Onboarding taste capture
    var taste = OnboardingTaste()

    // Saved / followed
    var savedSongs: Set<String> = ["s3"]
    var followedArtists: Set<String> = ["a1", "a4"]

    // VYBE Score + viral tracking (mock)
    var vybeScore: Int = 128_450
    var shareCount: Int = 342
    var referralCount: Int = 27
    var streamsGenerated: Int = 184_900
    var viralImpact: Int = 87   // 0-100

    // Support actions tracking
    var tipsSent: Int = 60      // dollars tipped
    var dropsBought: Int = 2
    var showsAttended: Int = 12
    var totalEarningsDriven: Int = 2_385  // total dollars the fan drove to artists

    // Liked board posts (by id)
    var likedPosts: Set<String> = []
    // RSVP'd events
    var rsvpEvents: Set<String> = []
    // Joined communities
    var joinedCommunities: Set<String> = ["cm1", "cm4"]
    // Completed challenges
    var joinedChallenges: Set<String> = []

    var fanRank: Int = 5

    // --- VYBE Loop ---
    var loopActive = false
    var loopStep = 0
    // 0 = discover artist, 1 = support artist, 2 = see payoff, 3 = unlock reward, 4 = artist recognition
    var loopArtistId = "a4"  // LUNA TIDE as the starter artist
    var loopArtist = Mock.artist("a4")
    var loopSongId = "s3"    // Gravity Loves You
    var loopReceipt: SupportReceipt? = nil
    var loopShowPayoff = false

    // --- Vibe Check State ---
    /// Currently selected mood in the Vibe Check view.
    var vibeCheckMood: VibeMood? = nil
    /// SHIFT target mood.
    var vibeShiftTarget: VibeMood? = nil
    /// Vibe Check mode: "match" or "shift".
    var vibeMode: String = "match"
    /// Free-text feeling input.
    var vibeFreeText: String = ""
    /// Energy slider value (0-100).
    var vibeEnergy: Double = 50
    /// Mood history log.
    var moodHistory: [MoodHistoryEntry] = []
    /// Whether to show the wellbeing nudge for heavy moods.
    var vibeShowWellbeingNudge: Bool = false
    /// All mood-matched results from the last query.
    var vibeResults: [Song] = []
    /// SHIFT journey phases from the last query.
    var vibeShiftPhases: [MoodJourneyPhase] = []

    // --- Artist-side earnings (for Artist Dashboard) ---
    var artistLiveEarnings: Int = 281_700  // mock live total for NOVA REIGN
    var artistStreamingEquivalent: Int = 16_500
    var artistTrackerVisible = false

    // --- Support receipt history ---
    var receiptHistory: [SupportReceipt] = []

    // --- Discovery (#17 "Unknowns Like Your Favorites") ---
    /// Artists the fan personally discovered & supported via Hidden Gems.
    var discoveredArtists: Set<String> = []
    /// Genres surfaced through discovery — feeds the "Music Personality" section.
    var discoveredGenres: Set<String> = []

    // --- Collab Lab (artist-to-artist collaboration) ---
    /// The artist the user is acting as on the artist side (creator of "My Challenges").
    let collabArtistId = Mock.collabArtistId
    /// Live, mutable collab state (prototype: local @Observable mutations).
    var collabChallenges: [CollabChallenge] = Mock.collabChallenges
    var collabSubmissions: [CollabSubmission] = Mock.collabSubmissions
    var upcomingDrops: [UpcomingDrop] = Mock.upcomingDrops
    /// Open challenges the user has submitted to.
    var submittedChallengeIds: Set<String> = []
    /// Upcoming drops the fan has pre-saved / supported early.
    var presavedDrops: Set<String> = []
    /// Collab-related fan badges earned ("First Heard It", "Collab Scout").
    var collabBadges: Set<String> = []

    // --- Sleeves + Videos (album-worlds) ---
    /// Sleeve ids the fan has opened.
    var openedSleeves: Set<String> = []
    /// Sleeves whose art the fan reacted to.
    var reactedSleeves: Set<String> = []
    /// Video ids the fan has watched.
    var watchedVideos: Set<String> = []
    /// Sleeve/video badges earned ("First Opened It", "Sleeve Collector", "Video Premiere Crew").
    var sleeveBadges: Set<String> = []
    /// Sleeves created by the artist in the Sleeve Builder (prototype, in-session).
    var customSleeves: [SongSleeve] = []

    // --- Culture systems (drop campaigns, missions, crews, premieres) ---
    var dropCampaigns: [DropCampaign] = Mock.dropCampaigns
    var artistMissions: [ArtistMission] = Mock.artistMissions
    var joinedCrews: Set<String> = []
    var supportedCampaigns: Set<String> = []
    var contributedMissions: Set<String> = []
    /// Culture badges ("First Heard It", "Early Discoverer", "Premiere Crew", "Crew Member").
    var cultureBadges: Set<String> = []

    // --- Notification preferences (local prototype; real push needs a backend) ---
    var notifyBeforeTheyBlow = false
    var notifyPremieres = false

    init() {
        loadPersisted()
    }

    // --- Haptic feedback helper ---
    func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    func hapticSuccess() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    func hapticWarning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    // MARK: - Actions

    func toggleSave(_ songId: String) {
        if savedSongs.contains(songId) { savedSongs.remove(songId) }
        else { savedSongs.insert(songId); addScore(50, reason: "Saved song") }
    }

    func toggleFollow(_ artistId: String) {
        if followedArtists.contains(artistId) { followedArtists.remove(artistId) }
        else { followedArtists.insert(artistId); addScore(100, reason: "Followed artist") }
    }

    func share(_ title: String) {
        shareCount += 1
        let streams = Int.random(in: 120...900)
        streamsGenerated += streams
        totalEarningsDriven += Int(Double(streams) * 0.12)
        viralImpact = min(100, viralImpact + 1)
        addScore(250, reason: "Shared \(title)")
    }

    func refer() {
        referralCount += 1
        addScore(500, reason: "Referred a friend")
    }

    func toggleLike(_ postId: String) {
        if likedPosts.contains(postId) { likedPosts.remove(postId) }
        else { likedPosts.insert(postId); addScore(10, reason: "Liked a post") }
    }

    func toggleRSVP(_ eventId: String) {
        if rsvpEvents.contains(eventId) { rsvpEvents.remove(eventId) }
        else {
            rsvpEvents.insert(eventId)
            showsAttended += 1
            addScore(300, reason: "RSVP'd to event")
        }
    }

    func toggleCommunity(_ id: String) {
        if joinedCommunities.contains(id) { joinedCommunities.remove(id) }
        else { joinedCommunities.insert(id); addScore(75, reason: "Joined community") }
    }

    func joinChallenge(_ id: String, reward: Int) {
        guard !joinedChallenges.contains(id) else { return }
        joinedChallenges.insert(id)
        addScore(reward, reason: "Joined challenge")
    }

    /// Tip an artist (mock dollars)
    func tipArtist(_ artistId: String, amount: Int) {
        _ = recordSupport(.tip(amount), artist: Mock.artist(artistId))
    }

    /// Buy a drop (exclusive content)
    func buyDrop(_ artistId: String, amount: Int) {
        _ = recordSupport(.buyDrop(amount), artist: Mock.artist(artistId))
    }

    /// Boost (amplify share reach)
    func boost(_ artistId: String) {
        _ = recordSupport(.boost, artist: Mock.artist(artistId))
    }

    func addScore(_ pts: Int, reason: String = "") {
        withAnimation(.snappy) { vybeScore += pts }
        persist()
    }

    // MARK: - Role

    func setRole(_ r: UserRole) {
        withAnimation(.snappy) { role = r }
        haptic(.light)
        persist()
    }

    /// Toggle local notification preferences. Real push needs a backend; this
    /// schedules a local notification as the prototype stand-in.
    func setNotify(beforeTheyBlow: Bool? = nil, premieres: Bool? = nil) {
        if let b = beforeTheyBlow {
            notifyBeforeTheyBlow = b
            if b { NotificationService.scheduleBeforeTheyBlowDemo() }
        }
        if let p = premieres {
            notifyPremieres = p
            if p { NotificationService.schedulePremiereDemo() }
        }
        haptic(.light)
        persist()
    }

    // MARK: - Local persistence (prototype: UserDefaults + Codable)

    private static let storeKey = "vybe.persisted.v1"

    /// Codable snapshot of mutable prototype state.
    private struct PersistedState: Codable {
        var role: String
        var vybeScore: Int
        var totalEarningsDriven: Int
        var shareCount: Int
        var referralCount: Int
        var fanRank: Int
        var savedSongs: Set<String>
        var followedArtists: Set<String>
        var discoveredArtists: Set<String>
        var discoveredGenres: Set<String>
        var joinedCrews: Set<String>
        var supportedCampaigns: Set<String>
        var submittedChallengeIds: Set<String>
        var presavedDrops: Set<String>
        var openedSleeves: Set<String>
        var reactedSleeves: Set<String>
        var watchedVideos: Set<String>
        var cultureBadges: Set<String>
        var sleeveBadges: Set<String>
        var collabBadges: Set<String>
        var fanRankByArtist: [String: Int]
        var collabChallenges: [CollabChallenge]
        var collabSubmissions: [CollabSubmission]
        var upcomingDrops: [UpcomingDrop]
        var dropCampaigns: [DropCampaign]
        var artistMissions: [ArtistMission]
        var customSleeves: [SongSleeve]
        var notifyBeforeTheyBlow: Bool
        var notifyPremieres: Bool
    }

    /// Snapshot + save (called from every mutating action via addScore and key mutators).
    func persist() {
        let snap = PersistedState(
            role: role.rawValue, vybeScore: vybeScore, totalEarningsDriven: totalEarningsDriven,
            shareCount: shareCount, referralCount: referralCount, fanRank: fanRank,
            savedSongs: savedSongs, followedArtists: followedArtists,
            discoveredArtists: discoveredArtists, discoveredGenres: discoveredGenres,
            joinedCrews: joinedCrews, supportedCampaigns: supportedCampaigns,
            submittedChallengeIds: submittedChallengeIds, presavedDrops: presavedDrops,
            openedSleeves: openedSleeves, reactedSleeves: reactedSleeves, watchedVideos: watchedVideos,
            cultureBadges: cultureBadges, sleeveBadges: sleeveBadges, collabBadges: collabBadges,
            fanRankByArtist: fanRankByArtist,
            collabChallenges: collabChallenges, collabSubmissions: collabSubmissions,
            upcomingDrops: upcomingDrops, dropCampaigns: dropCampaigns,
            artistMissions: artistMissions, customSleeves: customSleeves,
            notifyBeforeTheyBlow: notifyBeforeTheyBlow, notifyPremieres: notifyPremieres)
        if let data = try? JSONEncoder().encode(snap) {
            UserDefaults.standard.set(data, forKey: Self.storeKey)
        }
    }

    /// Load persisted state on launch; missing/incompatible data falls back to mock defaults.
    private func loadPersisted() {
        guard let data = UserDefaults.standard.data(forKey: Self.storeKey),
              let s = try? JSONDecoder().decode(PersistedState.self, from: data) else { return }
        role = UserRole(rawValue: s.role) ?? .fan
        vybeScore = s.vybeScore
        totalEarningsDriven = s.totalEarningsDriven
        shareCount = s.shareCount
        referralCount = s.referralCount
        fanRank = s.fanRank
        savedSongs = s.savedSongs
        followedArtists = s.followedArtists
        discoveredArtists = s.discoveredArtists
        discoveredGenres = s.discoveredGenres
        joinedCrews = s.joinedCrews
        supportedCampaigns = s.supportedCampaigns
        submittedChallengeIds = s.submittedChallengeIds
        presavedDrops = s.presavedDrops
        openedSleeves = s.openedSleeves
        reactedSleeves = s.reactedSleeves
        watchedVideos = s.watchedVideos
        cultureBadges = s.cultureBadges
        sleeveBadges = s.sleeveBadges
        collabBadges = s.collabBadges
        fanRankByArtist = s.fanRankByArtist
        if !s.collabChallenges.isEmpty { collabChallenges = s.collabChallenges }
        if !s.collabSubmissions.isEmpty { collabSubmissions = s.collabSubmissions }
        if !s.upcomingDrops.isEmpty { upcomingDrops = s.upcomingDrops }
        if !s.dropCampaigns.isEmpty { dropCampaigns = s.dropCampaigns }
        if !s.artistMissions.isEmpty { artistMissions = s.artistMissions }
        customSleeves = s.customSleeves
        notifyBeforeTheyBlow = s.notifyBeforeTheyBlow
        notifyPremieres = s.notifyPremieres
    }

    /// Reset all prototype progress (used by demo mode).
    func resetPrototype() {
        UserDefaults.standard.removeObject(forKey: Self.storeKey)
    }

    /// Whether a named status badge has been earned (drives the badge grids).
    func hasBadge(_ name: String) -> Bool {
        let all = cultureBadges.union(sleeveBadges).union(collabBadges)
        if all.contains(name) { return true }
        switch name {
        case "Early Discoverer": return !discoveredArtists.isEmpty
        case "First Heard It": return !supportedCampaigns.isEmpty || !presavedDrops.isEmpty
        case "First Opened It": return !openedSleeves.isEmpty
        case "Sleeve Collector": return openedSleeves.count >= 3
        case "Video Premiere Crew": return cultureBadges.contains("Premiere Crew") || !watchedVideos.isEmpty
        case "Collab Scout": return !joinedCrews.isEmpty
        default: return false
        }
    }

    // MARK: - Canonical support engine

    /// Log of every support action — powers the artist dashboard activity feed.
    var supportEvents: [SupportEvent] = []
    /// The fan's live rank on each artist's board (lower = better).
    var fanRankByArtist: [String: Int] = [:]

    /// The fan's current rank on an artist's board.
    func rank(forArtist artistId: String) -> Int {
        fanRankByArtist[artistId]
            ?? Mock.fundedArtists.first { $0.artistId == artistId }?.rank
            ?? Int.random(in: 38...92)
    }

    private func improveRank(_ artistId: String) -> Int {
        let improved = max(1, rank(forArtist: artistId) - Int.random(in: 3...12))
        fanRankByArtist[artistId] = improved
        return improved
    }

    /// The single, reusable support → receipt pipeline. Every meaningful support
    /// action routes through here so economics, scoring, rank, the activity log,
    /// and the shareable receipt all stay consistent.
    @discardableResult
    func recordSupport(_ action: SupportAction, artist: Artist, songTitle: String? = nil, badge: String? = nil) -> SupportReceipt {
        let outcome = SupportEconomics.outcome(for: action)

        // Per-action counters.
        switch action {
        case .share, .discover: shareCount += 1
        case .tip(let amt): tipsSent += amt
        case .buyDrop: dropsBought += 1
        case .rsvp: showsAttended += 1
        default: break
        }

        // Core economy.
        streamsGenerated += outcome.streams
        totalEarningsDriven += max(1, Int(outcome.artistDollars.rounded()))
        artistLiveEarnings += max(1, Int(outcome.artistDollars.rounded()))
        viralImpact = min(100, viralImpact + outcome.viralBump)
        addScore(outcome.score, reason: action.verb)

        let newRank = improveRank(artist.id)

        // Activity log (newest first).
        supportEvents.insert(SupportEvent(
            id: UUID().uuidString, artistId: artist.id, artistName: artist.name,
            fanName: "you", verb: action.verb, dollars: outcome.artistDollars,
            score: outcome.score, minutesAgo: 0), at: 0)

        let receipt = SupportEconomics.makeReceipt(
            artist: artist, action: action, outcome: outcome,
            newRank: newRank, songTitle: songTitle, badge: badge)
        receiptHistory.append(receipt)
        hapticSuccess()
        persist()
        return receipt
    }

    // MARK: - Collab Lab

    func collabChallenge(_ id: String) -> CollabChallenge? { collabChallenges.first { $0.id == id } }

    /// Challenges created by the artist the user is acting as.
    var myChallenges: [CollabChallenge] { collabChallenges.filter { $0.creatorArtistId == collabArtistId } }
    /// Open challenges from other artists the user can submit to.
    var openChallenges: [CollabChallenge] { collabChallenges.filter { $0.status == .open && $0.creatorArtistId != collabArtistId } }
    /// The user's own outgoing submissions.
    var mySubmissions: [CollabSubmission] { collabSubmissions.filter { submittedChallengeIds.contains($0.challengeId) && $0.artistName == "You" } }

    func submissions(for challengeId: String) -> [CollabSubmission] {
        collabSubmissions.filter { $0.challengeId == challengeId }
    }
    /// Total incoming submissions across the user's challenges.
    var incomingSubmissionCount: Int {
        myChallenges.reduce(0) { $0 + submissions(for: $1.id).count }
    }

    private func updateChallenge(_ id: String, _ mutate: (inout CollabChallenge) -> Void) {
        if let i = collabChallenges.firstIndex(where: { $0.id == id }) { mutate(&collabChallenges[i]) }
    }
    private func updateSubmission(_ id: String, _ mutate: (inout CollabSubmission) -> Void) {
        if let i = collabSubmissions.firstIndex(where: { $0.id == id }) { mutate(&collabSubmissions[i]) }
    }

    /// Post a new challenge (appears under "My Challenges").
    func createChallenge(_ challenge: CollabChallenge) {
        withAnimation(.snappy) { collabChallenges.insert(challenge, at: 0) }
        addScore(150, reason: "Posted a Collab Lab challenge")
        hapticSuccess()
    }

    /// Submit a creative response to an open challenge.
    func submit(_ submission: CollabSubmission) {
        withAnimation(.snappy) {
            collabSubmissions.insert(submission, at: 0)
            submittedChallengeIds.insert(submission.challengeId)
            updateChallenge(submission.challengeId) { $0.submissionCount += 1 }
        }
        addScore(200, reason: "Submitted to a Collab Lab challenge")
        hapticSuccess()
    }

    func toggleShortlist(_ submissionId: String) {
        updateSubmission(submissionId) { sub in
            sub.status = (sub.status == .shortlisted) ? .submitted : .shortlisted
        }
        haptic(.light)
        persist()
    }
    func reactToSubmission(_ submissionId: String) {
        updateSubmission(submissionId) { $0.reactions += 1 }
        haptic(.light)
        persist()
    }
    func declineSubmission(_ submissionId: String) {
        updateSubmission(submissionId) { $0.status = .declined }
        haptic(.light)
        persist()
    }

    /// Pick a winner: converts the challenge into an Upcoming Drop and returns it.
    @discardableResult
    func pickWinner(submissionId: String, challengeId: String) -> UpcomingDrop {
        let winner = collabSubmissions.first { $0.id == submissionId }
        let challenge = collabChallenge(challengeId)
        updateSubmission(submissionId) { $0.status = .selected }
        updateChallenge(challengeId) { ch in
            ch.status = .convertedToDrop
            ch.selectedSubmissionId = submissionId
        }
        let creator = challenge?.creatorName ?? "You"
        let collaborator = winner?.artistName ?? "Featured Artist"
        let beat = challenge?.beatTitle ?? "Untitled"
        let stamp = Int(Date().timeIntervalSince1970)
        let campaignId = "dc-collab-\(challengeId)-\(stamp)"
        var drop = UpcomingDrop(
            id: "ud-\(challengeId)-\(stamp)",
            title: "\(beat) (feat. \(collaborator))",
            artistNames: [creator, collaborator],
            originChallengeId: challengeId,
            bornOnVYBE: true,
            description: "Born on VYBE — started as \(creator)'s \(challenge?.challengeType.label ?? "Collab") challenge. \(collaborator) won the feature.",
            genre: challenge?.genre ?? "Music",
            earlySupporters: 0,
            previewSeed: challenge?.previewSeed ?? beat,
            splitNote: challenge?.proposedSplit ?? "50/50 (placeholder)",
            releaseText: "Upcoming")
        drop.campaignId = campaignId

        // Unified drop object: the collab winner also flows into a Drop Campaign
        // (+ a VYBE TV premiere via the collab video) so the moment carries through.
        let campaign = DropCampaign(
            id: campaignId, artistId: challenge?.creatorArtistId ?? collabArtistId, artistName: creator,
            title: "\(beat) (feat. \(collaborator))",
            subtitle: "Born on VYBE — \(creator) × \(collaborator).",
            status: .upcoming, countdownText: "Just started · help it break",
            coverSeed: challenge?.previewSeed ?? beat, videoId: "mv-collab",
            supportGoalUSD: 1_000, raisedUSD: 0, boostGoal: 500, boosts: 0,
            presaveGoal: 150, presaves: 0, earningsGoalUSD: 900, missionIds: [],
            rewards: ["First Heard It badge", "Name in the credits", "Early demo unlock"],
            bornOnVYBE: true)

        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            upcomingDrops.insert(drop, at: 0)
            dropCampaigns.insert(campaign, at: 0)
        }
        cultureBadges.insert("Collab Scout")
        addScore(500, reason: "Started a collab")
        hapticSuccess()
        persist()
        return drop
    }

    /// Fan pre-saves / supports an upcoming collab drop early — produces a receipt.
    @discardableResult
    func presaveDrop(_ dropId: String) -> SupportReceipt? {
        guard let i = upcomingDrops.firstIndex(where: { $0.id == dropId }) else { return nil }
        let drop = upcomingDrops[i]
        let alreadyPresaved = presavedDrops.contains(dropId)
        presavedDrops.insert(dropId)
        if !alreadyPresaved { upcomingDrops[i].earlySupporters += 1 }
        collabBadges.insert("First Heard It")
        collabBadges.insert("Collab Scout")
        let artist = Mock.artists.first { drop.artistNames.contains($0.name) } ?? Mock.artist("a1")
        return recordSupport(.buyDrop(8), artist: artist, songTitle: drop.title, badge: "First Heard It — backed it early")
    }

    // MARK: - Sleeves + Videos

    /// All sleeves available to the app (mock + builder-created).
    var allSleeves: [SongSleeve] { Mock.sleeves + customSleeves }
    func sleeve(_ id: String) -> SongSleeve? { allSleeves.first { $0.id == id } }
    func sleeve(forSong songId: String) -> SongSleeve? { allSleeves.first { $0.songId == songId } }

    /// Open a sleeve — small VYBE Score + collector progress.
    func openSleeve(_ id: String) {
        guard !openedSleeves.contains(id) else { return }
        openedSleeves.insert(id)
        sleeveBadges.insert("First Opened It")
        if openedSleeves.count >= 3 { sleeveBadges.insert("Sleeve Collector") }
        addScore(30, reason: "Opened a sleeve")
        haptic(.light)
    }

    func reactToSleeveArt(_ id: String) {
        guard !reactedSleeves.contains(id) else { return }
        reactedSleeves.insert(id)
        addScore(10, reason: "Reacted to sleeve art")
        haptic(.light)
    }

    func watchVideo(_ video: MusicVideo) {
        let firstWatch = !watchedVideos.contains(video.id)
        watchedVideos.insert(video.id)
        if video.status == .premiere { sleeveBadges.insert("Video Premiere Crew") }
        if firstWatch { addScore(25, reason: "Watched a video") }
        hapticSuccess()
        persist()
    }

    /// Support a drop from inside a sleeve — bigger score + Sleeve Collector progress.
    @discardableResult
    func supportDrop(artist: Artist, title: String, amount: Int = 8) -> SupportReceipt {
        sleeveBadges.insert("Sleeve Collector")
        return recordSupport(.buyDrop(amount), artist: artist, songTitle: title,
                             badge: "Sleeve Collector progress unlocked")
    }

    /// Publish a builder-created sleeve (prototype, in-session).
    func publishSleeve(_ sleeve: SongSleeve) {
        withAnimation(.snappy) { customSleeves.insert(sleeve, at: 0) }
        addScore(150, reason: "Published a drop sleeve")
        hapticSuccess()
    }

    // MARK: - Culture Actions

    func dropCampaign(_ id: String) -> DropCampaign? { dropCampaigns.first { $0.id == id } }
    func mission(_ id: String) -> ArtistMission? { artistMissions.first { $0.id == id } }
    func missions(forArtist artistId: String) -> [ArtistMission] { artistMissions.filter { $0.artistId == artistId } }

    /// Support a drop campaign early — drives funding, earns First Heard It, returns a receipt.
    @discardableResult
    func supportCampaign(_ id: String, amount: Int = 10) -> SupportReceipt? {
        guard let i = dropCampaigns.firstIndex(where: { $0.id == id }) else { return nil }
        let artist = Mock.artist(dropCampaigns[i].artistId)
        let title = dropCampaigns[i].title
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            dropCampaigns[i].raisedUSD += amount
            dropCampaigns[i].presaves += 1
            if dropCampaigns[i].raisedUSD >= dropCampaigns[i].supportGoalUSD, dropCampaigns[i].status == .live {
                dropCampaigns[i].status = .funded
            }
        }
        supportedCampaigns.insert(id)
        cultureBadges.insert("First Heard It")
        cultureBadges.insert("Early Discoverer")
        return recordSupport(.buyDrop(amount), artist: artist, songTitle: title, badge: "First Heard It — early supporter")
    }

    func boostCampaign(_ id: String) {
        guard let i = dropCampaigns.firstIndex(where: { $0.id == id }) else { return }
        withAnimation(.snappy) { dropCampaigns[i].boosts += 1 }
        shareCount += 1
        viralImpact = min(100, viralImpact + 1)
        addScore(150, reason: "Boosted a drop")
        haptic(.light)
    }

    /// Contribute to an artist growth mission — advances progress + VYBE Score.
    /// Returns a support receipt when the contribution completes the mission.
    @discardableResult
    func contributeToMission(_ id: String) -> SupportReceipt? {
        guard let i = artistMissions.firstIndex(where: { $0.id == id }) else { return nil }
        let step = max(1, artistMissions[i].goal / 12)
        let wasComplete = artistMissions[i].progress >= artistMissions[i].goal
        withAnimation(.snappy) {
            artistMissions[i].progress = min(artistMissions[i].goal, artistMissions[i].progress + step)
        }
        contributedMissions.insert(id)
        let mission = artistMissions[i]
        let nowComplete = mission.progress >= mission.goal
        if nowComplete && !wasComplete {
            // Mission completed → a support receipt moment.
            cultureBadges.insert("First Heard It")
            let artist = Mock.artist(mission.artistId)
            return recordSupport(.challenge(mission.points), artist: artist, songTitle: mission.title, badge: "Mission complete: \(mission.reward)")
        }
        addScore(max(50, mission.points / 5), reason: "Helped a mission")
        hapticSuccess()
        return nil
    }

    /// Back a "Before They Blow" artist early — Early Discoverer + First Heard It.
    func backEarly(_ alert: BeforeTheyBlowAlert) {
        cultureBadges.insert("Early Discoverer")
        cultureBadges.insert("First Heard It")
        if let art = Mock.artists.first(where: { $0.id == alert.artistId }) {
            discoveredArtists.insert(art.id)
            discoveredGenres.insert(art.genre)
            _ = recordSupport(.discover, artist: art, badge: "Early Discoverer unlocked")
        } else {
            addScore(200, reason: "Backed \(alert.artistName) early")
            hapticSuccess()
        }
    }

    func toggleCrew(_ id: String) {
        if joinedCrews.contains(id) {
            joinedCrews.remove(id)
        } else {
            joinedCrews.insert(id)
            cultureBadges.insert("Collab Scout")
            cultureBadges.insert("Crew Member")
            addScore(120, reason: "Joined a fan crew")
            hapticSuccess()
        }
        persist()
    }

    /// Support / react during a video premiere — earns Premiere Crew.
    @discardableResult
    func supportPremiere(_ premiere: VideoPremiere) -> SupportReceipt {
        cultureBadges.insert("Premiere Crew")
        if let vid = premiere.videoId, let v = Mock.video(vid) { watchVideo(v) }
        let artist = Mock.artist(premiere.artistId)
        return recordSupport(.boost, artist: artist, songTitle: premiere.title, badge: "Premiere Crew unlocked")
    }

    // MARK: - VYBE Loop

    func startLoop() {
        loopActive = true
        loopStep = 0
        loopShowPayoff = false
        loopReceipt = nil
    }

    func advanceLoop() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            loopStep += 1
        }
    }

    func endLoop() {
        withAnimation(.easeInOut(duration: 0.4)) {
            loopActive = false
        }
    }

    // MARK: - Vibe Check Actions

    /// Select a mood on the wheel, with wellbeing nudge for heavy moods.
    func selectVibeMood(_ mood: VibeMood) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            vibeCheckMood = mood
            vibeShowWellbeingNudge = mood.isHeavy
            vibeResults = []
            vibeShiftPhases = []
            vibeShiftTarget = nil
        }
        haptic(.light)
    }

    /// Run MATCH mode: find songs matching the selected mood and energy.
    func runVibeMatch() {
        guard let mood = vibeCheckMood else { return }
        haptic(.medium)
        
        // Match songs by mood keywords AND energy range proximity
        let energyTarget = vibeEnergy
        var scored = Mock.vibeCheckSongs.map { song -> (Song, Int) in
            let keywordMatch = mood.matchKeywords.contains(song.mood) ? 100 : 0
            let energyDelta = abs(song.energy - Int(energyTarget))
            let energyScore = max(0, 100 - energyDelta * 3)
            // Underground Rising bonus: songs by rising artists rank higher
            let artistIsRising = Mock.artists.first { $0.id == song.artistId }?.isUndergroundRising ?? false
            let risingBonus = artistIsRising ? 30 : 0
            return (song, keywordMatch + energyScore + risingBonus)
        }
        scored.sort { $0.1 > $1.1 }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            vibeResults = scored.prefix(8).map { $0.0 }
            vibeShiftPhases = []
        }
        
        // Log mood history
        let entry = MoodHistoryEntry(
            id: UUID().uuidString,
            moodId: mood.id,
            moodName: mood.name,
            timestamp: Date(),
            mode: "match"
        )
        moodHistory.append(entry)
        addScore(25, reason: "Vibe Check: feeling \(mood.name)")
    }

    /// Run SHIFT mode: journey from mood A to mood B in 3 phases.
    func runVibeShift() {
        guard let from = vibeCheckMood, let to = vibeShiftTarget else { return }
        haptic(.medium)
        
        let allSongs = Mock.vibeCheckSongs
        var phases: [MoodJourneyPhase] = []
        
        // Find or build a shift template
        let template = Mock.shiftTemplates.first { $0.from == from.id && $0.to == to.id }
        let phaseLabels = template?.phases ?? ["Phase 1", "Phase 2", "Phase 3"]
        let ratios: [Double] = [0.15, 0.5, 0.85] // blend toward B
        
        for (idx, ratio) in ratios.enumerated() {
            let targetEnergy = Double(from.energyLow) + (Double(to.energyLow) - Double(from.energyLow)) * ratio
            let blendMoods = ratio < 0.5 ? from.matchKeywords : to.matchKeywords
            
            var scored = allSongs.map { song -> (Song, Int) in
                let keywordMatch = blendMoods.contains(song.mood) ? 100 : 0
                let energyDelta = abs(song.energy - Int(targetEnergy))
                let energyScore = max(0, 100 - energyDelta * 3)
                let artistIsRising = Mock.artists.first { $0.id == song.artistId }?.isUndergroundRising ?? false
                let risingBonus = artistIsRising ? 30 : 0
                return (song, keywordMatch + energyScore + risingBonus)
            }
            scored.sort { $0.1 > $1.1 }
            
            phases.append(MoodJourneyPhase(
                label: phaseLabels[idx],
                songs: Array(scored.prefix(3).map { $0.0 }),
                blendRatio: ratio
            ))
        }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            vibeShiftPhases = phases
            vibeResults = []
        }
        
        // Log mood history
        let entry = MoodHistoryEntry(
            id: UUID().uuidString,
            moodId: from.id,
            moodName: "\(from.name) → \(to.name)",
            timestamp: Date(),
            mode: "shift"
        )
        moodHistory.append(entry)
        addScore(50, reason: "Vibe SHIFT: \(from.name) → \(to.name)")
    }

    /// Accept the wellbeing nudge — switch to SHIFT mode toward a brighter mood.
    func acceptWellbeingShift() {
        guard let heavy = vibeCheckMood, heavy.isHeavy else { return }
        vibeShowWellbeingNudge = false
        vibeMode = "shift"
        // Suggest a lift target
        let lifts: [String: String] = ["sad": "happy", "angry": "calm", "moody": "inspired"]
        if let targetId = lifts[heavy.id], let target = Mock.vibeMoods.first(where: { $0.id == targetId }) {
            vibeShiftTarget = target
        }
        haptic(.light)
    }

    /// Decline wellbeing nudge — continue with MATCH.
    func declineWellbeingShift() {
        vibeShowWellbeingNudge = false
        runVibeMatch()
    }

    /// Support an artist discovered through Vibe Check — grants Early Discoverer bonus.
    func supportFromVibeCheck(_ song: Song) {
        savedSongs.insert(song.id)
        followedArtists.insert(song.artistId)
        let artist = Mock.artist(song.artistId)
        if artist.isUndergroundRising || artist.popularityTier != "established" {
            discoveredArtists.insert(artist.id)
            discoveredGenres.insert(artist.genre)
        }
        _ = recordSupport(.discover, artist: artist, songTitle: song.title, badge: "Early Discoverer")
    }

    // MARK: - Discovery Actions

    /// Support an artist surfaced by the "Hidden Gems" engine. Tags the artist
    /// "Discovered by you", updates the fan's Music Personality, and returns a
    /// shareable Support Receipt for the moment.
    @discardableResult
    func supportDiscovery(_ artist: Artist) -> SupportReceipt {
        followedArtists.insert(artist.id)
        discoveredArtists.insert(artist.id)
        discoveredGenres.insert(artist.genre)
        return recordSupport(.discover, artist: artist, badge: "Early Discoverer unlocked!")
    }

    /// Simulate the full support action in the loop, routed through the reusable
    /// support engine so the payoff numbers are real (not hard-coded).
    func loopSupportArtist() {
        let artist = Mock.artist(loopArtistId)
        savedSongs.insert(loopSongId)
        followedArtists.insert(loopArtistId)
        discoveredArtists.insert(loopArtistId)
        discoveredGenres.insert(artist.genre)
        let songTitle = Mock.songs(for: loopArtistId).first?.title ?? "their latest single"
        loopReceipt = recordSupport(.share, artist: artist, songTitle: songTitle, badge: "Early Discoverer unlocked!")

        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            loopShowPayoff = true
        }
    }
}

/// Number formatting helpers for compact display (e.g. 12.4M).
extension Int {
    var compact: String {
        let n = Double(self)
        switch n {
        case 1_000_000...: return String(format: "%.1fM", n / 1_000_000)
        case 1_000...: return String(format: "%.1fK", n / 1_000)
        default: return "\(self)"
        }
    }
    var grouped: String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
