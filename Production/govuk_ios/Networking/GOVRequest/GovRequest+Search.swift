import Foundation
import GOVKit

extension GOVRequest {
    static func search(term: String) -> GOVRequest {
        GOVRequest(
            urlPath: Constants.API.defaultSearchPath,
            method: .get,
            bodyParameters: nil,
            queryParameters: ["q": term, "count": "10"],
            additionalHeaders: nil
        )
    }
}
