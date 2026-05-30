//
//  NotificationService.swift
//  VYBE
//
//  Local-notification stand-in for "Before They Blow" alerts and premiere
//  countdowns. Real remote push requires a backend (APNs); this prototype
//  schedules local notifications so the demo can show the surface working.
//

import Foundation
import UserNotifications

enum NotificationService {

    /// Request notification permission (no-op if already decided).
    static func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    /// Demo: a rising-artist alert a few seconds out.
    static func scheduleBeforeTheyBlowDemo() {
        requestAuthorization()
        schedule(title: "🎧 Before They Blow",
                 body: "GLITCHCORE KID is moving — shares up 240% this week. Back them early?",
                 after: 8)
    }

    /// Demo: a premiere countdown reminder a few seconds out.
    static func schedulePremiereDemo() {
        requestAuthorization()
        schedule(title: "📺 Tonight on VYBE TV",
                 body: "NOVA REIGN — Neon Bloodstream World Premiere starts soon. Join the Premiere Crew.",
                 after: 10)
    }

    private static func schedule(title: String, body: String, after seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, seconds), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
