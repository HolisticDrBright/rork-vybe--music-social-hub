//
//  SettingsView.swift
//  VYBE
//
//  Settings with fan-first values, accessibility, and account management.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var app
    @State private var showGuidelines = false

    var body: some View {
        ZStack {
            VYBE.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 22) {
                    // Mode (Fan / Artist / Admin)
                    modeSection
                    // Notifications
                    notificationsSection
                    // Fan-first values
                    valuesSection
                    // Account
                    accountSection
                    // Trust & Safety
                    safetySection
                    // About
                    aboutSection
                }
                .padding(20)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showGuidelines) { GuidelinesSheet() }
    }

    // MARK: - Mode

    private var modeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Mode").padding(.horizontal, 4)
            Text("Switch between fan and artist experiences. Artist Mode unlocks the Dashboard, Collab Lab, Sleeve Builder, Drop Campaigns, and Need Board.")
                .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary).padding(.horizontal, 4)
            HStack(spacing: 8) {
                ForEach(UserRole.allCases) { r in
                    Button { app.setRole(r) } label: {
                        VStack(spacing: 6) {
                            Image(systemName: r.icon).font(.system(size: 18, weight: .bold))
                            Text(r.rawValue).font(.system(size: 13, weight: .heavy, design: .rounded))
                        }
                        .foregroundStyle(app.role == r ? .white : VYBE.textSecondary)
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background {
                            if app.role == r { RoundedRectangle(cornerRadius: 14).fill(VYBE.holo).neonGlow(VYBE.purple, radius: 8) }
                            else { RoundedRectangle(cornerRadius: 14).fill(.white.opacity(0.06)).overlay(RoundedRectangle(cornerRadius: 14).stroke(VYBE.stroke, lineWidth: 1)) }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16).vybeCard(corner: 20)
    }

    // MARK: - Notifications

    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            SectionHeader(title: "Notifications").padding(.horizontal, 4).padding(.bottom, 4)
            Toggle(isOn: Binding(get: { app.notifyBeforeTheyBlow }, set: { app.setNotify(beforeTheyBlow: $0) })) {
                notifyLabel("waveform.path.ecg", "Before They Blow alerts", "Get pinged when a rising artist starts to move", VYBE.gold)
            }.tint(VYBE.magenta)
            settingsDivider
            Toggle(isOn: Binding(get: { app.notifyPremieres }, set: { app.setNotify(premieres: $0) })) {
                notifyLabel("play.tv.fill", "Premiere reminders", "Countdown pings for VYBE TV premieres", VYBE.purple)
            }.tint(VYBE.magenta)
            Text("Prototype uses local notifications. Real push requires a backend.")
                .font(.system(size: 10, weight: .medium)).foregroundStyle(VYBE.textTertiary).padding(.top, 6).padding(.horizontal, 4)
        }
        .padding(16).vybeCard(corner: 20)
    }

    private func notifyLabel(_ icon: String, _ title: String, _ sub: String, _ color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 16)).foregroundStyle(color).frame(width: 24)
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                Text(sub).font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            }
        }
    }

    // MARK: - Fan-First Values

    private var valuesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "heart.text.square.fill")
                    .foregroundStyle(VYBE.magenta)
                Text("Our Fan-First Promise")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundStyle(VYBE.text)
                Spacer()
            }

            ForEach(Mock.fanFirstValues, id: \.title) { value in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: value.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(VYBE.green)
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(value.title)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(VYBE.text)
                        Text(value.description)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(VYBE.textSecondary)
                            .lineSpacing(2)
                    }
                }
                .padding(.vertical, 6)
            }
        }
        .padding(16)
        .vybeCard(corner: 20)
    }

    // MARK: - Account

    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "Account").padding(.horizontal, 4).padding(.bottom, 8)
            settingsRow("envelope.fill", "Email", "you@vybe.app", VYBE.blue)
            settingsDivider
            settingsRow("phone.fill", "Phone", "+1 (555) 123-4567", VYBE.green)
            settingsDivider
            settingsRow("arrow.triangle.2.circlepath", "Account Recovery", "Email + Phone enabled", VYBE.cyan)
        }
        .padding(16)
        .vybeCard(corner: 20)
    }

    // MARK: - Safety

    private var safetySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "Trust & Safety").padding(.horizontal, 4).padding(.bottom, 8)
            settingsRow("shield.lefthalf.filled", "Blocked Users", "3 users", VYBE.magenta)
            settingsDivider
            settingsRow("bell.badge.fill", "Report History", "2 reports · all reviewed", VYBE.cyan)
            settingsDivider
            Button {
                showGuidelines = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "doc.text.fill").font(.system(size: 16)).foregroundStyle(VYBE.gold).frame(width: 24)
                    Text("Community Guidelines").font(.system(size: 14, weight: .bold)).foregroundStyle(VYBE.text)
                    Spacer()
                    Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(VYBE.textTertiary)
                }
                .padding(.vertical, 12)
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .vybeCard(corner: 20)
    }

    // MARK: - About

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "About").padding(.horizontal, 4).padding(.bottom, 8)
            settingsRow("info.circle.fill", "Version", "1.0.0 (MVP)", VYBE.textSecondary)
            settingsDivider
            settingsRow("externaldrive.fill", "Data source", VYBEDataStore.shared.source, VYBE.cyan)
            settingsDivider
            settingsRow("heart.fill", "Made for music fans", "San Francisco, CA", VYBE.magenta)

            HStack(spacing: 10) {
                Image(systemName: "sparkles").foregroundStyle(VYBE.purple)
                Text("VYBE: The social network for music — where supporting your artist pays off.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(VYBE.textSecondary)
                    .lineSpacing(2)
            }
            .padding(.vertical, 12)
        }
        .padding(16)
        .vybeCard(corner: 20)
    }

    // MARK: - Helpers

    private func settingsRow(_ icon: String, _ title: String, _ value: String, _ color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
                .frame(width: 24)
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(VYBE.text)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(VYBE.textSecondary)
        }
        .padding(.vertical, 12)
    }

    private var settingsDivider: some View {
        Divider().overlay(VYBE.stroke).padding(.leading, 36)
    }
}
