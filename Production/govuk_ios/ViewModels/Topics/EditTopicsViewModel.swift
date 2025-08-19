import Foundation
import CoreData
import GOVKit

final class EditTopicsViewModel: ObservableObject {
    @Published private(set) var sections: [GroupedListSection] = []
    private var managedObjectContext: NSManagedObjectContext?
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface) {
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
            topic.isFavourite = topicsService.hasCustomisedTopics ? topic.isFavourite : true
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
            isOn: topic.isFavourite,
            action: { [weak self] value in
                topic.isFavourite = value
                self?.topicsService.save()
                self?.topicsService.setHasCustomisedTopics()
                self?.trackSelection(topic: topic)
            }
        )
    }

    private func trackSelection(topic: Topic) {
        let event = AppEvent.toggleTopic(
            title: topic.title,
            isFavourite: topic.isFavourite
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
