//
//  BeforeTheyBlowView.swift
//  VYBE
//
//  Rising-artist alerts — back artists before they break.
//

import SwiftUI

struct BeforeTheyBlowView: View {
    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            NeonTag(text: "BEFORE THEY BLOW", color: VYBE.gold, icon: "waveform.path.ecg")
                            Spacer()
                        }
                        Text("Catch the next break first")
                            .font(.system(size: 21, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
                        Text("Rising underground artists showing real momentum. Back them early and earn Early Discoverer status.")
                            .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary).lineSpacing(3)
                    }
                    .padding(16)
                    .background { ZStack { VYBE.card; HoloArt(seed: "btbhero").opacity(0.12) }.clipShape(.rect(cornerRadius: 20)) }
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.gold.opacity(0.25), lineWidth: 1))

                    ForEach(Mock.beforeTheyBlow) { BeforeTheyBlowCard(alert: $0) }
                }
                .padding(.horizontal, 20).padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Before They Blow")
        .navigationBarTitleDisplayMode(.large)
        .vybeDestinations()
    }
}
