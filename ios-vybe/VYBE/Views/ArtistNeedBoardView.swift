//
//  ArtistNeedBoardView.swift
//  VYBE
//
//  Artist Need Board — practical "who can help me" posts (vocalist, producer,
//  videographer, opener, street team, …). Connects with Collab Lab.
//

import SwiftUI

struct ArtistNeedBoardView: View {
    @State private var filter = "All"
    private var filters: [String] { ["All"] + NeedType.allCases.map(\.label) }
    private var needs: [ArtistNeed] {
        filter == "All" ? Mock.artistNeeds : Mock.artistNeeds.filter { $0.type.label == filter }
    }

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Real help, posted by artists. Respond and connect — or open a full collab in Collab Lab.")
                        .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    NavigationLink(value: Route.collabLab) {
                        HStack(spacing: 10) {
                            Image(systemName: "person.2.wave.2.fill").foregroundStyle(.white)
                                .frame(width: 38, height: 38).background(VYBE.holo, in: .circle)
                            VStack(alignment: .leading, spacing: 1) {
                                Text("Open a Collab Lab challenge").font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                                Text("Post a beat and let artists submit").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                            }
                            Spacer(); Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
                        }
                        .padding(14).vybeCard(corner: 16)
                    }
                    .buttonStyle(.plain)
                    ChipRow(items: filters, selection: $filter).padding(.horizontal, -20)
                    ForEach(needs) { NeedCard(need: $0) }
                }
                .padding(.horizontal, 20).padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Artist Need Board")
        .navigationBarTitleDisplayMode(.large)
        .vybeDestinations()
    }
}
