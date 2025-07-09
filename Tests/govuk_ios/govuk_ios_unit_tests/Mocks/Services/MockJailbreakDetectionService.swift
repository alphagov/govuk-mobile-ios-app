import Foundation

@testable import govuk_ios

final class MockJailbreakDetectionService: JailbreakDetectionServiceInterface {
    var _stubbedIsJailbroken: Bool = false
    func isJailbroken() -> Bool {
        return _stubbedIsJailbroken
    }
}
