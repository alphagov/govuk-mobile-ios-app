import Foundation
import Authentication

extension LoginErrorV2 {
    var govukErrorCode: String {
        switch reason {
        case .userCancelled:
            return "2.1.1"
        case .programCancelled:
            return "2.1.2"
        case .network:
            return "2.1.3"
        case .generalServerError:
            return "2.1.4"
        case .safariOpenError:
            return "2.1.5"
        case .authorizationInvalidRequest:
            return "2.2.1"
        case .authorizationUnauthorizedClient:
            return "2.2.2"
        case .authorizationAccessDenied:
            return "2.2.3"
        case .authorizationUnsupportedResponseType:
            return "2.2.4"
        case .authorizationInvalidScope:
            return "2.2.5"
        case .authorizationServerError:
            return "2.2.6"
        case .authorizationTemporarilyUnavailable:
            return "2.2.7"
        case .authorizationClientError:
            return "2.2.8"
        case .authorizationUnknownError:
            return "2.2.9"
        case .invalidRedirectURL:
            return "2.3.1"
        case .tokenInvalidRequest:
            return "2.4.1"
        case .tokenUnauthorizedClient:
            return "2.4.2"
        case .tokenInvalidScope:
            return "2.4.3"
        case .tokenInvalidClient:
            return "2.4.4"
        case .tokenInvalidGrant:
            return "2.4.5"
        case .tokenUnsupportedGrantType:
            return "2.4.6"
        case .tokenClientError:
            return "2.4.7"
        case .tokenUnknownError:
            return "2.4.8"
        case .generic:
            return "2.5.1"
        }
    }
}
