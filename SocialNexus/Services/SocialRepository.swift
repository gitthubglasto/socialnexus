import Foundation

protocol SocialRepositoryProtocol {
    func fetchAccounts() -> [Account]
    func fetchPosts() -> [Post]
    func fetchComments(for postID: UUID) -> [Comment]
    func fetchFeedEvents() -> [FeedEvent]
}

struct MockSocialRepository: SocialRepositoryProtocol {
    private let store = MockDataStore()

    func fetchAccounts() -> [Account] { store.accounts }
    func fetchPosts() -> [Post] { store.posts }

    func fetchComments(for postID: UUID) -> [Comment] {
        store.comments.filter { $0.postID == postID }
    }

    func fetchFeedEvents() -> [FeedEvent] { store.feedEvents }
}
