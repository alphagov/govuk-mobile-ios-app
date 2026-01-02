import Foundation
@testable import govuk_ios

enum MockRemoteConfigError: Error {
    case generic
}

class MockRemoteConfigServiceClient: RemoteConfigServiceClientInterface {
    
    var _stubbedRemoteConfigValues: [String: Any] = [:]

    var _fetchCallCount = 0
    var _stubbedFetchError: Error?
    func fetch() async throws {
        _fetchCallCount += 1

        if let fetchError = _stubbedFetchError {
            throw fetchError
        }
    }

    var _activateCallCount = 0
    var _stubbedActivateError: Error?
    func activate() async throws {
        _activateCallCount += 1

        if let activateError = _stubbedActivateError {
            throw activateError
        }
    }

    func string(forKey key: String) -> String? {
        _stubbedRemoteConfigValues[key] as? String
    }

    func bool(forKey key: String) -> Bool? {
        _stubbedRemoteConfigValues[key] as? Bool
    }

    func int(forKey key: String) -> Int? {
        _stubbedRemoteConfigValues[key] as? Int
    }

    func double(forKey key: String) -> Double? {
        _stubbedRemoteConfigValues[key] as? Double
    }
    
}
