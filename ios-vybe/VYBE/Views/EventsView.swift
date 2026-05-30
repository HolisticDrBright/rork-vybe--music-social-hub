//
//  EventsView.swift
//  VYBE
//

import SwiftUI

struct EventsView: View {
    @State private var filter = "Near Me"
    private let filters = ["Near Me", "This Week", "Festivals", "Going"]

    private var events: [Event] {
        switch filter {
        case "Festivals": return Mock.events.filter { $0.isFestival }
        case "This Week": return Mock.events.filter { $0.date.timeIntervalSinceNow < 86400 * 7 }
        default: return Mock.events.sorted { $0.distanceMiles < $1.distanceMiles }
        }
    }

    var body: some View {
        ZStack {
            VYBEBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    if let fest = Mock.events.first(where: { $0.isFestival }) {
                        NavigationLink(value: Route.event(fest.id)) { FeaturedEventCard(event: fest) }.buttonStyle(.plain)
                    }
                    ChipRow(items: filters, selection: $filter).padding(.horizontal, -20)
                    SectionHeader(title: "📍 Shows in Los Angeles")
                    VStack(spacing: 12) {
                        ForEach(events) { e in
                            NavigationLink(value: Route.event(e.id)) { EventRow(event: e) }.buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Events")
        .vybeDestinations()
    }
}

struct FeaturedEventCard: View {
    let event: Event
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            HoloArt(seed: event.title).frame(height: 220)
            LinearGradient(colors: [.clear, .black.opacity(0.85)], startPoint: .center, endPoint: .bottom).frame(height: 220)
            VStack(alignment: .leading, spacing: 8) {
                NeonTag(text: "FEATURED FESTIVAL", color: VYBE.gold, icon: "star.fill")
                Text(event.title).font(.system(size: 24, weight: .black, design: .rounded)).foregroundStyle(.white)
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                    Text("\(event.venue) · \(event.city)")
                }
                .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white.opacity(0.85))
                HStack(spacing: 12) {
                    Label("\(event.attending.compact) going", systemImage: "person.3.fill")
                    Label("\(event.friendsAttending) friends", systemImage: "heart.fill")
                }
                .font(.system(size: 12, weight: .bold)).foregroundStyle(VYBE.cyan)
            }
            .padding(16)
        }
        .clipShape(.rect(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(VYBE.gold.opacity(0.4), lineWidth: 1))
        .neonGlow(VYBE.gold, radius: 14)
    }
}

struct EventRow: View {
    let event: Event
    private var dateText: String {
        let f = DateFormatter(); f.dateFormat = "MMM d"
        return f.string(from: event.date)
    }
    var body: some View {
        HStack(spacing: 14) {
            HoloArt(seed: event.title, corner: 16).frame(width: 70, height: 70)
                .overlay {
                    VStack(spacing: 0) {
                        Text(dateText.components(separatedBy: " ").first ?? "").font(.system(size: 10, weight: .black)).foregroundStyle(.white)
                        Text(dateText.components(separatedBy: " ").last ?? "").font(.system(size: 20, weight: .black)).foregroundStyle(.white)
                    }
                }
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title).font(.system(size: 15, weight: .heavy, design: .rounded)).foregroundStyle(VYBE.text).lineLimit(1)
                Text("\(event.venue) · \(String(format: "%.1f", event.distanceMiles)) mi")
                    .font(.system(size: 12, weight: .medium)).foregroundStyle(VYBE.textSecondary)
                HStack(spacing: 8) {
                    Label("\(event.attending.compact)", systemImage: "person.2.fill")
                    if event.friendsAttending > 0 { Label("\(event.friendsAttending) friends", systemImage: "heart.fill").foregroundStyle(VYBE.magenta) }
                    Text("from $\(event.ticketPriceFrom)").foregroundStyle(VYBE.green)
                }
                .font(.system(size: 11, weight: .bold)).foregroundStyle(VYBE.textSecondary)
            }
            Spacer()
        }
        .padding(12)
        .vybeCard(corner: 18)
    }
}
