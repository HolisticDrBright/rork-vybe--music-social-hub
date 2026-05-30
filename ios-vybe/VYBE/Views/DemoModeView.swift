//
//  DemoModeView.swift
//  VYBE
//
//  Investor walkthrough — one tap into every key VYBE flow.
//

import SwiftUI

struct DemoModeView: View {
    @Environment(AppState.self) private var app
    @State private var didReset = false

    private var bornDropId: String { app.upcomingDrops.first?.id ?? "ud-static" }
    private var liveCampaignId: String { (app.dropCampaigns.first { $0.status == .live } ?? app.dropCampaigns.first)?.id ?? "dc-midnight" }

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    intro
                    loopButton
                    Group {
                        sectionLabel("The fan loop")
                        demoRow("sparkle.magnifyingglass", "Discover a Hidden Gem", "Sounds-like recommendations, support early", VYBE.green, .hiddenGems)
                        demoRow("waveform.path.ecg", "Before They Blow", "Back a rising artist before they break", VYBE.gold, .beforeTheyBlow)
                        demoRow("flame.fill", "Support a Drop", "Drive funding + get a support receipt", VYBE.magenta, .dropCampaign(liveCampaignId))
                        demoRow("rectangle.portrait.on.rectangle.portrait.angled.fill", "Open a Sleeve", "Art, fictional lyrics, liner notes, video", VYBE.cyan, .sleeve("sl-s3"))
                        demoRow("play.tv.fill", "VYBE TV Premiere", "Watch-party feel + Premiere Crew badge", VYBE.purple, .premiere("vp1"))
                    }
                    Group {
                        sectionLabel("The artist loop")
                        demoRow("person.2.wave.2.fill", "Launch a Collab Challenge", "Post a beat in Collab Lab", VYBE.magenta, .collabLab)
                        demoRow("crown.fill", "Pick a Collab Winner", "Review submissions on Midnight Signal", VYBE.gold, .collabReview("ch1"))
                        demoRow("sparkles", "Born on VYBE Drop", "The collab becomes an Upcoming Drop", VYBE.cyan, .upcomingDrop(bornDropId))
                        demoRow("chart.bar.xaxis.ascending", "Artist Dashboard", "Growth OS — switch to Artist Mode first", VYBE.purple, .dashboard)
                    }
                    resetButton
                }
                .padding(.horizontal, 20).padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Demo Mode")
        .navigationBarTitleDisplayMode(.large)
        .vybeDestinations()
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) { NeonTag(text: "INVESTOR WALKTHROUGH", color: VYBE.gold, icon: "play.rectangle.on.rectangle.fill"); Spacer() }
            Text("The anti-Spotify, in one tap each")
                .font(.system(size: 21, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
            Text("Discover early → support directly → artist earns → you gain status. Jump into any flow below.")
                .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(3)
        }
        .padding(16)
        .background { ZStack { VYBE.card; HoloArt(seed: "demohero").opacity(0.14) }.clipShape(.rect(cornerRadius: 20)) }
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.gold.opacity(0.25), lineWidth: 1))
    }

    private var loopButton: some View {
        Button { app.startLoop() } label: {
            HStack(spacing: 10) {
                Image(systemName: "wand.and.stars").font(.system(size: 16, weight: .bold))
                VStack(alignment: .leading, spacing: 1) {
                    Text("Play the guided VYBE Loop").font(.system(size: 15, weight: .heavy, design: .rounded))
                    Text("60-second discover → support → reward → recognition").font(.system(size: 11, weight: .medium)).foregroundStyle(.white.opacity(0.85))
                }
                Spacer()
                Image(systemName: "play.circle.fill").font(.system(size: 24))
            }
            .foregroundStyle(.white).padding(16).background(VYBE.holo, in: .rect(cornerRadius: 18)).neonGlow(VYBE.magenta, radius: 12)
        }
        .buttonStyle(.plain)
    }

    private func sectionLabel(_ t: String) -> some View {
        Text(t.uppercased()).font(.system(size: 11, weight: .heavy, design: .rounded)).tracking(1.5).foregroundStyle(VYBE.textSecondary).padding(.top, 6)
    }

    private func demoRow(_ icon: String, _ title: String, _ subtitle: String, _ color: Color, _ route: Route) -> some View {
        NavigationLink(value: route) {
            HStack(spacing: 12) {
                Image(systemName: icon).font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
                    .frame(width: 42, height: 42).background(color.opacity(0.9), in: .circle)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                    Text(subtitle).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(VYBE.textTertiary)
            }
            .padding(12).vybeCard(corner: 16)
        }
        .buttonStyle(.plain)
    }

    private var resetButton: some View {
        Button { app.resetPrototype(); didReset = true; app.haptic(.medium) } label: {
            HStack(spacing: 8) {
                Image(systemName: didReset ? "checkmark.circle.fill" : "arrow.counterclockwise")
                Text(didReset ? "Reset — relaunch to start fresh" : "Reset demo progress")
                    .font(.system(size: 13, weight: .bold))
            }
            .foregroundStyle(didReset ? VYBE.green : VYBE.textSecondary)
            .frame(maxWidth: .infinity).padding(.vertical, 12)
            .background(.white.opacity(0.05), in: .capsule)
        }
        .buttonStyle(.plain)
        .padding(.top, 8)
    }
}
