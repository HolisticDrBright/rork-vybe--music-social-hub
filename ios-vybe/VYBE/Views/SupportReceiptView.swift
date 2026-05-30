//
//  SupportReceiptView.swift
//  VYBE
//
//  Shareable holographic "Support Receipt" card.
//  "I helped [Artist] earn $X — Top 50 fan in [City]"
//

import SwiftUI

struct SupportReceiptView: View {
    let receipt: SupportReceipt
    @Environment(AppState.self) private var app
    @State private var showShareSheet = false
    @State private var shimmer = false
    @State private var appeared = false

    private var artistEarnedLabel: String {
        receipt.artistEarnedUSD > 0
            ? String(format: "$%.2f", receipt.artistEarnedUSD)
            : "$\(receipt.amountDriven)"
    }

    var body: some View {
        ZStack {
            VYBE.bg.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Receipt card
                receiptCard
                    .scaleEffect(appeared ? 1 : 0.9)
                    .opacity(appeared ? 1 : 0)

                Spacer()

                // Share button
                PrimaryButton(title: "Share your Support Receipt", icon: "square.and.arrow.up.fill") {
                    showShareSheet = true
                }
                .padding(.horizontal, 24)

                Text("Share to Instagram, TikTok, or anywhere you want to show who you support.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(VYBE.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
            }
        }
        .navigationTitle("Support Receipt")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                appeared = true
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                shimmer = true
            }
        }
        .sheet(isPresented: $showShareSheet) {
            receiptShareSheet
        }
    }

    // MARK: - Receipt Card

    private var receiptCard: some View {
        VStack(spacing: 0) {
            // Header holographic strip
            ZStack {
                HoloArt(seed: receipt.receiptSeed)
                    .frame(height: 100)
                VStack(spacing: 4) {
                    Image(systemName: "waveform")
                        .font(.system(size: 28, weight: .black))
                        .foregroundStyle(.white)
                    Text("VYBE SUPPORT RECEIPT")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .tracking(3)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }

            // Body
            VStack(spacing: 16) {
                // Artist info
                HStack(spacing: 10) {
                    AvatarView(seed: receipt.artistName, size: 44)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(receipt.artistName)
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .foregroundStyle(VYBE.text)
                        Text(receipt.artistHandle)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(VYBE.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(VYBE.cyan)
                }

                Divider().overlay(VYBE.stroke)

                // Action
                VStack(spacing: 6) {
                    Text("YOU SUPPORTED")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(VYBE.textTertiary)
                    Text(receipt.action)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(VYBE.text)
                        .multilineTextAlignment(.center)
                }

                // The money moment — headline copy
                if !receipt.headline.isEmpty {
                    Text(receipt.headline)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(VYBE.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.horizontal, 4)
                }

                if let badge = receipt.badgeProgress {
                    NeonTag(text: badge, color: VYBE.gold, icon: "rosette")
                }

                // Impact metrics
                HStack(spacing: 0) {
                    receiptMetric("+\(receipt.vybeScoreEarned)", "VYBE Score earned", VYBE.gold)
                    Divider().frame(height: 44).overlay(VYBE.stroke)
                    receiptMetric(artistEarnedLabel, "Artist earned", VYBE.green)
                    Divider().frame(height: 44).overlay(VYBE.stroke)
                    receiptMetric(receipt.streamingComparison, "vs streaming", VYBE.magenta)
                }

                Divider().overlay(VYBE.stroke)

                // Rank
                HStack(spacing: 8) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundStyle(VYBE.cyan)
                    Text(receipt.rankUpdated)
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .foregroundStyle(VYBE.cyan)
                    Spacer()
                }

                // Timestamp
                Text(receipt.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(VYBE.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(18)
        }
        .background(VYBE.card)
        .clipShape(.rect(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(VYBE.stroke, lineWidth: 1))
        .neonGlow(VYBE.purple, radius: shimmer ? 18 : 10)
        .padding(.horizontal, 20)
        .shadow(color: VYBE.purple.opacity(0.4), radius: 30, y: 10)
    }

    private func receiptMetric(_ value: String, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundStyle(color)
                .lineLimit(1)
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(VYBE.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Share Sheet

    private var receiptShareSheet: some View {
        VStack(spacing: 18) {
            Capsule().fill(.white.opacity(0.2)).frame(width: 40, height: 5).padding(.top, 10)
            receiptCard.scaleEffect(0.75)
            Text("Share your impact")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(VYBE.text)
            Text("Post this to show the world who you support.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 14) {
                shareButton("Stories", "camera.fill", VYBE.magenta)
                shareButton("Reels", "video.fill", VYBE.purple)
                shareButton("TikTok", "music.note", VYBE.cyan)
                shareButton("Twitter", "bird", VYBE.blue)
                shareButton("Copy Link", "link", VYBE.blue)
                shareButton("Message", "message.fill", VYBE.green)
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(VYBE.bgElevated)
        .presentationDetents([.large])
    }

    private func shareButton(_ label: String, _ icon: String, _ color: Color) -> some View {
        Button {
            app.share(receipt.artistName)
            app.hapticSuccess()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 18, weight: .bold)).foregroundStyle(.white)
                    .frame(width: 52, height: 52).background(color.opacity(0.85), in: .circle)
                Text(label).font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.text)
            }
        }
        .buttonStyle(.plain)
    }
}
