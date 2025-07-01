import Foundation
import UIKit
import Testing

@testable import govuk_ios

class GovUIWindowTests {
    @Test @MainActor
    func sendEvent_touchEvent_resetsInactivityTimer() {
        let mockInactivityService = MockInactivityService()
        let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let window = GovUIWindow(
            windowScene: scene, inactivityService: mockInactivityService
        )
        let touchEvent = MockUITouchEvent()
        window.sendEvent(touchEvent)

        #expect(mockInactivityService._resetTimerCalled)
    }
}
