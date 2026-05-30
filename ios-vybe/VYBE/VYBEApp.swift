//
//  VYBEApp.swift
//  VYBE
//
//  The social network for music.
//

import SwiftUI

@main
struct VYBEApp: App {
    @State private var app = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(app)
                .preferredColorScheme(.dark)
                .tint(VYBE.purple)
        }
    }
}

struct RootView: View {
    @Environment(AppState.self) private var app

    var body: some View {
        ZStack {
            if app.hasOnboarded {
                RootTabView()
                    .transition(.opacity)
            } else {
                OnboardingView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: app.hasOnboarded)
    }
}
