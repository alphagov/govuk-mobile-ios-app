import Foundation
import UIKit

extension UIApplication {
    var window: UIWindow? {
        let firstWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first
        return firstWindow
    }
}
