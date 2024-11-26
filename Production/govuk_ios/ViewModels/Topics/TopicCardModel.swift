import Foundation
import UIKit

class TopicCardModel: ObservableObject {
    let title: String
    let icon: UIImage
    let tapAction: () -> Void

    init(topic: Topic,
         tapAction: @escaping () -> Void) {
        self.title = topic.title
        self.tapAction = tapAction
        self.icon = topic.icon
    }
}
