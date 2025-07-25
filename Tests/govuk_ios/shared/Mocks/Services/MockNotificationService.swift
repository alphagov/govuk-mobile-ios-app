import Foundation
import UIKit

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

    var _stubbedIsFetureEnabled: Bool = true
    var isFeatureEnabled: Bool {
        _stubbedIsFetureEnabled
    }

    var _onClickAction: ((URL) -> Void)?
    func addClickListener(onClickAction: @escaping (URL) -> Void) {
        _onClickAction = onClickAction
    }

    var _acceptConsentCalled: Bool = false
    func acceptConsent() {
        _acceptConsentCalled = true
    }

    var _rejectConsentCalled: Bool = false
    func rejectConsent() {
        _rejectConsentCalled = true
    }

    var _toggleHasGivenConsentCalled: Bool = false
    func toggleHasGivenConsent() {
        _toggleHasGivenConsentCalled = true
    }

    var _stubbedhasGivenConsent: Bool = false
    var hasGivenConsent: Bool {
        _stubbedhasGivenConsent
    }

    var _stubbedFetchConsentAlignmentResult: NotificationConsentResult = .aligned
    func fetchConsentAlignment() async -> NotificationConsentResult {
        _stubbedFetchConsentAlignmentResult
    }
}
