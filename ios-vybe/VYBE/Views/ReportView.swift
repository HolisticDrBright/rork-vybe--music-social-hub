//
//  ReportView.swift
//  VYBE
//
//  Trust & Safety report flow with categories, confirmation, and community guidelines.
//

import SwiftUI

struct ReportView: View {
    let contentId: String
    @Environment(AppState.self) private var app
    @State private var selectedCategory: ReportCategory? = nil
    @State private var details = ""
    @State private var submitted = false
    @State private var showGuidelines = false

    var body: some View {
        ZStack {
            VYBE.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    if !submitted {
                        reportForm
                    } else {
                        submittedView
                    }
                }
                .padding(20)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationTitle("Report Content")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Report Form

    private var reportForm: some View {
        VStack(alignment: .leading, spacing: 22) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: "shield.lefthalf.filled")
                        .foregroundStyle(VYBE.cyan)
                    Text("Keep VYBE safe")
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .foregroundStyle(VYBE.text)
                }
                Text("Your report is anonymous and reviewed by real humans within 24 hours. False reports may result in action on your account.")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(VYBE.textSecondary)
                    .lineSpacing(3)
            }

            // Categories
            VStack(alignment: .leading, spacing: 8) {
                Text("What's the issue?")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(VYBE.text)
                ForEach(Mock.reportCategories) { cat in
                    Button {
                        withAnimation(.snappy) { selectedCategory = cat }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: cat.icon)
                                .font(.system(size: 18))
                                .foregroundStyle(selectedCategory?.id == cat.id ? VYBE.magenta : VYBE.textSecondary)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(cat.name)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(VYBE.text)
                                Text(cat.description)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(VYBE.textSecondary)
                            }
                            Spacer()
                            Image(systemName: selectedCategory?.id == cat.id ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(selectedCategory?.id == cat.id ? VYBE.magenta : VYBE.textTertiary)
                        }
                        .padding(14)
                        .background(
                            selectedCategory?.id == cat.id ? VYBE.magenta.opacity(0.08) : VYBE.card,
                            in: .rect(cornerRadius: 16)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedCategory?.id == cat.id ? VYBE.magenta.opacity(0.4) : VYBE.stroke, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            // Details
            VStack(alignment: .leading, spacing: 8) {
                Text("Additional details (optional)")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(VYBE.text)
                TextField("", text: $details, prompt: Text("Tell us more about what happened...").foregroundColor(VYBE.textTertiary), axis: .vertical)
                    .foregroundStyle(VYBE.text)
                    .lineLimit(3...6)
                    .padding(14)
                    .background(VYBE.card, in: .rect(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(VYBE.stroke, lineWidth: 1))
            }

            // Submit
            PrimaryButton(title: "Submit Report", icon: "exclamationmark.shield.fill") {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    submitted = true
                }
                app.hapticSuccess()
            }
            .opacity(selectedCategory != nil ? 1 : 0.5)
            .disabled(selectedCategory == nil)

            // Guidelines link
            Button {
                showGuidelines = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "doc.text.fill").font(.system(size: 12)).foregroundStyle(VYBE.cyan)
                    Text("Community Guidelines").font(.system(size: 13, weight: .semibold)).foregroundStyle(VYBE.cyan)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 4)
        }
        .sheet(isPresented: $showGuidelines) {
            GuidelinesSheet()
        }
    }

    // MARK: - Submitted

    private var submittedView: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)
            ZStack {
                Circle().fill(VYBE.green.opacity(0.15)).frame(width: 100, height: 100)
                Circle().stroke(VYBE.green.opacity(0.4), lineWidth: 2).frame(width: 108, height: 108)
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(VYBE.green)
            }
            .neonGlow(VYBE.green, radius: 16)

            Text("Report Submitted")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(VYBE.text)
            Text("Thank you for helping keep VYBE a place fans actually want to be. Our team will review this within 24 hours and take appropriate action.")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 20)

            HStack(spacing: 10) {
                Image(systemName: "person.badge.shield.checkmark.fill")
                    .foregroundStyle(VYBE.cyan)
                Text("Real humans review every report.")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(VYBE.cyan)
            }
            .padding(.top, 8)

            PrimaryButton(title: "Done", icon: "checkmark") {
                // Pop back
            }
            .padding(.top, 16)
        }
    }
}

// MARK: - Guidelines Sheet

struct GuidelinesSheet: View {
    @Environment(\.dismiss) private var dismiss
    var isFirstTime = false
    var onAccept: (() -> Void)? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                VYBE.bg.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        if isFirstTime {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 10) {
                                    Image(systemName: "hand.wave.fill")
                                        .font(.system(size: 24))
                                        .foregroundStyle(VYBE.magenta)
                                    Text("Welcome to VYBE")
                                        .font(.system(size: 22, weight: .black, design: .rounded))
                                        .foregroundStyle(VYBE.text)
                                }
                                Text("Before your first post, please review our community guidelines. VYBE is a place fans actually want to be.")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(VYBE.textSecondary)
                                    .lineSpacing(3)
                            }
                            .padding(.bottom, 8)
                        }

                        Text("VYBE Community Guidelines")
                            .font(.system(size: 22, weight: .black, design: .rounded))
                            .foregroundStyle(VYBE.text)

                        guidelineCard(
                            icon: "hand.raised.fill",
                            title: "Respect Everyone",
                            body: "No harassment, hate speech, doxing, or threats. VYBE is built for music lovers — keep it that way.",
                            color: VYBE.magenta
                        )
                        guidelineCard(
                            icon: "lock.shield.fill",
                            title: "Protect Privacy",
                            body: "Never share someone's personal information without their consent. This includes phone numbers, addresses, and private messages.",
                            color: VYBE.blue
                        )
                        guidelineCard(
                            icon: "person.fill.checkmark",
                            title: "Be Yourself",
                            body: "No impersonation of artists, fans, or anyone else. Verified artist accounts are the only ones that can use an artist's name.",
                            color: VYBE.cyan
                        )
                        guidelineCard(
                            icon: "megaphone.fill",
                            title: "No Spam",
                            body: "Repetitive posts, unsolicited promotions, and bot-like behavior will be removed. Keep conversations genuine.",
                            color: VYBE.gold
                        )
                        guidelineCard(
                            icon: "text.badge.checkmark",
                            title: "Age-Appropriate Content",
                            body: "VYBE is for music culture. No explicit, violent, or adult content. Keep it about the music and community.",
                            color: VYBE.green
                        )
                        guidelineCard(
                            icon: "exclamationmark.shield.fill",
                            title: "Report, Don't Retaliate",
                            body: "If you see something wrong, report it. Don't engage or escalate. Our moderation team handles it.",
                            color: VYBE.purple
                        )
                    }
                    .padding(20)
                    .padding(.bottom, 30)

                    if isFirstTime {
                        PrimaryButton(title: "I understand — let me post", icon: "checkmark.shield.fill") {
                            onAccept?()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(VYBE.purple)
                }
            }
        }
    }

    private func guidelineCard(icon: String, title: String, body: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
                .frame(width: 30)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundStyle(VYBE.text)
                Text(body)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(VYBE.textSecondary)
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .vybeCard(corner: 16)
    }
}
