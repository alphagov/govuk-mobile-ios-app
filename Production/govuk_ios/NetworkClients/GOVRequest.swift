import Foundation

struct GOVRequest {
    let urlPath: String
    let verb: Verb
    let data: Data?
    let parameters: [String: Any]?
    let queryParameters: [String: String?]?
    let additionalHeaders: [String: String]?
}

public enum Verb: String {
    case get
    case post
    case delete
    case put
}
