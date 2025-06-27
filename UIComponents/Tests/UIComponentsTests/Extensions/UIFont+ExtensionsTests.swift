import Foundation
import UIKit
import Testing

@testable import UIComponents

@Suite
@MainActor
struct UIFontExtensionsTests {
    // MARK: LARGE TITLE
    @Test
    func largeTitle_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.largeTitle
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 34)
        assertFontWeight(font: font, weight: .regular)
    }

    @Test
    func largeTitleBold_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.largeTitleBold
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 34)
        assertFontWeight(font: font, weight: .bold)
    }

    // MARK: TITLE 1
    @Test
    func title1_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.title1
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 28)
        assertFontWeight(font: font, weight: .regular)
    }

    @Test
    func title1Bold_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.title1Bold
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 28)
        assertFontWeight(font: font, weight: .bold)
    }

    // MARK: TITLE 2
    @Test
    func title2_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.title2
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 22)
        assertFontWeight(font: font, weight: .regular)
    }

    @Test
    func title2Bold_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.title2Bold
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 22)
        assertFontWeight(font: font, weight: .bold)
    }

    // MARK: TITLE 3
    @Test
    func title3_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.title3
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 20)
        assertFontWeight(font: font, weight: .regular)
    }

    @Test
    func title3Semibold_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.title3Semibold
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 20)
        assertFontWeight(font: font, weight: .semibold)
    }

    // MARK: HEADLINE
    @Test
    func headlineSemibold_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.headlineSemibold
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 17)
        assertFontWeight(font: font, weight: .semibold)
    }

    // MARK: BODY
    @Test
   func bodySemibold_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.bodySemibold
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 17)
        assertFontWeight(font: font, weight: .semibold)
    }

    @Test
   func body_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.body
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 17)
        assertFontWeight(font: font, weight: .regular)
    }

    @Test
    func bodyItalic_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.bodyItalic
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 17)
    }

    // MARK: CALLOUT
    @Test
    func calloutSemibold_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.calloutSemibold
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 16)
        assertFontWeight(font: font, weight: .semibold)
    }

    @Test
    func callout_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.callout
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 16)
        assertFontWeight(font: font, weight: .regular)
    }

    @Test
    func calloutItalic_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.calloutItalic
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 16)
    }

    // MARK: SUBHEADLINE
    @Test
    func subheadlineSemibold_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.subheadlineSemibold
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 15)
        assertFontWeight(font: font, weight: .semibold)
    }

    @Test
    func subheadline_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.subheadline
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 15)
        assertFontWeight(font: font, weight: .regular)
    }

    @Test
    func subheadlineItalic_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.subheadlineItalic
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 15)
    }

    // MARK: FOOTNOTE
    @Test
    func footnote_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.footnote
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 13)
        assertFontWeight(font: font, weight: .regular)
    }

    @Test
    func footnoteItalic_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.footnoteItalic
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 13)
    }

    @Test
    func footnoteSemibold_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.footnoteSemibold
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 13)
        assertFontWeight(font: font, weight: .semibold)
    }

    // MARK: CAPTION 1
    @Test
    func caption1Medium_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.caption1Medium
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 12)
        assertFontWeight(font: font, weight: .medium)
    }

    @Test
    func caption1_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.caption1
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 12)
        assertFontWeight(font: font, weight: .regular)
    }

    @Test
    func caption1Italic_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.caption1Italic
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 12)
    }

    // MARK: CAPTION 2
    @Test
    func caption2Semibold_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.caption2Semibold
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 11)
        assertFontWeight(font: font, weight: .semibold)
    }

    @Test
    func caption2_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.caption2
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 11)
        assertFontWeight(font: font, weight: .regular)
    }

    @Test
    func caption2Italic_hasCorrectSizeAndFont() {
        let font = UIFont.govUK.caption2Italic
        #expect(font.familyName == ".AppleSystemUIFont")
        assertFontSize(font: font, size: 11)
    }

    func assertFontSize(font: UIFont, 
                        size: CGFloat,
                        sourceLocation: Testing.SourceLocation = #_sourceLocation) {
        let contentSize = UIScreen.main.traitCollection.preferredContentSizeCategory

        if contentSize == .large {
            #expect(font.pointSize == size, sourceLocation: sourceLocation)
        } else {
            print("\(UIScreen.main.traitCollection.preferredContentSizeCategory.rawValue) is wrong dynamic type scale for font unit tests. Should use the default (large)")
        }
    }

    // this test method does not work for italic fonts because applying
    // italic trait removes font weight from the font
    func assertFontWeight(font: UIFont,
                          weight: UIFont.Weight,
                          sourceLocation: Testing.SourceLocation = #_sourceLocation) {
        let traits = font.fontDescriptor.fontAttributes[.traits] as? [UIFontDescriptor.TraitKey: Any]
        let fontWeight = traits?[.weight] as? UIFont.Weight
        #expect(fontWeight == weight, sourceLocation: sourceLocation)
    }
}

