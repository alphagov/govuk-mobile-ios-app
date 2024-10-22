import Foundation

extension GOVRequest {
    static func search(term: String) -> GOVRequest {
        GOVRequest(
            urlPath: "/v0_1/search.json",
            method: .get,
            bodyParameters: nil,
            queryParameters: ["q": term, "count": "10"],
            additionalHeaders: nil
        )
    }
}
