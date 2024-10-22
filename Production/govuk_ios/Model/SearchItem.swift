import Foundation

struct SearchItem: Codable,
                   Hashable {
    let title: String
    let description: String
    let link: URL

    enum CodingKeys: String,
                     CodingKey {
        case title
        case description = "description_with_highlighting"
        case link
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let linkString = try container.decode(String.self, forKey: .link)
        guard let url = URL(searchLink: linkString)
        else {
            let context = DecodingError.Context(
                codingPath: [CodingKeys.link],
                debugDescription: "Could no create URL from given link: \(linkString)"
            )
            throw DecodingError.dataCorrupted(context)
        }
        self.init(
            title: try container.decode(String.self, forKey: .title),
            description: try container.decode(String.self, forKey: .description),
            link: url
        )
    }

    init(title: String,
         description: String,
         link: URL) {
        self.title = title
        self.description = description
        self.link = link
    }
}

private extension URL {
    init?(searchLink: String) {
        var components = URLComponents(string: searchLink)
        let scheme = components?.scheme
        components?.scheme = scheme ?? Constants.API.govukUrlScheme
        let host = components?.host
        components?.host = host ?? Constants.API.govukUrlHost
        guard let url = components?.url
        else { return nil }
        self = url
    }
}
