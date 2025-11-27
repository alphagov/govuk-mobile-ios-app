import Foundation
import SwiftUI
import UIComponents

class TopicListItemViewModel: ObservableObject {
    let title: String
    let iconName: String
    let tapAction: () -> Void
    let backgroundColor: Color

    convenience init(topic: Topic,
                     tapAction: @escaping () -> Void,
                     backgroundColor: Color = Color(UIColor.govUK.fills.surfaceList)) {
        self.init(title: topic.title,
                  tapAction: tapAction,
                  iconName: topic.iconName,
                  backgroundColor: backgroundColor)
    }

    init(title: String,
         tapAction: @escaping () -> Void,
         iconName: String,
         backgroundColor: Color = Color(UIColor.govUK.fills.surfaceList)) {
        self.title = title
        self.tapAction = tapAction
        self.iconName = iconName
        self.backgroundColor = backgroundColor
    }
}
