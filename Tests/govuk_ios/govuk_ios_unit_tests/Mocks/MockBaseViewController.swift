import Foundation

@testable import govuk_ios

class MockBaseViewController: BaseViewController,
                              TrackableScreen {
    var trackingName: String { "test_mock_tracking_name" }

    var _receivedBeginAppearanceTransitionAnimated: Bool?
    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        _receivedBeginAppearanceTransitionAnimated = animated
    }

    var _endAppearanceTransitionCalled: Bool = false
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
        _endAppearanceTransitionCalled = true
    }
}
