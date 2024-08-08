import Foundation

@testable import govuk_ios

class MockBaseViewController: BaseViewController,
                              TrackableScreen {

    var trackingName: String { "test_mock_tracking_name" }

}
