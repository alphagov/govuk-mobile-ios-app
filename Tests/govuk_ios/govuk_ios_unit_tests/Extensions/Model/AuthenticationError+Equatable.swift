import Foundation

@testable import govuk_ios

extension AuthenticationError: @retroactive Equatable {
    public static func == (lhs: AuthenticationError, rhs: AuthenticationError) -> Bool {
        switch (lhs, rhs) {
        case (.loginFlow(let lhsError), .loginFlow(let rhsError)):
            return lhsError == rhsError
        case (.returningUserService(let lhsError), .returningUserService(let rhsError)):
                return lhsError == rhsError
        case (.attestation(let lhsError), .attestation(let rhsError)):
            return lhsError == rhsError
        case (.unknown(let lhsError), .unknown(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
