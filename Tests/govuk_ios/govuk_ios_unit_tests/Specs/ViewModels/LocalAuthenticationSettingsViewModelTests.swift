import Testing
import LocalAuthentication
import UIKit
import Combine

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
struct LocalAuthenticationSettingsViewModelTests {
    @Test
    func init_faceId_setsCorrectProperties() {
        let mockAuthService = MockAuthenticationService()
        let mockLocalAuthService = MockLocalAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let mockURLOpener = MockURLOpener()
        mockLocalAuthService._stubbedDeviceCapableAuthType = .faceID
        mockLocalAuthService._stubbedTouchIdEnabled = false
        let sut = LocalAuthenticationSettingsViewModel(
            authenticationService: mockAuthService,
            localAuthenticationService: mockLocalAuthService,
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener
        )

        #expect(sut.title == "Face ID")
        #expect(sut.buttonTitle == "Open Face ID settings")
        #expect(!sut.body.isEmpty)
        #expect(!sut.showSettingsAlert)
        #expect(!sut.touchIdEnabled)
    }

    @Test
    func init_touchId_setsCorrectProperties() {
        let mockAuthService = MockAuthenticationService()
        let mockLocalAuthService = MockLocalAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let mockURLOpener = MockURLOpener()
        mockLocalAuthService._stubbedDeviceCapableAuthType = .touchID
        let sut = LocalAuthenticationSettingsViewModel(
            authenticationService: mockAuthService,
            localAuthenticationService: mockLocalAuthService,
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener
        )

        #expect(sut.title == "Touch ID")
        #expect(sut.buttonTitle == "Unlock app with Touch ID")
        #expect(!sut.body.isEmpty)
        #expect(!sut.showSettingsAlert)
        #expect(sut.touchIdEnabled)
    }

    @Test
    func faceIdButtonAction_storedRefreshTokenPresent_setsShowSettingsAlert() {
        let mockAuthService = MockAuthenticationService()
        let mockLocalAuthService = MockLocalAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let mockURLOpener = MockURLOpener()
        mockLocalAuthService._stubbedDeviceCapableAuthType = .faceID
        mockAuthService._storedRefreshToken = true
        let sut = LocalAuthenticationSettingsViewModel(
            authenticationService: mockAuthService,
            localAuthenticationService: mockLocalAuthService,
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener
        )

        #expect(!sut.showSettingsAlert)
        sut.faceIdButtonAction()
        #expect(sut.showSettingsAlert)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String ==
                String.settings.localized("localAuthenticationFaceIdButtonTitle"))
    }

    @Test
    func faceIdButtonAction_noStoredRefreshToken_evaluatesAndStoresToken() {
        let mockAuthService = MockAuthenticationService()
        let mockLocalAuthService = MockLocalAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let mockURLOpener = MockURLOpener()
        mockLocalAuthService._stubbedFaceIdSkipped = true
        mockLocalAuthService._stubbedDeviceCapableAuthType = .faceID
        mockLocalAuthService._stubbedEvaluatePolicyResult = (true, nil)
        mockAuthService._storedRefreshToken = false
        let sut = LocalAuthenticationSettingsViewModel(
            authenticationService: mockAuthService,
            localAuthenticationService: mockLocalAuthService,
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener
        )
        sut.faceIdButtonAction()

        #expect(!sut.showSettingsAlert)
        #expect(!mockLocalAuthService.faceIdSkipped)
        #expect(mockAuthService._encryptRefreshTokenCallSuccess)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String ==
                String.settings.localized("localAuthenticationFaceIdButtonTitle"))
    }

    @Test
    func faceIdButtonAction_noStoredRefreshToken_evaluateError_setsShowSettingsAlert() async {
        let mockAuthService = MockAuthenticationService()
        let mockLocalAuthService = MockLocalAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let mockURLOpener = MockURLOpener()
        mockLocalAuthService._stubbedDeviceCapableAuthType = .faceID
        mockLocalAuthService._stubbedEvaluatePolicyResult = (false, LAError( .biometryNotAvailable))
        mockAuthService._storedRefreshToken = false
        let sut = LocalAuthenticationSettingsViewModel(
            authenticationService: mockAuthService,
            localAuthenticationService: mockLocalAuthService,
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener
        )

        #expect(!sut.showSettingsAlert)
        var cancellables = Set<AnyCancellable>()
        let result = await withCheckedContinuation { continuation in
            sut.faceIdButtonAction()
            let tester = LocalAuthSettingsViewModelTester(viewModel: sut)
            tester.objectWillChange
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    continuation.resume(returning: tester.viewModel)
                    cancellables.removeAll()
                }.store(in: &cancellables)
        }
        #expect(result.showSettingsAlert)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String ==
                String.settings.localized("localAuthenticationFaceIdButtonTitle"))
    }

    @Test
    func touchIdToggleAction_storedRefreshToken_disabled_setsTouchIdDisabled() {
        let mockAuthService = MockAuthenticationService()
        let mockLocalAuthService = MockLocalAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let mockURLOpener = MockURLOpener()
        mockLocalAuthService._stubbedDeviceCapableAuthType = .touchID
        mockAuthService._storedRefreshToken = true
        mockLocalAuthService._stubbedTouchIdEnabled = true
        let sut = LocalAuthenticationSettingsViewModel(
            authenticationService: mockAuthService,
            localAuthenticationService: mockLocalAuthService,
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener
        )
        sut.touchIdToggleAction(enabled: false)

        #expect(!mockLocalAuthService._stubbedTouchIdEnabled)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String ==
                String.settings.localized("localAuthenticationTouchIdButtonTitle"))
    }

    @Test
    func touchIdToggleAction_storedRefreshToken_enabled_setsTouchIdEnabled() {
        let mockAuthService = MockAuthenticationService()
        let mockLocalAuthService = MockLocalAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let mockURLOpener = MockURLOpener()
        mockLocalAuthService._stubbedDeviceCapableAuthType = .touchID
        mockAuthService._storedRefreshToken = true
        mockLocalAuthService._stubbedTouchIdEnabled = false
        let sut = LocalAuthenticationSettingsViewModel(
            authenticationService: mockAuthService,
            localAuthenticationService: mockLocalAuthService,
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener
        )
        sut.touchIdToggleAction(enabled: true)

        #expect(mockLocalAuthService._stubbedTouchIdEnabled)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String ==
                String.settings.localized("localAuthenticationTouchIdButtonTitle"))
    }

    @Test
    func touchIdToggleAction_noStoredRefreshToken_disabled_setsTouchIdDisabled() {
        let mockAuthService = MockAuthenticationService()
        let mockLocalAuthService = MockLocalAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let mockURLOpener = MockURLOpener()
        mockLocalAuthService._stubbedDeviceCapableAuthType = .touchID
        mockAuthService._storedRefreshToken = false
        mockLocalAuthService._stubbedTouchIdEnabled = true
        let sut = LocalAuthenticationSettingsViewModel(
            authenticationService: mockAuthService,
            localAuthenticationService: mockLocalAuthService,
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener
        )
        sut.touchIdToggleAction(enabled: false)

        #expect(!mockLocalAuthService._stubbedTouchIdEnabled)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String ==
                String.settings.localized("localAuthenticationTouchIdButtonTitle"))
    }

    @Test
    func touchIdToggleAction_noStoredRefreshToken_enabled_evaluateSuccess_setsTouchIdEnabled() {
        let mockAuthService = MockAuthenticationService()
        let mockLocalAuthService = MockLocalAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let mockURLOpener = MockURLOpener()
        mockLocalAuthService._stubbedDeviceCapableAuthType = .touchID
        mockAuthService._storedRefreshToken = false
        mockLocalAuthService._stubbedEvaluatePolicyResult = (true, nil)
        mockLocalAuthService._stubbedTouchIdEnabled = false
        let sut = LocalAuthenticationSettingsViewModel(
            authenticationService: mockAuthService,
            localAuthenticationService: mockLocalAuthService,
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener
        )
        sut.touchIdToggleAction(enabled: true)

        #expect(mockLocalAuthService._stubbedTouchIdEnabled)
        DispatchQueue.main.async {
            #expect(sut.touchIdEnabled)
        }
        #expect(mockAuthService._encryptRefreshTokenCallSuccess)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String ==
                String.settings.localized("localAuthenticationTouchIdButtonTitle"))
    }

    @Test
    func touchIdToggleAction_noStoredRefreshToken_enabled_evaluateFailure_setsTouchIdDisabled() {
        let mockAuthService = MockAuthenticationService()
        let mockLocalAuthService = MockLocalAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let mockURLOpener = MockURLOpener()
        mockLocalAuthService._stubbedDeviceCapableAuthType = .touchID
        mockAuthService._storedRefreshToken = false
        mockLocalAuthService._stubbedEvaluatePolicyResult = (false, nil)
        mockLocalAuthService._stubbedTouchIdEnabled = true
        let sut = LocalAuthenticationSettingsViewModel(
            authenticationService: mockAuthService,
            localAuthenticationService: mockLocalAuthService,
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener
        )
        sut.touchIdToggleAction(enabled: true)

        #expect(!mockLocalAuthService._stubbedTouchIdEnabled)
        DispatchQueue.main.async {
            #expect(!sut.touchIdEnabled)
        }
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String ==
                String.settings.localized("localAuthenticationTouchIdButtonTitle"))
    }

    @Test
    func openSettings_opensSettings() {
        let mockAuthService = MockAuthenticationService()
        let mockLocalAuthService = MockLocalAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let mockURLOpener = MockURLOpener()
        mockLocalAuthService._stubbedFaceIdSkipped = true
        let sut = LocalAuthenticationSettingsViewModel(
            authenticationService: mockAuthService,
            localAuthenticationService: mockLocalAuthService,
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener
        )
        sut.showSettingsAlert = true

        #expect(sut.showSettingsAlert)
        sut.openSettings()
        #expect(!mockLocalAuthService.faceIdSkipped)
        #expect(!sut.showSettingsAlert)
        #expect(mockURLOpener._receivedOpenIfPossibleUrlString ==
                UIApplication.openSettingsURLString)
    }
}

class LocalAuthSettingsViewModelTester: ObservableObject {
    @Published var viewModel: LocalAuthenticationSettingsViewModel
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: LocalAuthenticationSettingsViewModel) {
        self.viewModel = viewModel
        observe()
    }

    private func observe() {
        viewModel.objectWillChange
            .sink(receiveValue: objectWillChange.send)
            .store(in: &self.cancellables)
    }
}
