import Foundation
import UIKit

extension UIApplication {
    var window: UIWindow? {
        let firstWindow = UIApplication.shared.connectedScenes
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?
            .windows
            .first
        return firstWindow
    }
}
