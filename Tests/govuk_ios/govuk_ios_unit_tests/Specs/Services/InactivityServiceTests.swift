import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
class InactivityServiceTests {
    @Test
    func startMonitoring_setsUpTimer() {
        let mockTimer = MockTimerWrapper()
        let mockAuthService = MockAuthenticationService()
        mockAuthService._stubbedIsSignedIn = true
        let sut = InactivityService(authenticationService: mockAuthService,
                                    timer: mockTimer)

        sut.startMonitoring {}
        #expect(mockTimer.lastCreatedTimer != nil)
        #expect(mockTimer.lastCreatedTimer?.interval == 900)
    }

    @Test
    func startMonitoring_callsInactiveHandler() {
        let mockTimer = MockTimerWrapper()
        let mockAuthService = MockAuthenticationService()
        mockAuthService._stubbedIsSignedIn = true
        let sut = InactivityService(authenticationService: mockAuthService,
                                    timer: mockTimer)
        var handlerCalled = false
        sut.startMonitoring { handlerCalled = true }

        #expect(!handlerCalled)
        mockTimer.lastCreatedTimer?.fire()
        #expect(handlerCalled)
    }

    @Test
    func resetTimer_invalidatesExistingTimerAndCreatesNew() {
        let mockTimer = MockTimerWrapper()
        let mockAuthService = MockAuthenticationService()
        mockAuthService._stubbedIsSignedIn = true
        let sut = InactivityService(authenticationService: mockAuthService,
                                    timer: mockTimer)
        sut.startMonitoring { }
        let firstTimer = mockTimer.lastCreatedTimer
        sut.resetTimer()

        #expect(firstTimer!.invalidateCalled)
        #expect(mockTimer.lastCreatedTimer != firstTimer)
    }

    @Test
    func resetTimer_signedOut_doesntInvalidateTimer() {
        let mockTimer = MockTimerWrapper()
        let mockAuthService = MockAuthenticationService()
        mockAuthService._stubbedIsSignedIn = false
        let sut = InactivityService(authenticationService: mockAuthService,
                                    timer: mockTimer)
        sut.resetTimer()
        let firstTimer = mockTimer.lastCreatedTimer

        #expect(firstTimer == nil)
    }

    @Test
    func startMonitoring_appDidEnterBackground_setsBackgroundedTime() {
        let mockTimer = MockTimerWrapper()
        let mockAuthService = MockAuthenticationService()
        mockAuthService._stubbedIsSignedIn = true
        let sut = InactivityService(authenticationService: mockAuthService,
                                    timer: mockTimer)
        sut.startMonitoring { }
        let timer = mockTimer.lastCreatedTimer
        let initialBackgroundedTime = sut.backgroundedTime
        NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: nil)

        #expect(timer!.invalidateCalled)
        #expect(sut.backgroundedTime > initialBackgroundedTime)
    }

    @Test
    func appWillEnterForeground_inactive_callsHandler() {
        let mockTimer = MockTimerWrapper()
        let mockAuthService = MockAuthenticationService()
        mockAuthService._stubbedIsSignedIn = true
        let sut = InactivityService(authenticationService: mockAuthService,
                                    timer: mockTimer)
        var handlerCalled = false
        sut.startMonitoring {
            handlerCalled = true
        }
        sut.backgroundedTime = Date().addingTimeInterval(-16 * 60)
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)

        #expect(handlerCalled)
    }

    @Test
    func appWillEnterForeground_active_doesntCallHandler() {
        let mockTimer = MockTimerWrapper()
        let initialTimer = mockTimer.lastCreatedTimer
        let mockAuthService = MockAuthenticationService()
        mockAuthService._stubbedIsSignedIn = true
        let sut = InactivityService(authenticationService: mockAuthService,
                                    timer: mockTimer)
        var handlerCalled = false
        sut.startMonitoring {
            handlerCalled = true
        }
        sut.backgroundedTime = Date().addingTimeInterval(-14 * 60)
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)

        #expect(!handlerCalled)
        #expect(mockTimer.lastCreatedTimer != initialTimer)
    }

    @Test
    func appWillEnterForeground_inactive_signedOut_doesntCallHandler() {
        let mockTimer = MockTimerWrapper()
        let initialTimer = mockTimer.lastCreatedTimer
        let mockAuthService = MockAuthenticationService()
        mockAuthService._stubbedIsSignedIn = false
        let sut = InactivityService(authenticationService: mockAuthService,
                                    timer: mockTimer)
        var handlerCalled = false
        sut.startMonitoring {
            handlerCalled = true
        }
        sut.backgroundedTime = Date().addingTimeInterval(-16 * 60)
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)

        #expect(!handlerCalled)
    }

    @Test
    func appInteraction_resetsTimer() {
        let mockTimer = MockTimerWrapper()
        var timer = mockTimer.lastCreatedTimer
        let mockAuthService = MockAuthenticationService()
        mockAuthService._stubbedIsSignedIn = true
        let sut = InactivityService(authenticationService: mockAuthService,
                                    timer: mockTimer)
        sut.startMonitoring { }

        NotificationCenter.default.post(name: UIAccessibility.elementFocusedNotification, object: nil)
        #expect(mockTimer.lastCreatedTimer != timer)

        timer = mockTimer.lastCreatedTimer
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        #expect(mockTimer.lastCreatedTimer != timer)

        timer = mockTimer.lastCreatedTimer
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: nil)
        #expect(mockTimer.lastCreatedTimer != timer)
    }
}
