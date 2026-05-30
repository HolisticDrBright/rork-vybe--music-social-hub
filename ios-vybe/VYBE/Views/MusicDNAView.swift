//
//  MusicDNAView.swift
//  VYBE
//
//  Music DNA / Taste Graph — a fan-facing identity built from taste, discovery,
//  and support behavior.
//

import SwiftUI

struct MusicDNAView: View {
    @Environment(AppState.self) private var app
    private var dna: MusicDNA { MusicDNA.build(app) }

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    hero
                    labels
                    chips("Top genres", dna.topGenres, VYBE.magenta, "guitars.fill")
                    chips("Top moods", dna.topMoods, VYBE.purple, "sparkles")
                    chips("Your scenes", dna.cityScenes, VYBE.cyan, "mappin.and.ellipse")
                    styleCard
                }
                .padding(.horizontal, 20).padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Music DNA")
        .navigationBarTitleDisplayMode(.large)
        .vybeDestinations()
    }

    private var hero: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle().fill(VYBE.holo).frame(width: 96, height: 96).neonGlow(VYBE.magenta, radius: 20)
                Image(systemName: "waveform.path.ecg.rectangle.fill").font(.system(size: 40)).foregroundStyle(.white)
            }
            Text("Your Music DNA").font(.system(size: 22, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
            HStack(spacing: 24) {
                StatBlock(value: "\(dna.artistsDiscovered)", label: "Discovered", color: VYBE.cyan)
                StatBlock(value: "\(dna.earlySupports)", label: "Early backs", color: VYBE.green)
                StatBlock(value: "$\(app.totalEarningsDriven.compact)", label: "Driven", color: VYBE.gold)
            }
        }
        .frame(maxWidth: .infinity).padding(16)
        .background { ZStack { VYBE.card; HoloArt(seed: "dnahero").opacity(0.16) }.clipShape(.rect(cornerRadius: 22)) }
    }

    private var labels: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Your taste identity")
            FlowChips(items: dna.labels, color: VYBE.magenta)
        }
    }

    private func chips(_ title: String, _ items: [String], _ color: Color, _ icon: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
            FlowChips(items: items, color: color)
        }
    }

    private var styleCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            styleRow("Discovery style", dna.discoveryStyle, "binoculars.fill", VYBE.cyan)
            Divider().overlay(VYBE.stroke)
            styleRow("Support style", dna.supportStyle, "bolt.heart.fill", VYBE.green)
        }
        .padding(16).vybeCard(corner: 20)
    }

    private func styleRow(_ title: String, _ body: String, _ icon: String, _ color: Color) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).font(.system(size: 16, weight: .bold)).foregroundStyle(color).frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Text(body).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(2)
            }
            Spacer()
        }
    }
}

/// Wrapping chip row (reuses FlowLayout from HiddenGemsView).
struct FlowChips: View {
    let items: [String]
    var color: Color = VYBE.purple
    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
                    .padding(.horizontal, 12).padding(.vertical, 7)
                    .background(color.opacity(0.14), in: .capsule)
                    .overlay(Capsule().stroke(color.opacity(0.35), lineWidth: 1))
            }
        }
    }
}
