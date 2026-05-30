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
        tipsSent += amount
        totalEarningsDriven += amount
        addScore(amount * 2, reason: "Tipped artist")
        artistLiveEarnings += amount
    }

    /// Buy a drop (exclusive content)
    func buyDrop(_ artistId: String, amount: Int) {
        dropsBought += 1
        totalEarningsDriven += amount
        addScore(amount * 3, reason: "Bought exclusive drop")
        artistLiveEarnings += amount
    }

    /// Boost (amplify share reach)
    func boost(_ artistId: String) {
        addScore(150, reason: "Boosted artist")
        totalEarningsDriven += 15
        artistLiveEarnings += 15
    }

    func addScore(_ pts: Int, reason: String = "") {
        withAnimation(.snappy) { vybeScore += pts }
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
        // Early Discoverer bonus for underground artists
        let isRising = Mock.artists.first { $0.id == song.artistId }?.isUndergroundRising ?? false
        let bonus = isRising ? 200 : 75
        addScore(bonus, reason: "Early Discoverer: supported \(song.artistName)")
        hapticSuccess()
        
        // Also generate a support receipt
        let artist = Mock.artist(song.artistId)
        let receipt = Mock.generateReceipt(for: artist, action: "Discovered via Vibe Check: \(song.title)", score: bonus, streams: 500)
        receiptHistory.append(receipt)
    }

    /// Simulate the full support action in the loop
    func loopSupportArtist() {
        let artist = Mock.artist(loopArtistId)
        let streams = Int.random(in: 500...2000)
        let scoreEarned = 750
        streamsGenerated += streams
        totalEarningsDriven += Int(Double(streams) * 0.12) + 10
        shareCount += 1
        viralImpact = min(100, viralImpact + 3)
        savedSongs.insert(loopSongId)
        followedArtists.insert(loopArtistId)

        addScore(scoreEarned, reason: "Supported \(artist.name)")
        hapticSuccess()

        loopReceipt = Mock.generateReceipt(
            for: artist,
            action: "Streamed & shared Gravity Loves You",
            score: scoreEarned,
            streams: streams
        )
        receiptHistory.append(loopReceipt!)

        // Artist also earns
        artistLiveEarnings += Int(Double(streams) * 0.12) + 10

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
