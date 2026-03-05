import Foundation
import Combine

final class UnifiedFeedViewModel: ObservableObject {
    @Published var events: [FeedEvent] = []
    @Published var selectedPlatforms: Set<Platform> = []
    @Published var selectedEventTypes: Set<EventType> = []
    @Published var query: String = ""

    private let repository: SocialRepositoryProtocol

    init(repository: SocialRepositoryProtocol) {
        self.repository = repository
        load()
    }

    var filteredEvents: [FeedEvent] {
        events.filter { event in
            let platformPass = selectedPlatforms.isEmpty || selectedPlatforms.contains(event.platform)
            let typePass = selectedEventTypes.isEmpty || selectedEventTypes.contains(event.eventType)
            let queryPass = query.isEmpty || event.contentPreview.localizedCaseInsensitiveContains(query)
            return platformPass && typePass && queryPass
        }
        .sorted { $0.timestamp > $1.timestamp }
    }

    func load() {
        events = repository.fetchFeedEvents()
    }

    func mark(event: FeedEvent, as tag: WorkflowTag?) {
        guard let idx = events.firstIndex(where: { $0.id == event.id }) else { return }
        events[idx].workflowTag = tag
    }
}
