import Foundation

public struct GOVUKButtonBuilder {
    public var primary: GOVUKButton {
        GOVUKButton(.primary)
    }

    public var secondary: GOVUKButton {
        GOVUKButton(.secondary)
    }

    public var compact: GOVUKButton {
        GOVUKButton(.compact)
    }
}
