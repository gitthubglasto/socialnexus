import Foundation

struct MockDataStore {
    let accounts: [Account]
    let posts: [Post]
    let comments: [Comment]
    let feedEvents: [FeedEvent]

    init() {
        let account1 = Account(id: UUID(), platform: .youtube, name: "Acme Media", handle: "@acmemedia")
        let account2 = Account(id: UUID(), platform: .instagram, name: "Acme Style", handle: "@acmestyle")

        let post1 = Post(
            id: UUID(),
            platformPostID: "yt_1001",
            accountID: account1.id,
            title: "Spring Product Launch Highlights",
            preview: "Top moments from our new launch event.",
            thumbnailURL: nil,
            publishedAt: .now.addingTimeInterval(-86_400),
            sourceURL: URL(string: "https://youtube.com/watch?v=launch")!
        )

        let post2 = Post(
            id: UUID(),
            platformPostID: "ig_7788",
            accountID: account2.id,
            title: "Behind the Scenes Reel",
            preview: "How our team prepared this week's campaign.",
            thumbnailURL: nil,
            publishedAt: .now.addingTimeInterval(-43_200),
            sourceURL: URL(string: "https://instagram.com/p/demo")!
        )

        let comment1 = Comment(
            id: UUID(),
            platformCommentID: "c1",
            postID: post1.id,
            parentCommentID: nil,
            authorName: "Maya R.",
            body: "Loved the segment on sustainability. Do you have specs posted?",
            createdAt: .now.addingTimeInterval(-3_000),
            sentimentScore: 0.72
        )

        let comment2 = Comment(
            id: UUID(),
            platformCommentID: "c2",
            postID: post2.id,
            parentCommentID: nil,
            authorName: "Leo T.",
            body: "Can you restock the black version in medium?",
            createdAt: .now.addingTimeInterval(-1_200),
            sentimentScore: 0.21
        )

        let event1 = FeedEvent(
            id: UUID(),
            platform: .youtube,
            accountID: account1.id,
            postID: post1.id,
            commentID: comment1.id,
            eventType: .newComment,
            timestamp: .now.addingTimeInterval(-3_000),
            contentPreview: comment1.body,
            engagementMetrics: EngagementMetrics(comments: 42, replies: 10, shares: 8, mentions: 2),
            workflowTag: .needsReply
        )

        let event2 = FeedEvent(
            id: UUID(),
            platform: .instagram,
            accountID: account2.id,
            postID: post2.id,
            commentID: comment2.id,
            eventType: .keywordAlert,
            timestamp: .now.addingTimeInterval(-1_200),
            contentPreview: comment2.body,
            engagementMetrics: EngagementMetrics(comments: 19, replies: 5, shares: 12, mentions: 4),
            workflowTag: .escalate
        )

        accounts = [account1, account2]
        posts = [post1, post2]
        comments = [comment1, comment2]
        feedEvents = [event1, event2]
    }
}
