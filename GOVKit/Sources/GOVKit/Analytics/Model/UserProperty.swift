import Foundation

public struct UserProperty {
    public let key: String
    public let value: String?

    public init(key: String,
                value: String?) {
        self.key = key
        self.value = value
    }
}
