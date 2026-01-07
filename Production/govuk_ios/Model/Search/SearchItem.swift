import Foundation
import GOVKit

struct SearchItem: Codable,
                   Hashable {
    let title: String
    var description: String?
    var descriptionWithHighlighting: String?
    let contentId: String?
    let link: URL

    enum CodingKeys: String,
                     CodingKey {
        case title
        case description
        case descriptionWithHighlighting = "description_with_highlighting"
        case contentId = "content_id"
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
        let descWithHighlighting = try container.decodeIfPresent(
            String.self, forKey: .descriptionWithHighlighting
        )
        let desc = try container.decodeIfPresent(String.self, forKey: .description)

        self.init(
            title: try container.decode(String.self, forKey: .title),
            description: descWithHighlighting ?? desc,
            contentId: try container.decodeIfPresent(String.self, forKey: .contentId),
            link: url
        )
    }

    init(title: String,
         description: String?,
         contentId: String?,
         link: URL) {
        self.title = title
        self.description = description
        self.contentId = contentId
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
