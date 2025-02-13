import Foundation

struct Config: Decodable {
    let available: Bool
    let minimumVersion: String
    let recommendedVersion: String
    let releaseFlags: [String: Bool]
    let lastUpdated: String
    let searchApiUrl: String?
    let homeWidgets: [String]

    enum CodingKeys: CodingKey {
        case available
        case minimumVersion
        case recommendedVersion
        case releaseFlags
        case lastUpdated
        case searchApiUrl
        case homeWidgets
    }

    init(available: Bool,
         minimumVersion: String,
         recommendedVersion: String,
         releaseFlags: [String: Bool],
         lastUpdated: String,
         searchApiUrl: String?,
         homeWidgets: [String]) {
        self.available = available
        self.minimumVersion = minimumVersion
        self.recommendedVersion = recommendedVersion
        self.releaseFlags = releaseFlags
        self.lastUpdated = lastUpdated
        self.searchApiUrl = searchApiUrl
        self.homeWidgets = homeWidgets
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.available = try container.decode(Bool.self, forKey: .available)
        self.minimumVersion = try container.decode(String.self, forKey: .minimumVersion)
        self.recommendedVersion = try container.decode(String.self, forKey: .recommendedVersion)
        self.releaseFlags = try container.decode([String: Bool].self, forKey: .releaseFlags)
        self.lastUpdated = try container.decode(String.self, forKey: .lastUpdated)
        self.searchApiUrl = try container.decodeIfPresent(String.self, forKey: .searchApiUrl)
        self.homeWidgets = try container.decodeIfPresent([String].self,
                                                         forKey: .homeWidgets)
        ?? ["feedback",
            "search",
            "recentActivity",
            "testViewController",
            "testWeb",
            "topics"
        ]
    }
}
