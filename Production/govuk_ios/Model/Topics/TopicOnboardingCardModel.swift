import Foundation

class TopicOnboardingCardModel {
    let title: String
    let description: String?
    let iconName: String
    let tapAction: (Bool) -> Void
    var isSelected: Bool = false

    init(topic: Topic,
         tapAction: @escaping (Bool) -> Void) {
        self.title = topic.title
        self.description = topic.topicDescription
        self.iconName = topic.iconName
        self.tapAction = tapAction
    }
}
