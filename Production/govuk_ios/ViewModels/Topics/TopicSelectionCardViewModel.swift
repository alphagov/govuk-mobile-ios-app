import Foundation
import UIKit

class TopicSelectionCardViewModel: Identifiable,
                                   ObservableObject {
    private let topic: Topic
    let tapAction: (Bool) -> Void

    public init(topic: Topic,
                tapAction: @escaping (Bool) -> Void) {
        self.topic = topic
        self.tapAction = tapAction
        isOn = topic.isFavourite
    }

    @Published var isOn: Bool {
        didSet {
            tapAction(isOn)
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

    var backgroundColor: UIColor {
        topic.isFavourite ?
        .govUK.fills.surfaceListSelected :
        .govUK.fills.surfaceListUnselected
    }

    var titleColor: UIColor {
        topic.isFavourite ?
        .govUK.text.listSelected :
        .govUK.text.listUnselected
    }

    var accessibilityHint: String {
        topic.isFavourite ?
        .topics.localized("topicSelected") :
        .topics.localized("topicUnselected")
    }
}
