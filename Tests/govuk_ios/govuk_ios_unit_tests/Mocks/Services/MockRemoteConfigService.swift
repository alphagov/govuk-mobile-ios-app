@testable import govuk_ios

class MockRemoteConfigService: RemoteConfigServiceInterface {
    
    var _stubbedRemoteConfigValues: [String: Any] = [:]

    var _fetchCallCount = 0
    func fetch() async -> RemoteConfigFetchResult {
        _fetchCallCount += 1
        return .success
    }

    var _activateCompletionBlock: (() -> Void)?
    var _activateCallCount = 0
    func activate() async {
        _activateCallCount += 1
        _activateCompletionBlock?()
    }
    
    func string(forKey key: RemoteConfigKey, defaultValue: String) -> String {
        if let remoteString = _stubbedRemoteConfigValues[key.rawValue] as? String {
            return remoteString
        }
        return defaultValue
    }
    
    func bool(forKey key: RemoteConfigKey, defaultValue: Bool) -> Bool {
        if let remoteBool = _stubbedRemoteConfigValues[key.rawValue] as? Bool {
            return remoteBool
        }
        return defaultValue
    }
    
    func int(forKey key: RemoteConfigKey, defaultValue: Int) -> Int {
        if let remoteInt = _stubbedRemoteConfigValues[key.rawValue] as? Int {
            return remoteInt
        }
        return defaultValue
    }
    
    func double(forKey key: RemoteConfigKey, defaultValue: Double) -> Double {
        if let remoteDouble = _stubbedRemoteConfigValues[key.rawValue] as? Double {
            return remoteDouble
        }
        return defaultValue
    }
    
    
}

