import Foundation
import UIKit
import GOVKit

@MainActor
class MockBaseViewController: BaseViewController,
                              TrackableScreen {
    var trackingName: String { "test_mock_tracking_name" }
    var additionalParameters: [String : Any] { ["test_param": "test_value"] }

    init() {
        super.init(analyticsService: MockAnalyticsService())
    }

    override init(analyticsService: AnalyticsServiceInterface) {
        super.init(analyticsService: analyticsService)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

    private(set) var _presentedViewController: UIViewController?
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        super.present(
            viewControllerToPresent,
            animated: flag,
            completion: completion
        )
        _presentedViewController = viewControllerToPresent
    }
}
