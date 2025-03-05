import Foundation
import UIKit

import Onboarding

@testable import govuk_ios

class MockNotificationService: NotificationServiceInterface {


    var  _receivedCompletion: UNAuthorizationStatus?
    func returnUserNotificationStatus(completionHandler: @escaping (UNAuthorizationStatus) -> Void) {
        if let result = _receivedCompletion {
            completionHandler(result)

        }
    }
    
    var _setRedirectedToNotificationsOnboardinCalled: Bool?
    func setRedirectedToNotificationsOnboarding(redirected: Bool) {
        _setRedirectedToNotificationsOnboardinCalled = redirected
    }

    var _stubbedRedirectedToNotifcationsOnboarding: Bool = false
    var redirectedToNotifcationsOnboarding: Bool {
        _stubbedRedirectedToNotifcationsOnboarding
    }

    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {

    }

    func requestPermissions(completion: @escaping () -> Void) {

    }

    var _stubbedShouldRequestPermission: Bool = true
    var shouldRequestPermission: Bool {
        _stubbedShouldRequestPermission
    }

    func fetchSlides(completion: @escaping (Result<[any OnboardingSlideViewModelInterface], any Error>) -> Void) {

    }

    var _stubbedIsFetureEnabled: Bool = true
    var isFeatureEnabled: Bool {
        _stubbedIsFetureEnabled
    }
}
