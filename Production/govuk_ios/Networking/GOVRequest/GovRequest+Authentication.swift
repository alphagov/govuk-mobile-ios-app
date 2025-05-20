import Foundation
import GOVKit

extension GOVRequest {
    static func revoke(_ token: String,
                       clientId: String) -> GOVRequest {
        GOVRequest(
            urlPath: "/oauth2/revoke",
            method: .post,
            bodyParameters: ["token": token,
                            "client_id": clientId],
            queryParameters: nil,
            additionalHeaders: ["Content-Type": "application/x-www-form-urlencoded"]
        )
    }
}
