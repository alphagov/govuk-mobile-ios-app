import Foundation
import UIKit

public struct GroupedListHeader {
    public let title: String
    let icon: UIImage?

    public init(title: String,
                icon: UIImage?) {
        self.title = title
        self.icon = icon
    }
}
