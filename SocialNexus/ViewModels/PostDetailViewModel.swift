import Foundation

final class PostDetailViewModel: ObservableObject {
    let post: Post
    let account: Account

    @Published var comments: [Comment]
    @Published var events: [FeedEvent]

    init(post: Post, account: Account, comments: [Comment], events: [FeedEvent]) {
        self.post = post
        self.account = account
        self.comments = comments.sorted { $0.createdAt < $1.createdAt }
        self.events = events.sorted { $0.timestamp > $1.timestamp }
    }

    var latestMetrics: EngagementMetrics {
        events.first?.engagementMetrics ?? EngagementMetrics(comments: comments.count, replies: 0, shares: 0, mentions: 0)
    }
}
