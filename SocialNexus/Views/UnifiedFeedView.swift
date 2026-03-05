import SwiftUI

struct UnifiedFeedView: View {
    @StateObject var viewModel: UnifiedFeedViewModel
    let repository: SocialRepositoryProtocol

    var body: some View {
        NavigationStack {
            List(viewModel.filteredEvents) { event in
                if let post = repository.fetchPosts().first(where: { $0.id == event.postID }),
                   let account = repository.fetchAccounts().first(where: { $0.id == event.accountID }) {
                    NavigationLink {
                        PostDetailView(
                            viewModel: PostDetailViewModel(
                                post: post,
                                account: account,
                                comments: repository.fetchComments(for: post.id),
                                events: viewModel.events.filter { $0.postID == post.id }
                            )
                        )
                    } label: {
                        FeedRow(event: event, post: post, account: account)
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.query, prompt: "Search comments")
            .navigationTitle("Unified Feed")
        }
    }
}

private struct FeedRow: View {
    let event: FeedEvent
    let post: Post
    let account: Account

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            PlatformBadge(platform: event.platform)

            VStack(alignment: .leading, spacing: 4) {
                Text(post.title)
                    .font(.headline)
                    .lineLimit(1)

                Text(event.contentPreview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text(account.handle)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 4) {
                Label("\(event.engagementMetrics.comments)", systemImage: "bubble.right")
                    .font(.caption)
                Label("\(event.engagementMetrics.shares)", systemImage: "arrowshape.turn.up.right")
                    .font(.caption)
                Image(systemName: "arrow.up.right.square")
            }
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

private struct PlatformBadge: View {
    let platform: Platform

    var body: some View {
        Text(String(platform.displayName.prefix(2)).uppercased())
            .font(.caption.weight(.bold))
            .frame(width: 32, height: 32)
            .background(.blue.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))
    }
}
