import Foundation
import SwiftUI
import Testing

@Suite
@MainActor
struct FontExtensionsTests {

    // MARK: LARGE TITLE
    @Test
    func largeTitle_exists() {
        #expect(Font.govUK.largeTitle != nil)
    }

    @Test
    func largeTitleBold_exists() {
        #expect(Font.govUK.largeTitleBold != nil)
    }

    // MARK: TITLE 1
    @Test
    func title1_exists() {
        #expect(Font.govUK.title1 != nil)
    }

    @Test
    func title1Bold_exists() {
        #expect(Font.govUK.title1Bold != nil)
    }

    // MARK: TITLE 2
    @Test
    func title2_exists() {
        #expect(Font.govUK.title2 != nil)
    }

    @Test
    func title2Bold_exists() {
        #expect(Font.govUK.title2Bold != nil)
    }

    // MARK: TITLE 3
    @Test
    func title3_exists() {
        #expect(Font.govUK.title3 != nil)
    }

    @Test
    func title3Semibold_exists() {
        #expect(Font.govUK.title3Semibold != nil)
    }

    // MARK: HEADLINE
    @Test
    func headlineSemibold_exists() {
        #expect(Font.govUK.headlineSemibold != nil)
    }

    @Test
    func headlineSemiboldItalic_exists() {
        #expect(Font.govUK.headlineSemiboldItalic != nil)
    }

    // MARK: BODY
    @Test
    func body_exists() {
        #expect(Font.govUK.body != nil)
    }

    @Test
    func bodyItalic_exists() {
        #expect(Font.govUK.bodyItalic != nil)
    }

    @Test
    func bodySemibold_exists() {
        #expect(Font.govUK.bodySemibold != nil)
    }

    @Test
    func bodySemiboldItalic_exists() {
        #expect(Font.govUK.bodySemiboldItalic != nil)
    }

    // MARK: CALLOUT
    @Test
    func callout_exists() {
        #expect(Font.govUK.callout != nil)
    }

    @Test
    func calloutItalic_exists() {
        #expect(Font.govUK.calloutItalic != nil)
    }

    @Test
    func calloutSemibold_exists() {
        #expect(Font.govUK.calloutSemibold != nil)
    }

    @Test
    func calloutSemiboldItalic_exists() {
        #expect(Font.govUK.calloutSemibold != nil)
    }

    // MARK: SUBHEADLINE
    @Test
    func subheadline_exists() {
        #expect(Font.govUK.subheadline != nil)
    }

    @Test
    func subheadlineItalic_exists() {
        #expect(Font.govUK.subheadlineItalic != nil)
    }

    @Test
    func subheadlineSemibold_exists() {
        #expect(Font.govUK.subheadlineSemibold != nil)
    }

    @Test
    func subheadlineSemiboldItalic_exists() {
        #expect(Font.govUK.subheadlineSemiboldItalic != nil)
    }

    // MARK: FOOTNOTE
    @Test
    func footnote_exists() {
        #expect(Font.govUK.footnote != nil)
    }

    @Test
    func footnoteItalic_exists() {
        #expect(Font.govUK.footnoteItalic != nil)
    }

    @Test
    func footnoteSemibold_exists() {
        #expect(Font.govUK.footnoteSemibold != nil)
    }

    @Test
    func footnoteSemiboldItalic_exists() {
        #expect(Font.govUK.footnoteSemiboldItalic != nil)
    }

    // MARK: CAPTION 1
    @Test
    func caption1_exists() {
        #expect(Font.govUK.caption1 != nil)
    }

    @Test
    func caption1Italic_exists() {
        #expect(Font.govUK.caption1Italic != nil)
    }
    
    @Test
    func caption1Medium_exists() {
        #expect(Font.govUK.caption1Medium != nil)
    }

    @Test
    func caption1MediumItalic_exists() {
        #expect(Font.govUK.caption1MediumItalic != nil)
    }

    // MARK: CAPTION 2
    @Test
    func caption2_exists() {
        #expect(Font.govUK.caption2 != nil)
    }

    @Test
    func caption2Italic_exists() {
        #expect(Font.govUK.caption2Italic != nil)
    }

    @Test
    func caption2Semibold_exists() {
        #expect(Font.govUK.caption2Semibold != nil)
    }

    @Test
    func caption2SemiboldItalic_exists() {
        #expect(Font.govUK.caption2SemiboldItalic != nil)
    }
}

