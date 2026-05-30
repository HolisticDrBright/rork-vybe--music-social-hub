//
//  Navigation.swift
//  VYBE
//
//  Shared navigation routes + destination wiring used by every tab's NavigationStack.
//

import SwiftUI

enum Route: Hashable {
    case artist(String)
    case song(String)
    case event(String)
    case aiChat(String)
    case leaderboard(String)
    case dashboard
    case communityBoard(String)
    case viralStats
    case settings
    case earnings(String)       // EarningsTransparencyView for an artist
    case receipt(SupportReceipt) // SupportReceiptView
    case report(String)          // ReportView with content id
    case vybeLoop               // Guided VYBE Loop demo
    case vibeCheck              // Vibe Check emotion-based discovery
    case hiddenGems             // "Unknowns Like Your Favorites" discovery engine
}

extension View {
    /// Attach all shared push destinations so any stack can navigate consistently.
    func vybeDestinations() -> some View {
        self.navigationDestination(for: Route.self) { route in
            switch route {
            case .artist(let id): ArtistProfileView(artistId: id)
            case .song(let id): SongDetailView(songId: id)
            case .event(let id): EventHubView(eventId: id)
            case .aiChat(let id): AIArtistChatView(artistId: id)
            case .leaderboard(let id): LeaderboardView(artistId: id)
            case .dashboard: ArtistDashboardView()
            case .communityBoard(let id): CommunityBoardView(communityId: id)
            case .viralStats: ViralStatsView()
            case .settings: SettingsView()
            case .earnings(let id): EarningsTransparencyView(artistId: id)
            case .receipt(let receipt): SupportReceiptView(receipt: receipt)
            case .report(let id): ReportView(contentId: id)
            case .vybeLoop: VYBELoopView()
            case .vibeCheck: VibeCheckView()
            case .hiddenGems: HiddenGemsView()
            }
        }
    }
}
