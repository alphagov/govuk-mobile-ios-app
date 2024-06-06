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

    var font: UIFont {
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
        .transport(size: 70)
    }

    static var body: GovUKFont {
        .transport(size: 16)
    }

    static var largeNavigation: GovUKFont {
        .transport(size: 50)
    }

    static var tab: GovUKFont {
        .transport(size: 12)
    }

    private static func transport(size: CGFloat) -> GovUKFont {
        .init(
            family: "GDSTransportWebsite",
            size: size,
            traits: .init(rawValue: 0)
        )
    }
}
