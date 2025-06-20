import Foundation

@testable import govuk_ios

class MockAccessibilityAnnouncerService: AccessibilityAnnouncerServiceInterface {
    var _receivedAnnounceValue: String?
    func announce(_ value: String) {
        _receivedAnnounceValue = value
    }
}
