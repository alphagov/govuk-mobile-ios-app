import Foundation

class TopicCardModel: ObservableObject {
    let title: String
    let iconName: String

    init(topic: Topic) {
        self.title = topic.title
        self.iconName = topic.iconName
    }
}
