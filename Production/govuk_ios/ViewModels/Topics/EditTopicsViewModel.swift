import Foundation

final class EditTopicsViewModel: ObservableObject {
    @Published var topics: [Topic]
    let topicsService: TopicsServiceInterface
    let sections: [GroupedListSection]
    var dismissAction: () -> Void

    init(topics: [Topic],
         topicsService: TopicsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.topics = topics
        self.dismissAction = dismissAction
        self.topicsService = topicsService
        var rows = [GroupedListRow]()
        topics.forEach { topic in
            rows.append(ToggleRow(id: topic.ref,
                                  title: topic.title,
                                  isOn: topic.isFavorite,
                                  action: { value in
                topic.isFavorite = value
            }))
        }

        sections = [GroupedListSection(heading: "",
                                      rows: rows,
                                      footer: nil)]
    }

    func updateFovoriteTopics() {
        topicsService.updateFavoriteTopics()
        dismissAction()
    }
}
