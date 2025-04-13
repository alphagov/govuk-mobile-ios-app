import Foundation
import GOVKit

extension GOVRequest {
    static func localAuthority(postcode: String) -> GOVRequest {
        GOVRequest(
            urlPath: Constants.API.localPath,
            method: .get,
            bodyParameters: nil,
            queryParameters: ["postcode": postcode],
            additionalHeaders: nil
        )
    }
}
