import SwiftUI

struct PostDetailView: View {
    @ObservedObject var viewModel: PostDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(viewModel.account.platform.displayName)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.thinMaterial, in: Capsule())
                        Spacer()
                        Link(destination: viewModel.post.sourceURL) {
                            Label("Open on Platform", systemImage: "arrow.up.right.square")
                        }
                    }

                    Text(viewModel.post.title)
                        .font(.title3.weight(.semibold))
                    Text(viewModel.post.preview)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 16) {
                    metric("Comments", value: viewModel.latestMetrics.comments)
                    metric("Replies", value: viewModel.latestMetrics.replies)
                    metric("Shares", value: viewModel.latestMetrics.shares)
                    metric("Mentions", value: viewModel.latestMetrics.mentions)
                }

                Divider()

                Text("Comment Thread")
                    .font(.headline)

                ForEach(viewModel.comments) { comment in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(comment.authorName)
                            .font(.subheadline.weight(.semibold))
                        Text(comment.body)
                            .font(.body)
                        Text(comment.createdAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .navigationTitle("Post Detail")
    }

    private func metric(_ title: String, value: Int) -> some View {
        VStack(alignment: .leading) {
            Text("\(value)")
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
