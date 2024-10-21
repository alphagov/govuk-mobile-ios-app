import Foundation

class TopicCardModel: ObservableObject {
    let title: String
    let description: String
    let iconName: String
    let tapAction: () -> Void
    var isSelected: Bool = false

    init(topic: Topic,
         tapAction: @escaping () -> Void) {
        self.title = topic.title
        self.description = "Starting a buisness, becoming self employed, running a buinsess"
        self.iconName = topic.iconName
        self.tapAction = tapAction
    }
}
