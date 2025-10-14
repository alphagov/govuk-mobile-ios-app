import SwiftUI

class TopicSelectionCardViewModel: Identifiable,
                                   ObservableObject {
    private let topic: Topic
    private let tapAction: (Bool) -> Void

    public init(topic: Topic,
                tapAction: @escaping (Bool) -> Void) {
        self.topic = topic
        self.tapAction = tapAction
        self.isOn = topic.isFavourite
    }

    @Published var isOn: Bool {
        didSet {
            self.tapAction(isOn)
        }
    }

    var title: String {
        topic.title
    }

    var iconName: String {
        topic.isFavourite ?
        "topic_selected" :
        topic.iconName
    }

    var backgroundColor: Color {
        topic.isFavourite ?
        Color(UIColor.govUK.fills.surfaceListSelected) :
        Color(UIColor.govUK.fills.surfaceListUnselected)
    }

    var titleColor: Color {
        topic.isFavourite ?
        Color(UIColor.govUK.text.listSelected) :
        Color(UIColor.govUK.text.listUnselected)
    }

    var id: String {
        topic.ref
    }

    var accessibilityHint: String {
        topic.isFavourite ?
        String.topics.localized("topicSelected") :
        String.topics.localized("topicUnselected")
    }
}
