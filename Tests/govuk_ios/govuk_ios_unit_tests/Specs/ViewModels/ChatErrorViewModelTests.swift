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
            },
            openURLAction: { _ in }
        )

        sut.buttonViewModel.action()

        #expect(didCallCompletion)
    }

    @Test(arguments: zip(
        [ChatError.networkUnavailable, .apiUnavailable],
        [UIColor.govUK.text.buttonPrimary, UIColor.govUK.text.buttonSecondary]
    ))
    func button_hasCorrectConfiguration_forError(error: ChatError,
                                                 expectedTitleColor: UIColor) {
        let sut = ChatErrorViewModel(
            error: error,
            action: { },
            openURLAction: { _ in }
        )

        #expect(sut.buttonConfiguration.titleColorNormal == expectedTitleColor)
    }
}
