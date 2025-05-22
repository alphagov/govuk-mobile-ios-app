import Foundation
import UIKit
import LocalAuthentication

protocol InactivityServiceInterface {
    func startMonitoring(inactivityHandler: @escaping () -> Void)
    func resetTimer()
}

class InactivityService: InactivityServiceInterface {
    private let timer: TimerWrapperInterface
    private let authenticationService: AuthenticationServiceInterface
    private let inactivityThreshold: TimeInterval = 15 * 60 // 15 minutes
    private var inAppTimer: Timer?
    private var inactivityHandler: (() -> Void)?
    var backgroundedTime: Date = Date()

    private var inactive: Bool {
        let currentTime = Date()
        let inactivityDuration = currentTime.timeIntervalSince(backgroundedTime)
        return inactivityDuration >= inactivityThreshold
    }

    init(authenticationService: AuthenticationServiceInterface,
         timer: TimerWrapperInterface) {
        self.authenticationService = authenticationService
        self.timer = timer
        registerObservers()
    }

    func startMonitoring(inactivityHandler: @escaping () -> Void) {
        self.inactivityHandler = inactivityHandler
        resetTimer()
    }

    func resetTimer() {
        guard self.authenticationService.isSignedIn else {
            return
        }

        inAppTimer?.invalidate()
        inAppTimer = timer.scheduledTimer(withTimeInterval: inactivityThreshold,
                                          repeats: false) { [weak self] _ in
            self?.inactivityHandler?()
        }
    }

    private func registerObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appInteraction),
            name: UIAccessibility.elementFocusedNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appInteraction),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appInteraction),
            name: UITextField.textDidChangeNotification,
            object: nil
        )
    }

    @objc private func appDidEnterBackground() {
        inAppTimer?.invalidate()
        backgroundedTime = Date()
    }

    @objc private func appWillEnterForeground() {
        guard authenticationService.isSignedIn else {
            return
        }

        if inactive {
            inactivityHandler?()
            resetTimer()
        }
    }

    @objc private func appInteraction() {
        resetTimer()
    }
}
