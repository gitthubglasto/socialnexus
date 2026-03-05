import Foundation

enum Platform: String, Codable, CaseIterable, Identifiable {
    case facebook, instagram, youtube, tiktok, rumble, odysee
    case x, linkedin, reddit, threads, pinterest, googleBusinessProfile

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .facebook: return "Facebook"
        case .instagram: return "Instagram"
        case .youtube: return "YouTube"
        case .tiktok: return "TikTok"
        case .rumble: return "Rumble"
        case .odysee: return "Odysee"
        case .x: return "X"
        case .linkedin: return "LinkedIn"
        case .reddit: return "Reddit"
        case .threads: return "Threads"
        case .pinterest: return "Pinterest"
        case .googleBusinessProfile: return "Google Business"
        }
    }
}

enum EventType: String, Codable, CaseIterable, Identifiable {
    case newComment = "NEW_COMMENT"
    case commentReply = "COMMENT_REPLY"
    case mention = "MENTION"
    case share = "SHARE"
    case quotePost = "QUOTE_POST"
    case review = "REVIEW"
    case keywordAlert = "KEYWORD_ALERT"
    case engagementSpike = "ENGAGEMENT_SPIKE"

    var id: String { rawValue }
}

enum WorkflowTag: String, Codable, CaseIterable, Identifiable {
    case needsReply = "Needs Reply"
    case escalate = "Escalate"
    case ignore = "Ignore"

    var id: String { rawValue }
}

struct EngagementMetrics: Codable, Hashable {
    var comments: Int
    var replies: Int
    var shares: Int
    var mentions: Int
}

struct Account: Identifiable, Codable, Hashable {
    var id: UUID
    var platform: Platform
    var name: String
    var handle: String
}

struct Post: Identifiable, Codable, Hashable {
    var id: UUID
    var platformPostID: String
    var accountID: UUID
    var title: String
    var preview: String
    var thumbnailURL: URL?
    var publishedAt: Date
    var sourceURL: URL
}

struct Comment: Identifiable, Codable, Hashable {
    var id: UUID
    var platformCommentID: String
    var postID: UUID
    var parentCommentID: UUID?
    var authorName: String
    var body: String
    var createdAt: Date
    var sentimentScore: Double?
}

struct FeedEvent: Identifiable, Codable, Hashable {
    var id: UUID
    var platform: Platform
    var accountID: UUID
    var postID: UUID
    var commentID: UUID?
    var eventType: EventType
    var timestamp: Date
    var contentPreview: String
    var engagementMetrics: EngagementMetrics
    var workflowTag: WorkflowTag?
}
