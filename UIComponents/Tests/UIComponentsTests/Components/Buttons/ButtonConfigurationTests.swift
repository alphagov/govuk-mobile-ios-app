import Foundation
import UIKit
import Testing

@testable import UIComponents

@Suite
struct ButtonConfigurationTests {
    @Test
    func primary_returnsExpectedConfiguration() {
        let sut = GOVUKButton.ButtonConfiguration.primary

        #expect(sut.titleColorNormal ==
                UIColor.govUK.text.buttonPrimary)
        #expect(sut.titleColorHighlighted == nil)
        #expect(sut.titleColorFocused ==
                UIColor.govUK.text.buttonPrimaryFocussed)
        #expect(sut.titleColorDisabled ==
                UIColor.govUK.text.buttonPrimaryDisabled)
        #expect(sut.titleFont ==
                UIFont.govUK.bodySemibold)
        #expect(sut.backgroundColorNormal ==
                UIColor.govUK.fills.surfaceButtonPrimary)
        #expect(sut.backgroundColorHighlighted ==
                UIColor.govUK.fills.surfaceButtonPrimaryHighlight)
        #expect(sut.backgroundColorFocused ==
                UIColor.govUK.fills.surfaceButtonPrimaryFocussed)
        #expect(sut.backgroundColorDisabled ==
                UIColor.govUK.fills.surfaceButtonPrimaryDisabled)

        #expect(sut.borderColorNormal == .clear)

        #expect(sut.cornerRadius == 15)

        let accessibilityNormal = sut.accessibilityButtonShapesColor(for: .normal)
        #expect(accessibilityNormal == sut.backgroundColorNormal)

        let accessibilityHighlighted = sut.accessibilityButtonShapesColor(for: .highlighted)
        #expect(
            accessibilityHighlighted ==
            sut.backgroundColorHighlighted
        )

        let accessibilityFocussed = sut.accessibilityButtonShapesColor(for: .focused)
        #expect(
            accessibilityFocussed ==
            sut.backgroundColorFocused
        )
    }

    @Test
    func secondary_returnsExpectedConfiguration() {
        let sut = GOVUKButton.ButtonConfiguration.secondary

        #expect(sut.titleColorNormal ==
                UIColor.govUK.text.buttonSecondary)
        #expect(sut.titleColorHighlighted ==
                UIColor.govUK.text.buttonSecondaryHighlight)
        #expect(sut.titleColorFocused ==
                UIColor.govUK.text.buttonSecondaryFocussed)
        #expect(sut.titleColorDisabled ==
                UIColor.govUK.text.buttonSecondaryDisabled)
        #expect(sut.titleFont == UIFont.govUK.body)
        #expect(sut.backgroundColorNormal == .clear)
        #expect(sut.backgroundColorHighlighted == .clear)
        #expect(sut.backgroundColorFocused ==
                UIColor.govUK.fills.surfaceButtonSecondaryFocussed)
        #expect(sut.backgroundColorDisabled == .clear)

        #expect(sut.borderColorNormal == .clear)

        #expect(sut.cornerRadius == 4)

        let accessibilityNormal = sut.accessibilityButtonShapesColor(for: .normal)
        #expect(accessibilityNormal == sut.accessibilityButtonShapesColor)

        let accessibilityHighlighted = sut.accessibilityButtonShapesColor(for: .highlighted)
        #expect(
            accessibilityHighlighted ==
            sut.accessibilityButtonShapesColor.withAlphaComponent(0.7)
        )

        let accessibilityFocussed = sut.accessibilityButtonShapesColor(for: .focused)
        #expect(
            accessibilityFocussed ==
            sut.accessibilityButtonShapesColor
        )
    }

    @Test
    func compact_returnsExpectedConfiguration() {
        let sut = GOVUKButton.ButtonConfiguration.compact

        #expect(sut.titleColorNormal ==
                UIColor.govUK.text.buttonCompact)
        #expect(sut.titleColorHighlighted ==
                UIColor.govUK.text.buttonCompactHighlight)
        #expect(sut.titleColorFocused ==
                UIColor.govUK.text.buttonCompactFocussed)
        #expect(sut.titleColorDisabled ==
                UIColor.govUK.text.buttonCompactDisabled)
        #expect(sut.titleFont == UIFont.govUK.body)
        #expect(sut.backgroundColorNormal ==
                UIColor.govUK.fills.surfaceButtonCompact)
        #expect(sut.backgroundColorHighlighted ==
                UIColor.govUK.fills.surfaceButtonCompactHighlight)
        #expect(sut.backgroundColorFocused ==
                UIColor.govUK.fills.surfaceButtonCompactFocussed)
        #expect(sut.backgroundColorDisabled ==
                UIColor.govUK.fills.surfaceButtonCompactDisabled)

        #expect(sut.borderColorNormal ==
                UIColor.govUK.strokes.cardBlue)
        #expect(sut.borderColorHighlighted ==
                UIColor.govUK.strokes.buttonCompactHighlight)

        #expect(sut.cornerRadius == 15)

        let accessibilityNormal = sut.accessibilityButtonShapesColor(for: .normal)
        #expect(accessibilityNormal == sut.backgroundColorNormal)

        let accessibilityHighlighted = sut.accessibilityButtonShapesColor(for: .highlighted)
        #expect(
            accessibilityHighlighted ==
            sut.backgroundColorHighlighted
        )

        let accessibilityFocussed = sut.accessibilityButtonShapesColor(for: .focused)
        #expect(
            accessibilityFocussed ==
            sut.backgroundColorFocused
        )
    }

    @Test
    func destructive_returnsExpectedConfiguration() {
        let sut = GOVUKButton.ButtonConfiguration.destructive

        #expect(sut.titleColorNormal ==
                UIColor.govUK.text.buttonPrimary)
        #expect(sut.titleColorHighlighted == nil)
        #expect(sut.titleColorFocused ==
                UIColor.govUK.text.buttonPrimaryFocussed)
        #expect(sut.titleColorDisabled ==
                UIColor.govUK.text.buttonPrimaryDisabled)
        #expect(sut.titleFont ==
                UIFont.govUK.bodySemibold)
        #expect(sut.backgroundColorNormal ==
                UIColor.govUK.fills.surfaceButtonDestructive)
        #expect(sut.backgroundColorHighlighted ==
                UIColor.govUK.fills.surfaceButtonDestructiveHighlight)
        #expect(sut.backgroundColorFocused ==
                UIColor.govUK.fills.surfaceButtonPrimaryFocussed)
        #expect(sut.backgroundColorDisabled ==
                UIColor.govUK.fills.surfaceButtonPrimaryDisabled)

        #expect(sut.borderColorNormal == .clear)

        #expect(sut.cornerRadius == 15)

        let accessibilityNormal = sut.accessibilityButtonShapesColor(for: .normal)
        #expect(accessibilityNormal == sut.backgroundColorNormal)

        let accessibilityHighlighted = sut.accessibilityButtonShapesColor(for: .highlighted)
        #expect(
            accessibilityHighlighted ==
            sut.backgroundColorHighlighted
        )

        let accessibilityFocussed = sut.accessibilityButtonShapesColor(for: .focused)
        #expect(
            accessibilityFocussed ==
            sut.backgroundColorFocused
        )
    }

    @Test
    func backgroundColorFor_highlighted_returnsExpectedColor() {
        let sut = GOVUKButton.ButtonConfiguration(
            titleFont: UIFont.govUK.body,
            backgroundColorNormal: .red,
            backgroundColorHighlighted: .blue,
            backgroundColorFocused: .green,
            backgroundColorDisabled: .clear,
            accessibilityButtonShapesColor: .purple
        )
        let result = sut.backgroundColor(for: [.highlighted, .focused])
        #expect(result == .blue)
    }

    @Test
    func backgroundColorFor_focussed_returnsExpectedColor() {
        let sut = GOVUKButton.ButtonConfiguration(
            titleFont: UIFont.govUK.body,
            backgroundColorNormal: .red,
            backgroundColorHighlighted: .blue,
            backgroundColorFocused: .green,
            backgroundColorDisabled: .clear,
            accessibilityButtonShapesColor: .purple
        )
        let result = sut.backgroundColor(for: [.focused])
        #expect(result == .green)
    }
}

