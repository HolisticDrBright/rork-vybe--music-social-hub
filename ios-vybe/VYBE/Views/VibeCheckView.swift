//
//  VibeCheckView.swift
//  VYBE
//
//  Emotion-based music discovery — mood wheel, energy slider,
//  MATCH & SHIFT modes, wellbeing-safe design, and social layer.
//

import SwiftUI

struct VibeCheckView: View {
    @Environment(AppState.self) private var app
    @Environment(\.dismiss) private var dismiss

    @State private var energySlider: Double = 50
    @State private var freeText: String = ""
    @State private var mode: String = "match"  // "match" or "shift"
    @State private var showShiftPicker: Bool = false
    @State private var showWellbeingNudge: Bool = false
    @State private var hasRun: Bool = false
    @State private var selectedMood: VibeMood? = nil
    @State private var shiftTarget: VibeMood? = nil

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    headerSection
                    modeToggle
                    moodWheelSection

                    if mode == "shift" && selectedMood != nil {
                        shiftTargetSection
                    }

                    energySection
                    freeTextSection

                    // Wellbeing nudge for heavy moods
                    if showWellbeingNudge, let mood = selectedMood, mood.isHeavy {
                        wellbeingNudge(mood: mood)
                    }

                    // Run button
                    if selectedMood != nil {
                        runButton
                    }

                    // Results
                    if hasRun {
                        resultsSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Vibe Check")
        .navigationBarTitleDisplayMode(.large)
        .vybeDestinations()
        .onAppear {
            energySlider = app.vibeEnergy
            freeText = app.vibeFreeText
            mode = app.vibeMode
            selectedMood = app.vibeCheckMood
            shiftTarget = app.vibeShiftTarget
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("How are you feeling?")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(VYBE.textSecondary)
            Text("Pick a vibe, set your energy, and we'll find the right music.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(VYBE.textTertiary)
        }
    }

    // MARK: - Mode Toggle

    private var modeToggle: some View {
        HStack(spacing: 0) {
            modeBtn("MATCH", "waveform.path.ecg", "match",
                    subtitle: "Songs that reflect your mood")
            modeBtn("SHIFT", "arrow.triangle.capsulepath", "shift",
                    subtitle: "Take me from one mood to another")
        }
        .background(VYBE.card, in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(VYBE.stroke, lineWidth: 1))
    }

    private func modeBtn(_ label: String, _ icon: String, _ id: String, subtitle: String) -> some View {
        let isOn = mode == id
        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                mode = id
                hasRun = false
                if id == "match" { shiftTarget = nil }
            }
            app.haptic(.light)
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                Text(label)
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                Text(subtitle)
                    .font(.system(size: 9, weight: .medium))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .foregroundStyle(isOn ? .white : VYBE.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background {
                if isOn {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(VYBE.holo)
                        .neonGlow(VYBE.purple, radius: 10)
                }
            }
            .clipShape(.rect(cornerRadius: 14))
            .padding(3)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Mood Wheel

    private var moodWheelSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: mode == "shift" ? "Starting from…" : "Pick your mood")

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Mock.vibeMoods) { mood in
                    moodCell(mood)
                }
            }

            // Social layer: "N fans feeling this"
            if let mood = selectedMood, let count = Mock.vibeSocialCounts[mood.id] {
                socialLayer(mood: mood, count: count)
            }
        }
    }

    private func moodCell(_ mood: VibeMood) -> some View {
        let isSelected = selectedMood?.id == mood.id
        let isShiftTarget = mode == "shift" && shiftTarget?.id == mood.id

        return Button {
            if mode == "shift" && selectedMood != nil {
                // In shift mode after start mood picked, tapping sets target
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    shiftTarget = mood
                    showShiftPicker = false
                }
                app.haptic(.light)
            } else {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedMood = mood
                    hasRun = false
                    showWellbeingNudge = mood.isHeavy
                    // Store in AppState
                    app.vibeCheckMood = mood
                    app.vibeShowWellbeingNudge = mood.isHeavy
                }
                app.haptic(.light)
            }
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(mood.color.opacity(isSelected || isShiftTarget ? 0.35 : 0.12))
                        .frame(width: 56, height: 56)
                        .overlay(
                            Circle()
                                .stroke(
                                    isSelected ? mood.color : (isShiftTarget ? mood.color.opacity(0.6) : Color.clear),
                                    lineWidth: 2.5
                                )
                        )
                        .neonGlow(isSelected ? mood.color : .clear, radius: isSelected ? 14 : 0)

                    Text(mood.emoji)
                        .font(.system(size: 26))
                        .scaleEffect(isSelected ? 1.2 : 1)
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)

                Text(mood.name)
                    .font(.system(size: 11, weight: isSelected ? .heavy : .medium, design: .rounded))
                    .foregroundStyle(isSelected ? mood.color : VYBE.textSecondary)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Social Layer

    private func socialLayer(mood: VibeMood, count: Int) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                // Overlapping friend avatars
                HStack(spacing: -8) {
                    ForEach(Mock.friendsVibes.prefix(4), id: \.name) { friend in
                        Circle()
                            .fill(mood.color.opacity(0.5))
                            .frame(width: 26, height: 26)
                            .overlay(
                                Text(String(friend.name.prefix(1)).uppercased())
                                    .font(.system(size: 10, weight: .heavy))
                                    .foregroundStyle(.white)
                            )
                            .overlay(Circle().stroke(VYBE.bg, lineWidth: 2))
                    }
                }

                Text("\(count.compact) fans feeling \(mood.name.lowercased()) right now")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(VYBE.textSecondary)

                Spacer()
            }

            // Friends' vibes
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(Mock.friendsVibes, id: \.name) { friend in
                        if let friendMood = Mock.vibeMoods.first(where: { $0.id == friend.moodId }) {
                            HStack(spacing: 4) {
                                Text(friendMood.emoji).font(.system(size: 11))
                                Text(friend.name)
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(VYBE.textSecondary)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(friendMood.color.opacity(0.12), in: .capsule)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(VYBE.card, in: .rect(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(VYBE.stroke, lineWidth: 1))
    }

    // MARK: - SHIFT Target Picker

    private var shiftTargetSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let from = selectedMood {
                    HStack(spacing: 6) {
                        Text(from.emoji).font(.system(size: 18))
                        Text(from.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(from.color)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(from.color.opacity(0.12), in: .capsule)
                }

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(VYBE.textTertiary)

                if let to = shiftTarget {
                    HStack(spacing: 6) {
                        Text(to.emoji).font(.system(size: 18))
                        Text(to.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(to.color)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(to.color.opacity(0.12), in: .capsule)
                } else {
                    Text("tap a mood →")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(VYBE.textTertiary)
                }

                Spacer()
            }

            if shiftTarget == nil {
                Text("Where do you want to go?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(VYBE.textSecondary)
            }
        }
    }

    // MARK: - Energy Slider

    private var energySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Energy Level")

            HStack(spacing: 8) {
                Text("😴").font(.system(size: 18))
                Slider(value: $energySlider, in: 0...100, step: 1)
                    .tint(VYBE.holo)
                    .onChange(of: energySlider) { _, newVal in
                        app.vibeEnergy = newVal
                    }
                Text("⚡").font(.system(size: 18))
            }

            HStack {
                Text("calm")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(VYBE.textTertiary)
                Spacer()
                Label {
                    Text("\(Int(energySlider))")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .foregroundStyle(VYBE.text)
                        .contentTransition(.numericText())
                } icon: {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(VYBE.gold)
                }
                Spacer()
                Text("hype")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(VYBE.textTertiary)
            }
        }
    }

    // MARK: - Free Text

    private var freeTextSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "I'm feeling…")
            HStack(spacing: 10) {
                Image(systemName: "text.bubble.fill")
                    .foregroundStyle(VYBE.textTertiary)
                TextField("", text: $freeText,
                          prompt: Text("e.g. like dancing in the rain").foregroundColor(VYBE.textTertiary))
                    .foregroundStyle(VYBE.text)
                    .autocorrectionDisabled()
                    .onChange(of: freeText) { _, val in
                        app.vibeFreeText = val
                    }
                if !freeText.isEmpty {
                    Button { freeText = ""; app.vibeFreeText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(VYBE.textTertiary)
                    }
                }
            }
            .padding(14)
            .background(VYBE.card, in: .rect(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(VYBE.stroke, lineWidth: 1))
        }
    }

    // MARK: - Wellbeing Nudge

    private func wellbeingNudge(mood: VibeMood) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(mood.color)
                Text("We noticed you're feeling \(mood.name.lowercased()).")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(VYBE.text)
                Spacer()
            }
            Text("Would you like us to gently lift you toward something brighter? We'll build a gradual journey — no sudden jumps, just a smooth transition at your pace.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)
                .lineSpacing(3)

            HStack(spacing: 10) {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        showWellbeingNudge = false
                        app.vibeShowWellbeingNudge = false
                        app.acceptWellbeingShift()
                        mode = "shift"
                        shiftTarget = app.vibeShiftTarget
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                        Text("Yes, lift me up")
                    }
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(VYBE.holo, in: .capsule)
                }
                .buttonStyle(.plain)

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showWellbeingNudge = false
                        app.vibeShowWellbeingNudge = false
                        app.declineWellbeingShift()
                        hasRun = true
                        // Sync results from AppState
                    }
                } label: {
                    Text("I just want matches")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(VYBE.textSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.white.opacity(0.06), in: .capsule)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(mood.color.opacity(0.08), in: .rect(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(mood.color.opacity(0.25), lineWidth: 1)
        )
    }

    // MARK: - Run Button

    private var runButton: some View {
        PrimaryButton(
            title: mode == "shift" && shiftTarget != nil
                ? "Begin the Journey"
                : "Find My Music",
            icon: mode == "shift" ? "arrow.triangle.capsulepath" : "waveform.path.ecg",
            gradient: mode == "shift" ? VYBE.holoSunset : VYBE.holo
        ) {
            if mode == "shift", let _ = selectedMood, let _ = shiftTarget {
                app.vibeMode = "shift"
                app.vibeCheckMood = selectedMood
                app.vibeShiftTarget = shiftTarget
                app.vibeEnergy = energySlider
                app.vibeFreeText = freeText
                showWellbeingNudge = false
                app.vibeShowWellbeingNudge = false
                app.runVibeShift()
                hasRun = true
            } else {
                app.vibeMode = "match"
                app.vibeCheckMood = selectedMood
                app.vibeEnergy = energySlider
                app.vibeFreeText = freeText
                app.runVibeMatch()
                hasRun = true
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Results Section

    @ViewBuilder
    private var resultsSection: some View {
        if mode == "shift" && !app.vibeShiftPhases.isEmpty {
            shiftJourneyResults
        } else if !app.vibeResults.isEmpty {
            matchResults
        }
    }

    // MARK: - MATCH Results

    private var matchResults: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Summary header
            if let mood = selectedMood {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Text(mood.emoji).font(.system(size: 22))
                                Text("Feeling \(mood.name)")
                                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                                    .foregroundStyle(mood.color)
                            }
                            Text("\(app.vibeResults.count) songs matched · Early Discoverer bonuses active")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(VYBE.textSecondary)
                        }
                        Spacer()
                        // Mood badge earned
                        NeonTag(text: "+25 VYBE", color: VYBE.gold, icon: "bolt.fill")
                    }

                    // "Underground Rising" results banner
                    let risingCount = app.vibeResults.filter { song in
                        Mock.artists.first { $0.id == song.artistId }?.isUndergroundRising ?? false
                    }.count
                    if risingCount > 0 {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 11, weight: .bold))
                            Text("\(risingCount) Underground Rising artists matched — support them early for bonus VYBE Score")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundStyle(VYBE.green)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(VYBE.green.opacity(0.08), in: .capsule)
                    }
                }
                .padding(16)
                .background(VYBE.card, in: .rect(cornerRadius: 18))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(mood.color.opacity(0.2), lineWidth: 1))
            }

            // AI Artist track introductions
            if let mood = selectedMood {
                aiArtistIntros(mood: mood)
            }

            // Song results list
            ForEach(app.vibeResults) { song in
                vibeResultCard(song)
            }

            // Mood-based community rooms
            if let mood = selectedMood {
                moodCommunities(mood: mood)
            }

            // Shareable Mood Journey receipt
            if let mood = selectedMood {
                shareMoodCard(mood: mood)
            }
        }
    }

    private func vibeResultCard(_ song: Song) -> some View {
        let artist = Mock.artists.first { $0.id == song.artistId }
        let earnings = artist.map { Mock.earnings(for: $0.id) }
        let isRising = artist?.isUndergroundRising ?? false

        return VStack(spacing: 0) {
            NavigationLink(value: Route.song(song.id)) {
                HStack(spacing: 12) {
                    HoloArt(seed: song.title, corner: 12)
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: "play.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(.white)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 5) {
                            Text(song.title)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(VYBE.text)
                                .lineLimit(1)
                            if isRising {
                                NeonTag(text: "RISING", color: VYBE.green, icon: "arrow.up.right")
                            }
                        }
                        Text("\(song.artistName) · \(song.genre)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(VYBE.textSecondary)
                            .lineLimit(1)

                        // Earnings signal
                        if let e = earnings {
                            HStack(spacing: 4) {
                                Image(systemName: "dollarsign.circle.fill")
                                    .font(.system(size: 9))
                                Text("Fan-funded: $\(e.total.compact)/mo")
                                    .font(.system(size: 10, weight: .semibold))
                            }
                            .foregroundStyle(VYBE.green)
                        }

                        // Mood + energy tags
                        HStack(spacing: 6) {
                            HStack(spacing: 3) {
                                Text("💡").font(.system(size: 9))
                                Text(song.mood).font(.system(size: 10, weight: .semibold))
                            }
                            .foregroundStyle(VYBE.textTertiary)
                            HStack(spacing: 3) {
                                Text("⚡").font(.system(size: 9))
                                Text("\(song.energy)").font(.system(size: 10, weight: .semibold))
                            }
                            .foregroundStyle(VYBE.textTertiary)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(VYBE.textTertiary)
                        .font(.system(size: 12))
                }
                .padding(12)
            }
            .buttonStyle(.plain)

            // Support actions
            HStack(spacing: 0) {
                supportBtn("play.fill", "Preview +20", VYBE.green) {
                    app.addScore(20, reason: "Previewed \(song.title)")
                    app.haptic(.light)
                }
                supportBtn("square.and.arrow.up.fill", "Share +250", VYBE.magenta) {
                    app.share(song.title)
                }
                supportBtn("heart.fill", "Support \(isRising ? "+200" : "+75")", VYBE.gold) {
                    app.supportFromVibeCheck(song)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(VYBE.card, in: .rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.stroke, lineWidth: 1))
    }

    private func supportBtn(_ icon: String, _ label: String, _ color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: icon).font(.system(size: 14)).foregroundStyle(color)
                Text(label).font(.system(size: 8, weight: .semibold, design: .rounded)).foregroundStyle(color.opacity(0.9))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }

    // MARK: - SHIFT Journey Results

    private var shiftJourneyResults: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Journey summary
            if let from = selectedMood, let to = shiftTarget {
                journeyHeader(from: from, to: to)
            }

            // Journey arc visualization
            journeyArc

            // AI artist intros for shift journey
            if let from = selectedMood, let to = shiftTarget {
                shiftAIArtistIntros(from: from, to: to)
            }

            // Phase-by-phase results
            ForEach(Array(app.vibeShiftPhases.enumerated()), id: \.element.id) { idx, phase in
                shiftPhaseView(phase: phase, phaseNum: idx + 1)
            }

            // Mood-based community rooms for shift
            if let to = shiftTarget {
                moodCommunities(mood: to)
            }

            // Shareable receipt
            if let from = selectedMood, let to = shiftTarget {
                shareShiftCard(from: from, to: to)
            }
        }
    }

    private func journeyHeader(from: VibeMood, to: VibeMood) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Text(from.emoji).font(.system(size: 24))
                Text(from.name)
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundStyle(from.color)

                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(VYBE.textTertiary)

                Text(to.emoji).font(.system(size: 24))
                Text(to.name)
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundStyle(to.color)
            }

            Text("\(app.vibeShiftPhases.count)-phase journey · +50 VYBE earned")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(VYBE.textSecondary)

            // Rising count
            let allSongs = app.vibeShiftPhases.flatMap { $0.songs }
            let risingCount = Set(allSongs.compactMap { song in
                Mock.artists.first { $0.id == song.artistId }?.isUndergroundRising == true ? song.artistId : nil
            }).count
            if risingCount > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "sparkle.magnifyingglass").font(.system(size: 10))
                    Text("\(risingCount) rising artists in your journey").font(.system(size: 11, weight: .semibold))
                }
                .foregroundStyle(VYBE.green)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(VYBE.card, in: .rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.stroke, lineWidth: 1))
    }

    // MARK: - Journey Arc

    private var journeyArc: some View {
        VStack(spacing: 8) {
            // Visual arc using phase labels
            GeometryReader { geo in
                ZStack {
                    // Arc path
                    Path { path in
                        let w = geo.size.width
                        let h: CGFloat = 80
                        path.move(to: CGPoint(x: 0, y: h))
                        path.addCurve(
                            to: CGPoint(x: w, y: h),
                            control1: CGPoint(x: w * 0.25, y: -10),
                            control2: CGPoint(x: w * 0.75, y: -10)
                        )
                    }
                    .stroke(
                        LinearGradient(
                            colors: [selectedMood?.color ?? VYBE.purple,
                                     shiftTarget?.color ?? VYBE.magenta],
                            startPoint: .leading, endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [6, 4])
                    )
                    .opacity(0.4)

                    // Phase dots along the arc
                    ForEach(Array(app.vibeShiftPhases.enumerated()), id: \.element.id) { idx, phase in
                        let fraction = app.vibeShiftPhases.count > 1
                            ? CGFloat(idx) / CGFloat(app.vibeShiftPhases.count - 1)
                            : 0.5
                        let x = geo.size.width * fraction
                        let y: CGFloat = 80 - 50 * sin(fraction * .pi)

                        VStack(spacing: 4) {
                            Circle()
                                .fill(VYBE.holo)
                                .frame(width: 16, height: 16)
                                .neonGlow(VYBE.purple, radius: 8)
                                .overlay(
                                    Text("\(idx + 1)")
                                        .font(.system(size: 9, weight: .heavy))
                                        .foregroundStyle(.white)
                                )
                            Text(phase.label)
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundStyle(VYBE.textSecondary)
                        }
                        .position(x: x, y: y)
                    }
                }
            }
            .frame(height: 110)
        }
    }

    private func shiftPhaseView(phase: MoodJourneyPhase, phaseNum: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Phase header
            HStack {
                ZStack {
                    Circle()
                        .fill(VYBE.holo.opacity(0.3))
                        .frame(width: 32, height: 32)
                    Text("\(phaseNum)")
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(phase.label)
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundStyle(VYBE.text)
                    Text("\(Int(phase.blendRatio * 100))% toward your destination")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(VYBE.textSecondary)
                }
                Spacer()
            }

            // Blend progress bar
            HStack(spacing: 0) {
                if let from = selectedMood {
                    Rectangle()
                        .fill(from.color.opacity(0.4))
                        .frame(width: nil, height: 4)
                        .frame(maxWidth: .infinity)
                }
                if let to = shiftTarget {
                    Rectangle()
                        .fill(to.color.opacity(0.4))
                        .frame(width: nil, height: 4)
                        .frame(maxWidth: .infinity)
                }
            }
            .clipShape(.capsule)
            .overlay(
                Capsule().stroke(VYBE.stroke, lineWidth: 1)
            )

            // Songs in this phase
            ForEach(phase.songs) { song in
                vibeResultCard(song)
            }
        }
        .padding(16)
        .background(VYBE.card, in: .rect(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(VYBE.stroke, lineWidth: 1))
    }

    // MARK: - Shareable Cards

    // MARK: - AI Artist Track Introductions (MATCH)

    /// Artists with aiEnabled in the match results get an AI intro card.
    private func aiArtistIntros(mood: VibeMood) -> some View {
        let aiArtists = app.vibeResults
            .compactMap { song in Mock.artists.first { $0.id == song.artistId } }
            .filter { $0.aiEnabled }
            .uniqued()

        guard !aiArtists.isEmpty else {
            return AnyView(EmptyView())
        }

        return AnyView(
            VStack(alignment: .leading, spacing: 12) {
                ForEach(aiArtists.prefix(2)) { artist in
                    if let song = app.vibeResults.first(where: { $0.artistId == artist.id }) {
                        aiIntroCard(artist: artist, song: song, mood: mood)
                    }
                }
            }
        )
    }

    private func aiIntroCard(artist: Artist, song: Song, mood: VibeMood) -> some View {
        NavigationLink(value: Route.aiChat(artist.id)) {
            HStack(spacing: 12) {
                // AI avatar
                ZStack {
                    Circle()
                        .fill(VYBE.cyan.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: "cpu.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(VYBE.cyan)
                }
                .overlay(Circle().stroke(VYBE.cyan.opacity(0.35), lineWidth: 1.5))

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 5) {
                        NeonTag(text: "AI", color: VYBE.cyan, icon: "cpu.fill")
                        Text("Official AI \(artist.name)")
                            .font(.system(size: 13, weight: .heavy, design: .rounded))
                            .foregroundStyle(VYBE.cyan)
                    }
                    Text("Hey — I noticed you're feeling \(mood.name.lowercased()). '\(song.title)' is one of my favorites for this vibe. Tap to ask me about the story behind it, the lyrics, or what inspired it. 💜")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(VYBE.textSecondary)
                        .lineSpacing(2)
                        .lineLimit(4)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(VYBE.cyan.opacity(0.6))
                    .font(.system(size: 12))
            }
            .padding(14)
            .background(VYBE.cyan.opacity(0.06), in: .rect(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.cyan.opacity(0.2), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    // MARK: - AI Artist Intros (SHIFT)

    private func shiftAIArtistIntros(from: VibeMood, to: VibeMood) -> some View {
        let allSongs = app.vibeShiftPhases.flatMap { $0.songs }
        let aiArtists = allSongs
            .compactMap { song in Mock.artists.first { $0.id == song.artistId } }
            .filter { $0.aiEnabled }
            .uniqued()

        guard !aiArtists.isEmpty else {
            return AnyView(EmptyView())
        }

        return AnyView(
            VStack(alignment: .leading, spacing: 12) {
                ForEach(aiArtists.prefix(2)) { artist in
                    if let song = allSongs.first(where: { $0.artistId == artist.id }) {
                        NavigationLink(value: Route.aiChat(artist.id)) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(VYBE.cyan.opacity(0.2))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "cpu.fill")
                                        .font(.system(size: 18))
                                        .foregroundStyle(VYBE.cyan)
                                }
                                .overlay(Circle().stroke(VYBE.cyan.opacity(0.35), lineWidth: 1.5))

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 5) {
                                        NeonTag(text: "AI", color: VYBE.cyan, icon: "cpu.fill")
                                        Text("Official AI \(artist.name)")
                                            .font(.system(size: 13, weight: .heavy, design: .rounded))
                                            .foregroundStyle(VYBE.cyan)
                                    }
                                    Text("I love that you're on a journey from \(from.name.lowercased()) → \(to.name.lowercased()). '\(song.title)' sits perfectly on this arc. Tap to chat about what this song means to me. 🎵")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(VYBE.textSecondary)
                                        .lineSpacing(2)
                                        .lineLimit(4)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundStyle(VYBE.cyan.opacity(0.6))
                                    .font(.system(size: 12))
                            }
                            .padding(14)
                            .background(VYBE.cyan.opacity(0.06), in: .rect(cornerRadius: 18))
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.cyan.opacity(0.2), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        )
    }

    // MARK: - Mood-Based Community Rooms

    /// Surfaces communities relevant to the chosen mood.
    private func moodCommunities(mood: VibeMood) -> some View {
        let relevant = Mock.communitiesForMood(mood.id)
        guard !relevant.isEmpty else { return AnyView(EmptyView()) }

        return AnyView(
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "🏠 Mood Rooms")
                Text("Fans feeling \(mood.name.lowercased()) are vibing in these communities")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(VYBE.textSecondary)

                ForEach(relevant.prefix(3)) { community in
                    NavigationLink(value: Route.communityBoard(community.id)) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(mood.color.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(mood.color)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(community.name)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(VYBE.text)
                                Text("\(community.activeNow.compact) active now · \(community.trendingTopic)")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(VYBE.textSecondary)
                                    .lineLimit(1)
                            }

                            Spacer()

                            HStack(spacing: 2) {
                                Circle().fill(VYBE.green).frame(width: 7, height: 7)
                                Text("\(community.activeNow.compact)")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(VYBE.green)
                            }
                        }
                        .padding(12)
                        .background(VYBE.card, in: .rect(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(mood.color.opacity(0.15), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
        )
    }

    private func shareMoodCard(mood: VibeMood) -> some View {
        Button {
            let receipt = SupportReceipt(
                id: UUID().uuidString,
                artistName: "VYBE",
                artistHandle: "@vybe",
                amountDriven: 25,
                action: "Mood Journey: feeling \(mood.name)",
                vybeScoreEarned: 25,
                rankUpdated: "Mood explorer",
                streamingComparison: "Shared your vibe with the world",
                timestamp: Date(),
                receiptSeed: "mood-\(mood.id)"
            )
            app.receiptHistory.append(receipt)
            app.addScore(10, reason: "Shared mood: \(mood.name)")
            app.hapticSuccess()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(mood.color.opacity(0.2))
                        .frame(width: 48, height: 48)
                    Text(mood.emoji).font(.system(size: 24))
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Share your Mood Journey")
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .foregroundStyle(VYBE.text)
                    Text("I'm feeling \(mood.name) on VYBE — come vibe with me")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(VYBE.textSecondary)
                        .lineLimit(2)
                }
                Spacer()
                Image(systemName: "square.and.arrow.up.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(mood.color)
            }
            .padding(14)
            .background(VYBE.card, in: .rect(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(mood.color.opacity(0.25), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func shareShiftCard(from: VibeMood, to: VibeMood) -> some View {
        Button {
            let receipt = SupportReceipt(
                id: UUID().uuidString,
                artistName: "VYBE",
                artistHandle: "@vybe",
                amountDriven: 50,
                action: "SHIFT Journey: \(from.name) → \(to.name)",
                vybeScoreEarned: 50,
                rankUpdated: "Mood traveler",
                streamingComparison: "Shared your transformation with the world",
                timestamp: Date(),
                receiptSeed: "shift-\(from.id)-\(to.id)"
            )
            app.receiptHistory.append(receipt)
            app.addScore(15, reason: "Shared SHIFT journey: \(from.name) → \(to.name)")
            app.hapticSuccess()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(VYBE.holo.opacity(0.2))
                        .frame(width: 48, height: 48)
                    HStack(spacing: -2) {
                        Text(from.emoji).font(.system(size: 16))
                        Text(to.emoji).font(.system(size: 16))
                    }
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Share Your SHIFT Journey")
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .foregroundStyle(VYBE.text)
                    Text("Went from \(from.name) → \(to.name) on VYBE")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(VYBE.textSecondary)
                }
                Spacer()
                Image(systemName: "square.and.arrow.up.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(VYBE.purple)
            }
            .padding(14)
            .background(VYBE.card, in: .rect(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(VYBE.stroke, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

/// Remove duplicate elements from a sequence of Identifiable items.
extension Sequence where Element: Identifiable {
    func uniqued() -> [Element] {
        var seen = Set<Element.ID>()
        return filter { seen.insert($0.id).inserted }
    }
}

#Preview {
    NavigationStack {
        VibeCheckView()
            .environment(AppState())
            .preferredColorScheme(.dark)
    }
}
