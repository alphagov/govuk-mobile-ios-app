import UIKit
import Foundation

extension UIFont {
    static var govuk: GovUKFont.Type {
        GovUKFont.self
    }
}

struct GovUKFont {
    let family: String
    let size: CGFloat
    let traits: UIFontDescriptor.SymbolicTraits

    var scaled: UIFont {
        var mutableTraits = traits
        if UIAccessibility.isBoldTextEnabled {
            mutableTraits.insert(.traitBold)
        }
        let descriptor = baseDescriptor.withSymbolicTraits(mutableTraits)!

        let font = UIFont(
            descriptor: descriptor,
            size: descriptor.pointSize
        )
        return UIFontMetrics.default
            .scaledFont(
                for: font
            )
    }

    private var baseDescriptor: UIFontDescriptor {
        UIFontDescriptor(
            name: family,
            size: size
        )
    }
}

extension GovUKFont {
    static var header1: GovUKFont {
        .init(
            family: "F1",
            size: 30,
            traits: .init(rawValue: 0)
        )
    }

    static var body: GovUKFont {
        .init(
            family: "F1",
            size: 16,
            traits: .init(rawValue: 0)
        )
    }

    static var small: GovUKFont {
        .init(
            family: "F1",
            size: 14,
            traits: .init(rawValue: 0)
        )
    }

    static var micro: GovUKFont {
        .init(
            family: "F1",
            size: 12,
            traits: .init(rawValue: 0)
        )
    }

    static var nano: GovUKFont {
        .init(
            family: "F1",
            size: 8,
            traits: .init(rawValue: 0)
        )
    }
}
