import Foundation
import Testing
import Authentication

@testable import govuk_ios

@Suite
struct LoginErrorV2_ExtensionsTests {

    @Test(arguments: zip(
        [
            LoginErrorReason.userCancelled,
            .programCancelled,
            .network,
            .generalServerError,
            .safariOpenError,
            .authorizationInvalidRequest,
            .authorizationUnauthorizedClient,
            .authorizationAccessDenied,
            .authorizationUnsupportedResponseType,
            .authorizationInvalidScope,
            .authorizationServerError,
            .authorizationTemporarilyUnavailable,
            .authorizationClientError,
            .authorizationUnknownError,
            .invalidRedirectURL,
            .tokenInvalidRequest,
            .tokenUnauthorizedClient,
            .tokenInvalidScope,
            .tokenInvalidClient,
            .tokenInvalidGrant,
            .tokenUnsupportedGrantType,
            .tokenClientError,
            .tokenUnknownError,
            .generic(description: "test123"),
        ],
        [
            "2.1.1",
            "2.1.2",
            "2.1.3",
            "2.1.4",
            "2.1.5",
            "2.2.1",
            "2.2.2",
            "2.2.3",
            "2.2.4",
            "2.2.5",
            "2.2.6",
            "2.2.7",
            "2.2.8",
            "2.2.9",
            "2.3.1",
            "2.4.1",
            "2.4.2",
            "2.4.3",
            "2.4.4",
            "2.4.5",
            "2.4.6",
            "2.4.7",
            "2.4.8",
            "2.5.1",
        ]
    ))
    func govukErrorCode_returnsExpectedCode(reason: LoginErrorReason,
                                            expectedCode: String) {
        let sut = LoginErrorV2(reason: reason)
        #expect(sut.govukErrorCode == expectedCode)
    }
}
