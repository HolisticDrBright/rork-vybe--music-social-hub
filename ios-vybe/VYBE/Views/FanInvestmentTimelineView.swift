//
//  FanInvestmentTimelineView.swift
//  VYBE
//
//  Fan Investment Timeline — when you discovered & backed artists, how far
//  they've come, and the earnings you drove. Taste as status.
//

import SwiftUI

struct FanInvestmentTimelineView: View {
    @Environment(AppState.self) private var app

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    summary
                    ForEach(Mock.fanInvestments) { row($0) }
                }
                .padding(.horizontal, 20).padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Your Investments")
        .navigationBarTitleDisplayMode(.large)
        .vybeDestinations()
    }

    private var summary: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("You were early.")
                .font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
            Text("You've backed \(Mock.fanInvestments.count) artists before they broke and supported them directly — they earn more here than streaming ever paid. Your taste is your track record.")
                .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(3)
        }
        .padding(16)
        .background { ZStack { VYBE.card; HoloArt(seed: "timelinehero").opacity(0.14) }.clipShape(.rect(cornerRadius: 20)) }
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.green.opacity(0.25), lineWidth: 1))
    }

    private func row(_ fi: FanInvestment) -> some View {
        NavigationLink(value: Route.artist(fi.artistId)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    AvatarView(seed: fi.artistName, size: 50)
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text(fi.artistName).font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                            if fi.wasEarly { StatusPill(text: "You were early", color: VYBE.green, icon: "checkmark.seal.fill") }
                        }
                        Text("\(fi.genre) · \(fi.firstSupportText) · rank #\(fi.fanRank)").font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                    }
                    Spacer()
                }
                // Growth arc
                HStack(spacing: 8) {
                    growthChip("\(fi.listenersWhenDiscovered.compact)", "when you backed")
                    Image(systemName: "arrow.right").font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.green)
                    growthChip("\(fi.listenersNow.compact)", "now")
                    Spacer()
                    VStack(spacing: 0) {
                        Text("\(fi.growthMultiple)×").font(.system(size: 18, weight: .black, design: .rounded)).foregroundStyle(VYBE.green)
                        Text("growth").font(.system(size: 9, weight: .semibold)).foregroundStyle(VYBE.textTertiary)
                    }
                }
                Text("You backed \(fi.artistName) at \(fi.listenersWhenDiscovered.compact) listeners. Now \(fi.listenersNow.compact). You've supported them directly ever since — worth far more than streaming.")
                    .font(.system(size: 13, weight: .medium, design: .serif)).foregroundStyle(VYBE.text.opacity(0.9)).lineSpacing(2)
                HStack(spacing: 6) {
                    Image(systemName: "flag.checkered").font(.system(size: 11)).foregroundStyle(VYBE.gold)
                    Text("Milestone: \(fi.milestone)").font(.system(size: 12, weight: .semibold)).foregroundStyle(VYBE.gold)
                }
            }
            .padding(16)
            .background { ZStack { VYBE.card; HoloArt(seed: fi.artistName + "tl").opacity(0.08) }.clipShape(.rect(cornerRadius: 20)) }
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.stroke, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func growthChip(_ v: String, _ l: String) -> some View {
        VStack(spacing: 1) {
            Text(v).font(.system(size: 15, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
            Text(l).font(.system(size: 9, weight: .medium)).foregroundStyle(VYBE.textSecondary)
        }
    }
}
