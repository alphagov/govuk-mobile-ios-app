import Foundation
import CoreData
import GOVKit
import SwiftUI

final class EditTopicsViewModel {
    @Published private(set) var topicSelectionCards: [TopicSelectionCardViewModel] = []
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface) {
        self.topicsService = topicsService
        self.analyticsService = analyticsService
        let topics = topicsService.fetchAll()
        loadTopicCards(
            topics: topics
        )
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func loadTopicCards(topics: [Topic]) {
        topicSelectionCards = topics.map { topic in
            topicSelectionCard(topic: topic)
        }
    }

    private func topicSelectionCard(topic: Topic) -> TopicSelectionCardViewModel {
        TopicSelectionCardViewModel(
            topic: topic,
            tapAction: { [weak self] value in
                topic.isFavourite = value
                self?.topicsService.save()
                self?.trackSelection(topic: topic)
            }
        )
    }

    private func trackSelection(topic: Topic) {
        let event = AppEvent.topicSelection(
            title: topic.title,
            isFavourite: topic.isFavourite
        )
        analyticsService.track(event: event)
    }
}
