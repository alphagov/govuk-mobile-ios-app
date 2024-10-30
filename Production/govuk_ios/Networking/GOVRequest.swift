import Foundation

struct GOVRequest {
    let urlPath: String
    let method: Method
    let bodyParameters: [String: Any]?
    let queryParameters: [String: String?]?
    let additionalHeaders: [String: String]?
    var requiresSignature: Bool = false
}

enum Method: String {
    case get
    case post
    case delete
    case put
    case patch
}
