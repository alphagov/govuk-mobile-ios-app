import Foundation
import Testing
import GOVKit

@testable import govuk_ios

@Suite
struct AppUnavailableViewModelTests {
    @Test
    func init_networkAvailable_hasCorrectInitialState()  {
        let sut = AppUnavailableContainerViewModel(
            appLaunchService: MockAppLaunchService(),
            dismissAction: { }
        )

        #expect(sut.title == "Sorry, the app is unavailable")
        #expect(sut.subheading == "You cannot use the GOV.UK app at the moment. Try again later.")
        #expect(sut.buttonTitle == "Go to the GOV.UK website ↗")
        #expect(sut.buttonAccessibilityTitle == "Go to the GOV.UK website")
        #expect(sut.buttonAccessibilityHint == "Opens in web browser")
    }

    @Test
    func init_networkUnavailable_hasCorrectInitialState()  {
        let sut = AppUnavailableContainerViewModel(
            appLaunchService: MockAppLaunchService(),
            error: AppConfigError.networkUnavailable,
            dismissAction: { }
        )


        #expect(sut.title == "You are not connected to the internet")
        #expect(sut.subheading ==
            """
            You need to have an internet connection to use the GOV.UK app. 

            Reconnect to the internet and try again.
            """
        )
        #expect(sut.buttonTitle == "Try again")
        #expect(sut.buttonAccessibilityTitle == "Try again")
        #expect(sut.buttonAccessibilityHint == "")
    }

    @Test
    func goToGovUkButtonAction_opensURL() {
        let urlOpener = MockURLOpener()
        let sut = AppUnavailableContainerViewModel(
            urlOpener: urlOpener,
            appLaunchService: MockAppLaunchService(),
            dismissAction: { }
        )
        sut.buttonViewModel.action()
        #expect(urlOpener._receivedOpenIfPossibleUrl == Constants.API.govukBaseUrl)
    }

    @Test
    func tryAgainButtonAction_successfulFetch_dismisses() {
        let urlOpener = MockURLOpener()
        let mockAppLaunchService = MockAppLaunchService()
        let expectedResponse = AppLaunchResponse(
            configResult: .success(.arrange),
            topicResult: .success(
                [TopicResponseItem(ref: "ref",
                                   title: "title",
                                   description: "description")
                ]
            ),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: MockAppVersionProvider()
        )
        mockAppLaunchService._receivedFetchCompletion?(expectedResponse)
        var didDismiss = false
        let sut = AppUnavailableContainerViewModel(
            urlOpener: urlOpener,
            appLaunchService: mockAppLaunchService,
            error: AppConfigError.networkUnavailable,
            dismissAction: {
                didDismiss = true
            }
        )
        sut.buttonViewModel.action()
        mockAppLaunchService._receivedFetchCompletion?(expectedResponse)
        #expect(didDismiss)
    }

    @Test
    func tryAgainButtonAction_fetchError_doesNot_dismiss() {
        let urlOpener = MockURLOpener()
        let mockAppLaunchService = MockAppLaunchService()
        let expectedResponse = AppLaunchResponse(
            configResult: .failure(.remoteJson),
            topicResult: .success(
                [TopicResponseItem(ref: "ref",
                                   title: "title",
                                   description: "description")
                ]
            ),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: MockAppVersionProvider()
        )

        var didDismiss = false
        let sut = AppUnavailableContainerViewModel(
            urlOpener: urlOpener,
            appLaunchService: mockAppLaunchService,
            error: AppConfigError.networkUnavailable,
            dismissAction: {
                didDismiss = true
            }
        )
        sut.buttonViewModel.action()
        mockAppLaunchService._receivedFetchCompletion?(expectedResponse)
        #expect(!didDismiss)
    }
}
