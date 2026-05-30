//
//  AIArtistChatView.swift
//  VYBE
//
//  Official, artist-approved AI twin chat. Clearly labeled as AI throughout.
//

import SwiftUI

struct AIArtistChatView: View {
    let artistId: String
    @State private var messages: [ChatMessage] = []
    @State private var draft = ""
    @State private var typing = false

    private var artist: Artist { Mock.artist(artistId) }

    var body: some View {
        ZStack {
            VYBEBackground()
            VStack(spacing: 0) {
                disclaimerBar
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 14) {
                            introCard
                            ForEach(messages) { msg in
                                ChatBubble(message: msg, artist: artist).id(msg.id)
                            }
                            if typing { TypingBubble(artist: artist).id("typing") }
                            if messages.isEmpty { starters }
                        }
                        .padding(20)
                    }
                    .scrollIndicators(.hidden)
                    .onChange(of: messages.count) { _, _ in
                        withAnimation { proxy.scrollTo(messages.last?.id, anchor: .bottom) }
                    }
                    .onChange(of: typing) { _, t in
                        if t { withAnimation { proxy.scrollTo("typing", anchor: .bottom) } }
                    }
                }
                inputBar
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    AvatarView(seed: artist.name, size: 30)
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 4) {
                            Text(artist.name).font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text)
                            NeonTag(text: "AI", color: VYBE.cyan, icon: "cpu.fill")
                        }
                        Text("Official AI version").font(.system(size: 10, weight: .medium)).foregroundStyle(VYBE.cyan)
                    }
                }
            }
        }
    }

    private var disclaimerBar: some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark.shield.fill").font(.system(size: 11)).foregroundStyle(VYBE.cyan)
            Text("Verified AI · approved & controlled by \(artist.name). Not a real-time human.")
                .font(.system(size: 11, weight: .medium)).foregroundStyle(VYBE.textSecondary)
            Spacer()
        }
        .padding(.horizontal, 16).padding(.vertical, 10)
        .background(VYBE.cyan.opacity(0.08))
    }

    private var introCard: some View {
        VStack(spacing: 10) {
            AvatarView(seed: artist.name, size: 70).neonGlow(VYBE.cyan, radius: 14)
            Text("AI \(artist.name)").font(.system(size: 18, weight: .black, design: .rounded)).foregroundStyle(VYBE.text)
            Text(artist.aiPersona)
                .font(.system(size: 13, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                .multilineTextAlignment(.center)
            HStack(spacing: 8) {
                Label("Text", systemImage: "text.bubble.fill").foregroundStyle(VYBE.green)
                Label("Voice soon", systemImage: "waveform").foregroundStyle(VYBE.textTertiary)
                Label("Video soon", systemImage: "video.fill").foregroundStyle(VYBE.textTertiary)
            }
            .font(.system(size: 11, weight: .bold))
            .padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
        .padding(18)
        .vybeCard(corner: 20)
    }

    private var starters: some View {
        VStack(spacing: 8) {
            ForEach(Mock.aiStarters, id: \.self) { s in
                Button { send(s) } label: {
                    HStack {
                        Image(systemName: "sparkles").font(.system(size: 12)).foregroundStyle(VYBE.cyan)
                        Text(s).font(.system(size: 14, weight: .semibold)).foregroundStyle(VYBE.text)
                        Spacer()
                        Image(systemName: "arrow.up.right").font(.system(size: 11)).foregroundStyle(VYBE.textTertiary)
                    }
                    .padding(14)
                    .background(.white.opacity(0.05), in: .rect(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(VYBE.stroke, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("", text: $draft, prompt: Text("Ask the AI artist...").foregroundColor(VYBE.textTertiary))
                .foregroundStyle(VYBE.text)
                .padding(.horizontal, 16).padding(.vertical, 12)
                .background(VYBE.card, in: .capsule)
                .overlay(Capsule().stroke(VYBE.stroke, lineWidth: 1))
                .onSubmit { send(draft) }
            Button { send(draft) } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 18, weight: .black)).foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(VYBE.holo, in: .circle)
                    .neonGlow(VYBE.purple, radius: 10)
            }
            .buttonStyle(.plain)
            .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(draft.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }

    private func send(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        messages.append(ChatMessage(fromAI: false, text: trimmed))
        draft = ""
        typing = true
        let reply = Mock.aiReply(for: artist, to: trimmed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            typing = false
            messages.append(ChatMessage(fromAI: true, text: reply))
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    let artist: Artist
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.fromAI {
                AvatarView(seed: artist.name, size: 28)
                Text(message.text)
                    .font(.system(size: 14, weight: .medium)).foregroundStyle(VYBE.text)
                    .padding(12)
                    .background(VYBE.card, in: .rect(cornerRadius: 18))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.cyan.opacity(0.3), lineWidth: 1))
                Spacer(minLength: 30)
            } else {
                Spacer(minLength: 30)
                Text(message.text)
                    .font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                    .padding(12)
                    .background(VYBE.holo, in: .rect(cornerRadius: 18))
            }
        }
    }
}

struct TypingBubble: View {
    let artist: Artist
    @State private var phase = 0
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            AvatarView(seed: artist.name, size: 28)
            HStack(spacing: 4) {
                ForEach(0..<3) { i in
                    Circle().fill(VYBE.cyan).frame(width: 7, height: 7)
                        .opacity(phase == i ? 1 : 0.3)
                }
            }
            .padding(.horizontal, 14).padding(.vertical, 14)
            .background(VYBE.card, in: .rect(cornerRadius: 18))
            Spacer()
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                phase = (phase + 1) % 3
            }
        }
    }
}
