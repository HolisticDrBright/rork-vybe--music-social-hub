//
//  ArtistMissionsView.swift
//  VYBE
//
//  Artist Growth Missions — fan-completable missions that move real numbers
//  and pay out VYBE Score.
//

import SwiftUI

struct ArtistMissionsView: View {
    @Environment(AppState.self) private var app
    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Help artists grow")
                            .font(.system(size: 21, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                        Text("Complete missions to move real goals — tickets, boosts, shares — and earn VYBE Score + badges.")
                            .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(3)
                    }
                    .padding(16)
                    .background { ZStack { VYBE.card; HoloArt(seed: "missionhero").opacity(0.12) }.clipShape(.rect(cornerRadius: 20)) }
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.gold.opacity(0.25), lineWidth: 1))
                    ForEach(app.artistMissions) { MissionCard(mission: $0) }
                }
                .padding(.horizontal, 20).padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Growth Missions")
        .navigationBarTitleDisplayMode(.large)
        .vybeDestinations()
    }
}
