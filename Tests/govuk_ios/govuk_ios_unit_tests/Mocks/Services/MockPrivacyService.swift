import Foundation

@testable import govuk_ios

class MockPrivacyService: PrivacyPresenting {
    var _didShowPrivacyScreen: Bool = false
    func showPrivacyScreen() {
        _didShowPrivacyScreen = true
    }

    var _didHidePrivacyScreen: Bool = false
    func hidePrivacyScreen() {
        _didHidePrivacyScreen = true
    }
}

