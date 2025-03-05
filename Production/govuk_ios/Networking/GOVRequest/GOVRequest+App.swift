import Foundation
import GOVKit

extension GOVRequest {
    static var config: GOVRequest {
        GOVRequest(
            urlPath: "/config/appinfo/ios",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil,
            signingKey: Constants.SigningKey.govUK
        )
    }
}
