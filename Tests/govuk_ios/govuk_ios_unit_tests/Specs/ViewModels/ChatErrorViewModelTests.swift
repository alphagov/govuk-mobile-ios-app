import Testing
import UIKit

@testable import govuk_ios
@testable import GOVKit
@testable import GOVKitTestUtilities
@testable import UIComponents

struct ChatErrorViewModelTests {

    @Test
    func actionButton_callsAction() {
        var didCallCompletion = false

        let sut = ChatErrorViewModel(
            analyticsService: MockAnalyticsService(),
            error: .networkUnavailable,
            action: {
                didCallCompletion = true
            }
        )

        sut.buttonViewModel.action()

        #expect(didCallCompletion)
    }

    @Test
    func hasCorrectStyle_forNetworkError() {
        let sut = ChatErrorViewModel(
            analyticsService: MockAnalyticsService(),
            error: .networkUnavailable,
            action: { }
        )

        #expect(sut.title == String.common.localized("networkUnavailableErrorTitle"))
        #expect(sut.subtitle == String.common.localized("networkUnavailableErrorBody"))
        #expect(sut.buttonTitle == String.common.localized("networkUnavailableButtonTitle"))
        #expect(sut.showActionButton)
        #expect(!sut.showImageWhenCompact)
    }

    @Test
    func hasCorrectStyle_forPageNotFoundError() {
        let sut = ChatErrorViewModel(
            analyticsService: MockAnalyticsService(),
            error: .pageNotFound,
            action: { }
        )

        #expect(sut.title == String.common.localized("genericErrorTitle"))
        #expect(sut.subtitle == String.chat.localized("pageNotFoundErrorBody"))
        #expect(sut.buttonTitle == String.chat.localized("pageNotFoundButtonTitle"))
        #expect(sut.showActionButton)
        #expect(!sut.showImageWhenCompact)
    }

    @Test
    func hasCorrectStyle_forOtherError() {
        let sut = ChatErrorViewModel(
            analyticsService: MockAnalyticsService(),
            error: .apiUnavailable,
            action: { }
        )

        #expect(sut.title == String.common.localized("genericErrorTitle"))
        #expect(sut.subtitle == String.chat.localized("genericErrorBody"))
        #expect(sut.buttonTitle == "")
        #expect(!sut.showActionButton)
        #expect(!sut.showImageWhenCompact)
    }

    @Test
    func trackScreen_createsCorrectEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatErrorViewModel(
            analyticsService: mockAnalyticsService,
            error: .apiUnavailable,
            action: { }
        )
        let screen = InfoView(viewModel: sut)
        sut.trackScreen(screen: screen)

        let screens = mockAnalyticsService._trackScreenReceivedScreens
        #expect(screens.count == 1)
        #expect(screens.first?.trackingName == sut.trackingName)
        #expect(screens.first?.trackingTitle == sut.trackingTitle)
    }
}
