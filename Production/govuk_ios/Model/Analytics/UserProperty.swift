import Foundation

struct UserProperty {
    let key: String
    let value: String?
}

extension UserProperty {
    static var topicsCustomised: UserProperty {
        .init(
            key: "topics_customised",
            value: "true"
        )
    }
}
