//
//  EarningsTransparencyView.swift
//  VYBE
//
//  Full earnings breakdown for an artist: direct support vs streaming.
//  Shows "Artist keeps 90%" and the dramatic streaming comparison.
//

import SwiftUI

struct EarningsTransparencyView: View {
    let artistId: String
    @Environment(AppState.self) private var app

    private var artist: Artist { Mock.artist(artistId) }
    private var earnings: ArtistEarnings { Mock.earnings(for: artistId) }
    private var ratio: Int { max(1, Int(Double(earnings.total) / Double(max(earnings.streamingEquivalent, 1)))) }

    var body: some View {
        ZStack {
            VYBE.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 18) {
                    // Hero: total vs streaming
                    comparisonHero
                    // 90% badge
                    keepBadge
                    // Breakdown
                    breakdownSection
                    // Per-stream math
                    perStreamMath
                    // Bottom message
                    bottomMessage
                }
                .padding(20)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Earnings Transparency")
        .navigationBarTitleDisplayMode(.inline)
        .vybeDestinations()
    }

    // MARK: - Comparison Hero

    private var comparisonHero: some View {
        VStack(spacing: 16) {
            // VYBE earnings
            VStack(spacing: 4) {
                Text("VYBE Earnings")
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .tracking(1.5)
                    .foregroundStyle(VYBE.green)
                Text("$\(earnings.total.grouped)")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(VYBE.text)
                    .contentTransition(.numericText())
                Text("this month from direct fan support")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(VYBE.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(VYBE.green.opacity(0.08), in: .rect(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.green.opacity(0.3), lineWidth: 1))

            // VS
            ZStack {
                Circle().fill(VYBE.card).frame(width: 56, height: 56)
                Text("VS").font(.system(size: 16, weight: .black, design: .rounded)).foregroundStyle(VYBE.textSecondary)
            }

            // Spotify equivalent
            VStack(spacing: 4) {
                Text("Spotify Equivalent")
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .tracking(1.5)
                    .foregroundStyle(VYBE.textTertiary)
                Text("$\(earnings.streamingEquivalent.grouped)")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundStyle(VYBE.textSecondary)
                Text("what \(artist.name) would earn from \(earnings.streamCount.compact) streams @ $0.004/stream")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(VYBE.textTertiary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(.white.opacity(0.04), in: .rect(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.stroke, lineWidth: 1))

            // Multiplier callout
            Text("VYBE pays **\(ratio)x** what streaming would.")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.green)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Keep Badge

    private var keepBadge: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(VYBE.green.opacity(0.15)).frame(width: 60, height: 60)
                Circle().stroke(VYBE.green.opacity(0.4), lineWidth: 2).frame(width: 68, height: 68)
                Text("90%")
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundStyle(VYBE.green)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Artist keeps 90%")
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundStyle(VYBE.text)
                Text("Artists keep 90% of every dollar of fan support. VYBE's platform fee is 10% (plus standard card processing) — that's it. Spotify pays artists ~$0.004 per stream.")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(VYBE.textSecondary)
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .background {
            ZStack { VYBE.card; HoloArt(seed: "keep90").opacity(0.12) }
                .clipShape(.rect(cornerRadius: 20))
        }
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.green.opacity(0.35), lineWidth: 1))
    }

    // MARK: - Breakdown

    private var breakdownSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Earnings Breakdown")
            earningsRow("heart.fill", "Direct Fan Tips", earnings.directSupport, VYBE.magenta)
            earningsRow("music.note.list", "Exclusive Drops", earnings.dropSales, VYBE.cyan)
            earningsRow("tshirt.fill", "Merch Sales", earnings.merchRevenue, VYBE.blue)
            earningsRow("crown.fill", "Superfan Tier", earnings.superfanRevenue, VYBE.gold)
            earningsRow("ticket.fill", "Event Revenue", earnings.eventRevenue, VYBE.green)
            Divider().overlay(VYBE.stroke)
            earningsRow("dollarsign.circle.fill", "Total fan support", earnings.total, VYBE.text, bold: true)
            earningsRow("building.columns.fill", "VYBE platform fee (10%)", Int(Double(earnings.total) * 0.1), VYBE.textTertiary)
            earningsRow("checkmark.seal.fill", "Artist keeps", earnings.total - Int(Double(earnings.total) * 0.1), VYBE.green, bold: true)
            Text("Plus standard card-processing fees. No hidden cuts — this is the whole split.")
                .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textTertiary).lineSpacing(2).padding(.top, 2)
        }
        .padding(16)
        .vybeCard(corner: 20)
    }

    private func earningsRow(_ icon: String, _ label: String, _ value: Int, _ color: Color, bold: Bool = false) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(color).frame(width: 22)
            Text(label)
                .font(.system(size: bold ? 15 : 14, weight: bold ? .heavy : .semibold, design: bold ? .rounded : .default))
                .foregroundStyle(bold ? VYBE.text : VYBE.textSecondary)
            Spacer()
            Text("$\(value.grouped)")
                .font(.system(size: bold ? 17 : 14, weight: .black, design: .rounded))
                .foregroundStyle(bold ? color : VYBE.text)
        }
    }

    // MARK: - Per-stream math

    private var perStreamMath: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "The Math")
            HStack(spacing: 0) {
                mathColumn("Spotify", "1 stream", "$0.004", "~$4 per 1K", VYBE.textSecondary)
                Divider().frame(height: 70).overlay(VYBE.stroke)
                mathColumn("VYBE", "1 tip from a fan", "$5.00", "~$500 per 100 tips", VYBE.green)
            }
        }
        .padding(16)
        .vybeCard(corner: 20)
    }

    private func mathColumn(_ platform: String, _ unit: String, _ rate: String, _ scale: String, _ color: Color) -> some View {
        VStack(spacing: 6) {
            Text(platform)
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .tracking(1)
                .foregroundStyle(color)
            Text(unit).font(.system(size: 13, weight: .semibold)).foregroundStyle(VYBE.text)
            Text(rate).font(.system(size: 20, weight: .black, design: .rounded)).foregroundStyle(color)
            Text(scale).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Bottom message

    private var bottomMessage: some View {
        VStack(spacing: 8) {
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(VYBE.magenta)
            Text("This is why VYBE exists.")
                .font(.system(size: 16, weight: .heavy, design: .rounded))
                .foregroundStyle(VYBE.text)
            Text("Fans who support artists earn rewards, recognition, and status. Artists earn real money. The streaming model isn't the only way.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .vybeCard(corner: 20)
    }
}
