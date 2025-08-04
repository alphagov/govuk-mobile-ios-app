import Testing
import UIKit

@testable import govuk_ios
@testable import GOVKit
@testable import UIComponents

struct ChatErrorViewModelTests {

    @Test
    func actionButton_callsAction() {
        var didCallCompletion = false

        let sut = ChatErrorViewModel(
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
            error: .networkUnavailable,
            action: { }
        )

        #expect(sut.title == String.common.localized("networkUnavailableErrorTitle"))
        #expect(sut.subtitle == String.common.localized("networkUnavailableErrorBody"))
        #expect(sut.buttonTitle == String.common.localized("networkUnavailableButtonTitle"))
        #expect(sut.showActionButton)
    }

    @Test
    func hasCorrectStyle_forPageNotFoundError() {
        let sut = ChatErrorViewModel(
            error: .pageNotFound,
            action: { }
        )

        #expect(sut.title == String.common.localized("genericErrorTitle"))
        #expect(sut.subtitle == String.chat.localized("pageNotFoundErrorBody"))
        #expect(sut.buttonTitle == String.chat.localized("pageNotFoundButtonTitle"))
        #expect(sut.showActionButton)
    }

    @Test
    func hasCorrectStyle_forOtherError() {
        let sut = ChatErrorViewModel(
            error: .apiUnavailable,
            action: { }
        )

        #expect(sut.title == String.common.localized("genericErrorTitle"))
        #expect(sut.subtitle == String.chat.localized("genericErrorBody"))
        #expect(sut.buttonTitle == "")
        #expect(!sut.showActionButton)
    }
}
