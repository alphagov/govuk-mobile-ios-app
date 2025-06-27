import SwiftUI

extension Font {
    public static var govUK: GOVUKFontBuilder {
        GOVUKFontBuilder()
    }
}

public struct GOVUKFontBuilder {
    public let largeTitle: Font = .largeTitle
    public let largeTitleBold: Font = .largeTitle.weight(.bold)

    public let title1: Font = .title
    public let title1Bold: Font = .title.weight(.bold)

    public let title2: Font = .title2
    public let title2Bold: Font = .title2.weight(.bold)

    public let title3: Font = .title3
    public let title3Semibold: Font = .title3.weight(.semibold)

    public let headlineSemibold: Font = .headline.weight(.semibold)
    public let headlineSemiboldItalic: Font = .headline.weight(.semibold).italic()

    public let body: Font = .body
    public let bodyItalic: Font = .body.italic()
    public let bodySemibold: Font = .body.weight(.semibold)
    public let bodySemiboldItalic: Font = .body.weight(.semibold).italic()

    public let callout: Font = .callout
    public let calloutItalic: Font = .callout.italic()
    public let calloutSemibold: Font = .callout.weight(.semibold)
    public let calloutSemiboldItalic: Font = .callout.weight(.semibold).italic()

    public let subheadline: Font = .subheadline
    public let subheadlineItalic: Font = .subheadline.italic()
    public let subheadlineSemibold: Font = .subheadline.weight(.semibold)
    public let subheadlineSemiboldItalic: Font = .subheadline.weight(.semibold).italic()

    public let footnote: Font = .footnote
    public let footnoteItalic: Font = .footnote.italic()
    public let footnoteSemibold: Font = .footnote.weight(.semibold)
    public let footnoteSemiboldItalic: Font = .footnote.weight(.semibold).italic()

    public let caption1: Font = .caption
    public let caption1Italic: Font = .caption.italic()
    public let caption1Medium: Font = .caption.weight(.medium)
    public let caption1MediumItalic: Font = .caption.weight(.medium).italic()

    public let caption2: Font = .caption2
    public let caption2Italic: Font = .caption2.italic()
    public let caption2Semibold: Font = .caption2.weight(.semibold)
    public let caption2SemiboldItalic: Font = .caption2.weight(.semibold).italic()
}
