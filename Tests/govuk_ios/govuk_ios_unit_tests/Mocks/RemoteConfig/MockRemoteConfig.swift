@testable import govuk_ios

class MockRemoteConfig: RemoteConfigInterface {

    var _stubbedRemoteConfigValues = [String: RemoteConfigValueInterface]()

    var _fetchCallCount: Int = 0
    var _stubbedFetchError: Error?
    func fetchConfig() async throws {
        _fetchCallCount += 1
        if let error = _stubbedFetchError {
            throw error
        }
    }

    var _activateCallCount: Int = 0
    var _stubbedActivateError: Error?
    func activateConfig() async throws {
        _activateCallCount += 1
        if let error = _stubbedActivateError {
            throw error
        }
    }

    func configValue(forKey key: String) -> RemoteConfigValueInterface {
        _stubbedRemoteConfigValues[key] ?? MockRemoteConfigValue()
    }

}
