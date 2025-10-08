import Foundation
import CoreData
import GOVKit
import UIKit

final class EditTopicsViewModel {
    private(set) var sections: [TopicRow] = []
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
        sections = topics.compactMap { [weak self, topicsService] topic in
            topic.isFavourite = topicsService.hasCustomisedTopics ? topic.isFavourite : true
            return self?.topicRow(topic: topic)
        }
    }

    private func topicRow(topic: Topic) -> TopicRow {
        TopicRow(
            id: topic.ref,
            title: topic.title,
            icon: topic.icon,
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

class TopicRow: Identifiable,
                ObservableObject {
    let id: String
    let title: String
    let icon: UIImage
    @Published var isOn: Bool {
        didSet {
            self.action(isOn)
        }
    }
    private let action: (Bool) -> Void

    public init(id: String,
                title: String,
                icon: UIImage,
                isOn: Bool,
                action: @escaping (Bool) -> Void) {
        self.id = id
        self.title = title
        self.icon = icon
        self.isOn = isOn
        self.action = action
    }
}
