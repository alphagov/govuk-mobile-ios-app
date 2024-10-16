import Foundation

final class EditTopicsViewModel: ObservableObject {
    @Published var topics: [Topic]
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    let sections: [GroupedListSection]
    let dismissAction: () -> Void

    init(topics: [Topic],
         topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.topics = topics
        self.dismissAction = dismissAction
        self.topicsService = topicsService
        self.analyticsService = analyticsService

        var rows = [GroupedListRow]()
        topics.forEach { topic in
            let row = ToggleRow(
                id: topic.ref,
                title: topic.title,
                isOn: topic.isFavorite,
                action: { value in
                    topic.isFavorite = value
                    let event = AppEvent.toggleTopic(
                        title: topic.title,
                        isFavorite: topic.isFavorite
                    )
                    analyticsService.track(event: event)
                    topicsService.updateFavoriteTopics()
                }
            )
            rows.append(row)
        }

        sections = [
            GroupedListSection(
                heading: "",
                rows: rows,
                footer: nil
            )
        ]
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }
}
