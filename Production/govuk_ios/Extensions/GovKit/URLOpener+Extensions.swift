import Foundation

import GOVKit

extension URLOpener {
    @discardableResult
    func openPrivacyPolicy() -> Bool {
        openIfPossible(Constants.API.privacyPolicyUrl)
    }
}
