import Foundation
import UIKit

class TopicCardModel: ObservableObject {
    let title: String
    let icon: UIImage
    let iconName: String?
    let tapAction: () -> Void

    init(topic: Topic,
         tapAction: @escaping () -> Void,
         iconName: String? = nil) {
        self.title = topic.title
        self.tapAction = tapAction
        self.icon = topic.icon
        self.iconName = iconName
    }

    init(title: String,
         icon: UIImage,
         tapAction: @escaping () -> Void,
         iconName: String? = nil) {
        self.title = title
        self.icon = icon
        self.tapAction = tapAction
        self.iconName = iconName
    }
}
