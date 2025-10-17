import Foundation
import Testing

@testable import govuk_ios

@Suite
struct ReturingUserServiceErrorTests {

    @Test(arguments: zip(
        [
            ReturningUserServiceError.missingIdentifierError,
            ReturningUserServiceError.coreDataDeletionError,
            ReturningUserServiceError.saveIdentifierError,
        ],
        [
            "3.0.1",
            "3.0.2",
            "3.0.3",
        ]
    ))
    func govukErrorCode_returnsExpectedCode(error: ReturningUserServiceError,
                                            expectedCode: String) {
        #expect(error.govukErrorCode == expectedCode)
    }
}
