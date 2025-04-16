import Foundation
import UIKit

import Onboarding

@testable import govuk_ios

class MockNotificationService: NotificationServiceInterface {

    var _stubbededPermissionState: NotificationPermissionState = .notDetermined
    var permissionState: NotificationPermissionState {
        get async {
            _stubbededPermissionState
        }
    }

    var _setRedirectedToNotificationsOnboardinCalled: Bool?
    func setRedirectedToNotificationsOnboarding(redirected: Bool) {
        _setRedirectedToNotificationsOnboardinCalled = redirected
    }

    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {

    }

    var _receivedRequestPermissionsCompletion: (() -> Void)?
    func requestPermissions(completion: (() -> Void)?) {
        _receivedRequestPermissionsCompletion = completion
    }

    var _stubbedShouldRequestPermission: Bool = true
    var shouldRequestPermission: Bool {
        _stubbedShouldRequestPermission
    }

    var _receivedFetchSlidesCompletion: ((Result<[any OnboardingSlideViewModelInterface], any Error>) -> Void)?
    func fetchSlides(completion: @escaping (Result<[any OnboardingSlideViewModelInterface], any Error>) -> Void) {
        _receivedFetchSlidesCompletion = completion
    }

    var _stubbedIsFetureEnabled: Bool = true
    var isFeatureEnabled: Bool {
        _stubbedIsFetureEnabled
    }

    var _onClickAction: ((URL) -> Void)?
    func addClickListener(onClickAction: @escaping (URL) -> Void) {
        _onClickAction = onClickAction
    }
}
