import Foundation

extension URLResponse {
    var signature: String? {
        (self as? HTTPURLResponse)?
            .allHeaderFields["x-amz-meta-govuk-sig"] as? String
    }
}
