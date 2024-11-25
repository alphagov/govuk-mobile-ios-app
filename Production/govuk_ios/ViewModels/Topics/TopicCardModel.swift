import Foundation
import UIKit

class TopicCardModel: ObservableObject {
    let title: String
    let iconName: String
    let icon: UIImage
    let tapAction: () -> Void

    init(topic: Topic,
         tapAction: @escaping () -> Void) {
        self.title = topic.title
        self.iconName = topic.iconName
        self.tapAction = tapAction
        self.icon = topic.icon
    }
}
