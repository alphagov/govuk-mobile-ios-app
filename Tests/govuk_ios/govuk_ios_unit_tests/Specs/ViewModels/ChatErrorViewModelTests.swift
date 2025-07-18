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
            error: ChatError.networkUnavailable,
            action: {
                didCallCompletion = true
            }
        )

        sut.buttonViewModel.action()

        #expect(didCallCompletion)
    }

    @Test(arguments: zip(
        [ChatError.networkUnavailable, ChatError.apiUnavailable],
        [UIColor.govUK.text.buttonPrimary, UIColor.govUK.text.buttonSecondary]
    ))
    func button_hasCorrectConfiguration_forError(error: ChatError,
                                                 expectedTitleColor: UIColor) {
        let sut = ChatErrorViewModel(
            error: error,
            action: { }
        )

        #expect(sut.buttonConfiguration.titleColorNormal == expectedTitleColor)
    }
}
