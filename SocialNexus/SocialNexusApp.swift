import SwiftUI

@main
struct SocialNexusApp: App {
    private let repository: SocialRepositoryProtocol = MockSocialRepository()

    var body: some Scene {
        WindowGroup {
            RootTabView(repository: repository)
        }
    }
}

struct RootTabView: View {
    let repository: SocialRepositoryProtocol

    var body: some View {
        TabView {
            UnifiedFeedView(viewModel: UnifiedFeedViewModel(repository: repository), repository: repository)
                .tabItem { Label("Feed", systemImage: "tray.full") }

            PlaceholderView(title: "Trends", icon: "chart.line.uptrend.xyaxis", description: "Engagement spikes, keywords, and sentiment.")
                .tabItem { Label("Trends", systemImage: "chart.bar") }

            PlaceholderView(title: "Search & Filters", icon: "line.3.horizontal.decrease.circle", description: "Filter by platform, account, type, and timeframe.")
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            PlaceholderView(title: "Accounts", icon: "person.crop.circle.badge.checkmark", description: "Manage connected social profiles.")
                .tabItem { Label("Accounts", systemImage: "person.2") }
        }
    }
}

private struct PlaceholderView: View {
    let title: String
    let icon: String
    let description: String

    var body: some View {
        NavigationStack {
            ContentUnavailableView(title, systemImage: icon, description: Text(description))
                .navigationTitle(title)
        }
    }
}
