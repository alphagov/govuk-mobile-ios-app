import Foundation
import UIKit
import Testing

@testable import UIComponents

@Suite
@MainActor
struct GOVUKColors_TextTests {
    @Test
    func primary_returnsExpectedResult() {
        let result = UIColor.govUK.text.primary

        #expect(result.lightMode == .black)
        #expect(result.darkMode == .white)
    }

    @Test
    func secondaryreturnsExpectedResult() {
        let result = UIColor.govUK.text.secondary

        #expect(result.lightMode == .grey700)
        #expect(result.darkMode == .grey300)
    }

    @Test
    func link_returnsExpectedResult() {
        let result = UIColor.govUK.text.link

        #expect(result.lightMode == .primaryBlue)
        #expect(result.darkMode == .accentBlue)
    }

    @Test
    func buttonPrimary_returnsExpectedResult() {
        let result = UIColor.govUK.text.buttonPrimary

        #expect(result.lightMode == .white)
        #expect(result.darkMode == .black)
    }

    @Test
    func buttonPrimaryFocussed_returnsExpectedResult() {
        let result = UIColor.govUK.text.buttonPrimaryFocussed

        #expect(result.lightMode == .black)
        #expect(result.darkMode == .black)
    }

    @Test
    func buttonPrimaryDisabled_returnsExpectedResult() {
        let result = UIColor.govUK.text.buttonPrimaryDisabled

        #expect(result.lightMode == .grey600)
        #expect(result.darkMode == .black)
    }

    @Test
    func buttonSecondary_returnsExpectedResult() {
        let result = UIColor.govUK.text.buttonSecondary

        #expect(result.lightMode == .primaryBlue)
        #expect(result.darkMode == .accentBlue)
    }

    @Test
    func buttonSecondaryHighlight_returnsExpectedResult() {
        let result = UIColor.govUK.text.buttonSecondaryHighlight

        #expect(result.lightMode == .blueDarker50)
        #expect(result.darkMode == .blueLighter25)
    }

    @Test
    func buttonSecondaryFocussed_returnsExpectedResult() {
        let result = UIColor.govUK.text.buttonSecondaryFocussed

        #expect(result.lightMode == .black)
        #expect(result.darkMode == .black)
    }

    @Test
    func buttonSecondaryDisabled_returnsExpectedResult() {
        let result = UIColor.govUK.text.buttonSecondaryDisabled

        #expect(result.lightMode == .grey700)
        #expect(result.darkMode == .grey300)
    }

    @Test
    func buttonCompact_returnsExpectedResult() {
        let result = UIColor.govUK.text.buttonCompact

        #expect(result.lightMode == .primaryBlue)
        #expect(result.darkMode == .accentBlue)
    }

    @Test
    func buttonCompactHighlight_returnsExpectedResult() {
        let result = UIColor.govUK.text.buttonCompactHighlight

        #expect(result.lightMode == .blueDarker50)
        #expect(result.darkMode == .blueLighter25)
    }

    @Test
    func buttonCompactFocussed_returnsExpectedResult() {
        let result = UIColor.govUK.text.buttonCompactFocussed

        #expect(result.lightMode == .black)
        #expect(result.darkMode == .black)
    }

    @Test
    func buttonCompactDisabled_returnsExpectedResult() {
        let result = UIColor.govUK.text.buttonCompactDisabled

        #expect(result.lightMode == .grey600)
        #expect(result.darkMode == .black)
    }

    @Test
    func buttonDestructive_returnsExpectedResult() {
        let result = UIColor.govUK.text.buttonDestructive

        #expect(result.lightMode == .primaryRed)
        #expect(result.darkMode == .accentRed)
    }

    @Test
    func buttonSuccess_returnsExpectedResult() {
        let result = UIColor.govUK.Text.buttonSuccess

        #expect(result.lightMode == .primaryGreen)
        #expect(result.darkMode == .accentGreen)
    }

    @Test
    func linkHeader_returnsExpectedResult() {
        let result = UIColor.govUK.text.linkHeader

        #expect(result.lightMode == .white)
        #expect(result.darkMode == .accentBlue)
    }

    @Test
    func header_returnsExpectedResult() {
        let result = UIColor.govUK.text.header

        #expect(result.lightMode == .white)
        #expect(result.darkMode == .white)
    }

    @Test
    func trailingIcon_returnsExpectedResult() {
        let result = UIColor.govUK.text.trailingIcon

        #expect(result.lightMode == .primaryBlue)
        #expect(result.darkMode == .blueLighter95)
    }
}
