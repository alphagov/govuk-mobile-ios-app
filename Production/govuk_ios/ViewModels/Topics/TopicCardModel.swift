import Foundation

class TopicCardModel: ObservableObject {
    let title: String
    let iconName: String
    let tapAction: () -> Void

    init(topic: Topic,
         tapAction: @escaping () -> Void) {
        self.title = topic.title
        self.iconName = topic.iconName
        self.tapAction = tapAction
    }
}
