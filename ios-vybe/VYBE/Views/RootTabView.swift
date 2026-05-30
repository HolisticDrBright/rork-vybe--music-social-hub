//
//  RootTabView.swift
//  VYBE
//
//  Main tab view with persistent VYBE Score Orb and VYBE Loop overlay.
//

import SwiftUI

struct RootTabView: View {
    @Environment(AppState.self) private var app
    @State private var selection = 0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selection) {
                Tab("Home", systemImage: "house.fill", value: 0) {
                    NavigationStack { HomeView() }
                }
                Tab("Discover", systemImage: "sparkle.magnifyingglass", value: 1) {
                    NavigationStack { DiscoverView() }
                }
                Tab("Events", systemImage: "ticket.fill", value: 2) {
                    NavigationStack { EventsView() }
                }
                Tab("Vybes", systemImage: "person.3.fill", value: 3) {
                    NavigationStack { CommunitiesView() }
                }
                Tab("Rewards", systemImage: "gift.fill", value: 4) {
                    NavigationStack { RewardsView() }
                }
                Tab("Profile", systemImage: "person.crop.circle.fill", value: 5) {
                    NavigationStack { ProfileView() }
                }
            }
            .tint(VYBE.magenta)

            // Persistent floating Score Orb
            VYBEScoreOrb()
                .padding(.trailing, 16)
                .padding(.bottom, 88)
        }
        .overlay {
            // VYBE Loop overlay
            if app.loopActive {
                NavigationStack {
                    VYBELoopView()
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: app.loopActive)
            }
        }
    }
}
