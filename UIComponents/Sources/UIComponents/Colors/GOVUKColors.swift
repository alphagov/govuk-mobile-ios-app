import Foundation
import UIKit

extension UIColor {
    public static var govUK: GOVUKColors.Type { GOVUKColors.self }
}

public struct GOVUKColors {
    public static var text: Text.Type { Text.self }
    public static var fills: Fills.Type { Fills.self }
    public static var strokes: Strokes.Type { Strokes.self }
}
