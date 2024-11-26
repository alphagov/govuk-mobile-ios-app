import Foundation
import UIKit

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

    var icon: UIImage {
        topic.icon
    }

    var isSelected: Bool {
        topic.isFavourite
    }

    func selected() {
        selectedAction(topic)
    }
}
