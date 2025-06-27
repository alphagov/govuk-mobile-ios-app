import Foundation
import UIKit
import Testing

@testable import UIComponents

@Suite
@MainActor
struct GOVUKButtonTests {
    let sut: GOVUKButton
    let configuration: GOVUKButton.ButtonConfiguration

    init() {
        self.configuration = GOVUKButton.ButtonConfiguration.secondary
        self.sut = GOVUKButton(configuration)
    }

    @Test
    func init_withConfig_noTitle_returnsExpectedResult() {
        #expect(sut.backgroundColor == configuration.backgroundColorNormal)
        #expect(sut.titleLabel?.textColor == configuration.titleColorNormal)
        #expect(sut.titleLabel?.text == nil)
    }

    @Test
    func setTitleText_setsTitle() {
        sut.setTitle("test button", for: .normal)
        #expect(sut.titleLabel?.text == "test button")
    }

    @Test
    func setBackgroundColor_setsColor() {
        sut.backgroundColor = nil
        #expect(sut.backgroundColor == nil)

        sut.backgroundColor = .cyan
        #expect(sut.backgroundColor == .cyan)

        sut.backgroundColor = .clear
        #expect(sut.backgroundColor != nil)
    }

    @Test
    func setViewModel_changesViewModel() {
        let expectedViewModel = GOVUKButton.ButtonViewModel(
            localisedTitle: "new title",
            action: {
                // empty action
            }
        )

        sut.viewModel = expectedViewModel

        #expect(sut.viewModel?.localisedTitle == expectedViewModel.localisedTitle)
        #expect(sut.title(for: .normal) == expectedViewModel.localisedTitle)
    }

    @Test
    func setButtonConfiguration_changesConfig() {
        let expectedConfig = GOVUKButton.ButtonConfiguration.primary
        sut.buttonConfiguration = expectedConfig

        #expect(sut.buttonConfiguration.titleColorNormal == expectedConfig.titleColorNormal)
        #expect(sut.titleColor(for: .normal) == expectedConfig.titleColorNormal)
    }
}
