import Foundation

extension GOVRequest {
    static func search(term: String,
                       searchApiUrlPath: String) -> GOVRequest {
        GOVRequest(
            urlPath: searchApiUrlPath,
            method: .get,
            bodyParameters: nil,
            queryParameters: ["q": term, "count": "10"],
            additionalHeaders: nil
        )
    }
}
