//
//  ViralStatsView.swift
//  VYBE
//
//  Social sharing + viral points tracking dashboard.
//

import SwiftUI

struct ViralStatsView: View {
    @Environment(AppState.self) private var app

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    impactHero
                    SectionHeader(title: "Your Viral Tracking")
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                        trackCard("square.and.arrow.up.fill", "Shares", "\(app.shareCount)", "+12 this week", VYBE.magenta)
                        trackCard("person.badge.plus", "Referrals", "\(app.referralCount)", "+3 this week", VYBE.cyan)
                        trackCard("waveform", "Streams Driven", app.streamsGenerated.compact, "+8.2K this week", VYBE.green)
                        trackCard("cursorarrow.click", "Clicks", "9.4K", "from your shares", VYBE.blue)
                    }
                    SectionHeader(title: "How You Earn")
                    earnList
                    SectionHeader(title: "Score Breakdown")
                    breakdown
                }
                .padding(.horizontal, 20).padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Viral Impact")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var impactHero: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle().stroke(.white.opacity(0.12), lineWidth: 14).frame(width: 150, height: 150)
                Circle().trim(from: 0, to: CGFloat(app.viralImpact) / 100)
                    .stroke(VYBE.holo, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                    .neonGlow(VYBE.magenta, radius: 14)
                VStack(spacing: 0) {
                    Text("\(app.viralImpact)").font(.system(size: 44, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                        .contentTransition(.numericText())
                    Text("IMPACT").font(.system(size: 11, weight: .heavy, design: .rounded)).tracking(2).foregroundStyle(VYBE.textSecondary)
                }
            }
            Text("You're a Viral Promoter 🚀")
                .font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.magenta)
            Text("Your shares have generated \(app.streamsGenerated.grouped) streams for artists.")
                .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(20).vybeCard(corner: 22)
    }

    private func trackCard(_ icon: String, _ title: String, _ value: String, _ sub: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).font(.system(size: 18, weight: .bold)).foregroundStyle(color)
            Text(value).font(.system(size: 26, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                .contentTransition(.numericText())
            Text(title).font(.system(size: 13, weight: .bold)).foregroundStyle(VYBE.text)
            Text(sub).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding(16).vybeCard(corner: 18)
    }

    private var earnList: some View {
        VStack(spacing: 0) {
            earnRow("square.and.arrow.up.fill", "Share a song", "+250", VYBE.magenta)
            div; earnRow("person.badge.plus", "Refer a friend", "+500", VYBE.cyan)
            div; earnRow("video.fill", "Create content with a song", "+400", VYBE.purple)
            div; earnRow("headphones", "Drive a listen", "+50", VYBE.green)
            div; earnRow("bolt.fill", "Join a challenge", "+300", VYBE.gold)
            div; earnRow("ticket.fill", "Attend an event", "+300", VYBE.blue)
            div; earnRow("bag.fill", "Buy merch", "+200", VYBE.magenta)
        }
        .vybeCard(corner: 18)
    }

    private var div: some View { Divider().overlay(VYBE.stroke).padding(.leading, 50) }

    private func earnRow(_ icon: String, _ title: String, _ pts: String, _ color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(color).frame(width: 26)
            Text(title).font(.system(size: 14, weight: .semibold)).foregroundStyle(VYBE.text)
            Spacer()
            Text(pts).font(.system(size: 14, weight: .black, design: .rounded)).foregroundStyle(color)
        }
        .padding(14)
    }

    private var breakdown: some View {
        VStack(spacing: 10) {
            breakdownBar("Listen points", 0.9, "62.4K")
            breakdownBar("Share points", 0.7, "48.0K")
            breakdownBar("Concert points", 0.5, "12.6K")
            breakdownBar("Challenge points", 0.4, "5.4K")
        }
        .padding(16).vybeCard(corner: 18)
    }

    private func breakdownBar(_ label: String, _ v: Double, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(label).font(.system(size: 13, weight: .bold)).foregroundStyle(VYBE.text)
                Spacer()
                Text(value).font(.system(size: 12, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.magenta)
            }
            NeonProgressBar(progress: v)
        }
    }
}
