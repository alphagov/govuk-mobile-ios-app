import Foundation
import CoreData

final class EditTopicsViewModel: ObservableObject {
    @Published private(set) var sections: [GroupedListSection] = []
    private var managedObjectContext: NSManagedObjectContext?
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    let dismissAction: () -> Void

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
        self.topicsService = topicsService
        self.analyticsService = analyticsService
        let topics = topicsService.fetchAll()
        self.managedObjectContext = topics.first?.managedObjectContext
        loadSections(
            topics: topics
        )
    }

    func undoChanges() {
        managedObjectContext?.rollback()
    }

    private func loadSections(topics: [Topic]) {
        let rows = topics.compactMap { [weak self, topicsService] topic in
            topic.isFavorite = topicsService.hasPersonalisedTopics ? topic.isFavorite : true
            return self?.topicRow(topic: topic)
        }
        self.sections = [
            GroupedListSection(
                heading: nil,
                rows: rows,
                footer: nil
            )
        ]
    }

    private func topicRow(topic: Topic) -> ToggleRow {
        ToggleRow(
            id: topic.ref,
            title: topic.title,
            isOn: topic.isFavorite,
            action: { [weak self] value in
                topic.isFavorite = value
                self?.topicsService.save()
                self?.topicsService.setHasPersonalisedTopics()
                self?.trackSelection(topic: topic)
            }
        )
    }

    private func trackSelection(topic: Topic) {
        let event = AppEvent.toggleTopic(
            title: topic.title,
            isFavorite: topic.isFavorite
        )
        analyticsService.track(event: event)
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    deinit {
        undoChanges()
    }
}
