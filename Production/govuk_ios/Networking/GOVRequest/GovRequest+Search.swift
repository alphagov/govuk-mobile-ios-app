import Foundation

extension GOVRequest {
    static func search(term: String) -> GOVRequest {
        GOVRequest(
            urlPath: "/api/search.json",
            method: .get,
            bodyParameters: nil,
            queryParameters: ["q": term, "count": "10"],
            additionalHeaders: nil
        )
    }
}
