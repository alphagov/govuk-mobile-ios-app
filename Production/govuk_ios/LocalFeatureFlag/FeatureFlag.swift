import Foundation

struct FeatureFlag {
    let feature: Feature
    let enabled: Bool
}

extension FeatureFlag: Decodable {
    enum CodingKeys: String, CodingKey {
        case feature
        case enabled
    }
}

 struct Feature: Equatable {
    let name: String
}
extension Feature: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
    }
}

extension Feature {
    static let addCategory = Feature(name: "addCategory")
}
