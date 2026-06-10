//
//  EarningsTransparencyView.swift
//  VYBE
//
//  Why supporting an artist here matters — qualitative. We tell fans that
//  artists earn far more from direct support than from streaming — without
//  putting a dollar figure or a revenue-split percentage on anything.
//

import SwiftUI

struct EarningsTransparencyView: View {
    let artistId: String
    @Environment(AppState.self) private var app

    private var artist: Artist { Mock.artist(artistId) }

    var body: some View {
        ZStack {
            VYBE.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 18) {
                    heroCard
                    keepBadge
                    channelsCard
                    whyDifferent
                    bottomMessage
                }
                .padding(20)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("How Support Works")
        .navigationBarTitleDisplayMode(.inline)
        .vybeDestinations()
    }

    // MARK: - Hero

    private var heroCard: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle().fill(VYBE.green.opacity(0.15)).frame(width: 64, height: 64)
                Image(systemName: "bolt.heart.fill").font(.system(size: 28)).foregroundStyle(VYBE.green)
            }
            Text("Support that actually reaches \(artist.name)")
                .font(.system(size: 19, weight: .black, design: .rounded))
                .foregroundStyle(VYBE.text)
                .multilineTextAlignment(.center)
            Text("On VYBE, fans support artists directly — and artists earn far more here than from a fraction of a cent per stream. When you show up early, it actually moves the needle.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background {
            ZStack { VYBE.card; HoloArt(seed: "supporthero").opacity(0.12) }
                .clipShape(.rect(cornerRadius: 22))
        }
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(VYBE.green.opacity(0.3), lineWidth: 1))
    }

    // MARK: - Artist-first badge

    private var keepBadge: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(VYBE.green.opacity(0.15)).frame(width: 60, height: 60)
                Circle().stroke(VYBE.green.opacity(0.4), lineWidth: 2).frame(width: 68, height: 68)
                Image(systemName: "bolt.heart.fill")
                    .font(.system(size: 24, weight: .black))
                    .foregroundStyle(VYBE.green)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Artist-first economics")
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundStyle(VYBE.text)
                Text("Your support goes to the artist — not a label machine, not an algorithm. No hidden cuts.")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(VYBE.textSecondary)
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .background {
            ZStack { VYBE.card; HoloArt(seed: "artistfirst").opacity(0.12) }
                .clipShape(.rect(cornerRadius: 20))
        }
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.green.opacity(0.35), lineWidth: 1))
    }

    // MARK: - Support channels (no amounts)

    private var channelsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Ways to support")
            channelRow("heart.fill", "Direct tips", "Send support straight to the artist", VYBE.magenta)
            channelRow("music.note.list", "Exclusive drops", "Unlock limited tracks, sleeves & demos", VYBE.cyan)
            channelRow("tshirt.fill", "Merch", "Buy from the artist's store", VYBE.blue)
            channelRow("crown.fill", "Superfan tier", "Ongoing support for your favorites", VYBE.gold)
            channelRow("ticket.fill", "Shows & events", "Tickets, RSVPs, and meetups", VYBE.green)
        }
        .padding(16)
        .vybeCard(corner: 20)
    }

    private func channelRow(_ icon: String, _ title: String, _ subtitle: String, _ color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(color).frame(width: 24)
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                Text(subtitle).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
        }
    }

    // MARK: - Why it's different

    private var whyDifferent: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Why it's different")
            HStack(spacing: 0) {
                whyColumn("Streaming", "music.note", "Passive plays for a fraction of a cent", VYBE.textSecondary)
                Divider().frame(height: 80).overlay(VYBE.stroke)
                whyColumn("VYBE", "bolt.heart.fill", "Real, direct support from fans who show up", VYBE.green)
            }
        }
        .padding(16)
        .vybeCard(corner: 20)
    }

    private func whyColumn(_ platform: String, _ icon: String, _ desc: String, _ color: Color) -> some View {
        VStack(spacing: 8) {
            Text(platform).font(.system(size: 11, weight: .heavy, design: .rounded)).tracking(1).foregroundStyle(color)
            Image(systemName: icon).font(.system(size: 22)).foregroundStyle(color)
            Text(desc).font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.horizontal, 8)
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
            Text("Fans who support artists early earn rewards, recognition, and status. Artists earn far more — directly from the people who care. The streaming model isn't the only way.")
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
