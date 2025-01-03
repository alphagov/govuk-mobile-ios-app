import Foundation
import GOVKit

@MainActor
public class MockBaseViewController: BaseViewController,
                                     TrackableScreen {
    public var trackingName: String { "test_mock_tracking_name" }
    public var additionalParameters: [String : Any] { ["test_param": "test_value"] }

    public var _receivedBeginAppearanceTransitionAnimated: Bool?
    public override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        _receivedBeginAppearanceTransitionAnimated = animated
    }

    public var _endAppearanceTransitionCalled: Bool = false
    public override func endAppearanceTransition() {
        super.endAppearanceTransition()
        _endAppearanceTransitionCalled = true
    }
}
