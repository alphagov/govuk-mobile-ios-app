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
        .init(
            family: "GDSTransportWebsite",
            size: 70,
            traits: .init(rawValue: 0)
        )
    }

    static var body: GovUKFont {
        .init(
            family: "GDSTransportWebsite",
            size: 16,
            traits: .init(rawValue: 0)
        )
    }
}
