import Foundation

struct TopicOnboardingCardModel {
    private let topic: Topic
    private let selectedAction: (Topic) -> Void

    init(topic: Topic,
         selectedAction: @escaping (Topic) -> Void) {
        self.topic = topic
        self.selectedAction = selectedAction
    }

    var title: String {
        topic.title
    }

    var description: String? {
        topic.topicDescription
    }

    var iconName: String {
        topic.iconName
    }

    var isSelected: Bool {
        topic.isFavorite
    }

    func selected() {
        selectedAction(topic)
    }
}
