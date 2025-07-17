import Foundation
import GOVKit

struct Answer: Codable {
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id
        case message
        case sources
    }

    let createdAt: String?
    let id: String?
    let message: String?
    let sources: [Source]?

    var answerAvailable: Bool {
        id != nil
    }
}

struct Source: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case url
    }

    let title: String
    let url: String
    var urlWithFallback: URL {
        URL(string: url) ?? Constants.API.govukBaseUrl
    }
}
