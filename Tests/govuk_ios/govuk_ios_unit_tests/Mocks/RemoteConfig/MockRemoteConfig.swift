@testable import govuk_ios

class MockRemoteConfig: RemoteConfigInterface {
    var _stubbedRemoteConfigValues = [String: RemoteConfigValueInterface]()
    var _fetchError: Error?
    var _activateError: Error?
    var _fetchCallCount: Int = 0
    var _activateCallCount: Int = 0
    func fetchConfig() async throws {
        _fetchCallCount += 1
        if let error = _fetchError {
            throw error
        }
    }

    func activateConfig() async throws {
        _activateCallCount += 1
        if let error = _activateError {
            throw error
        }
    }

    func configValue(forKey key: String) -> RemoteConfigValueInterface {
        _stubbedRemoteConfigValues[key] ?? MockRemoteConfigValue()
    }

}
