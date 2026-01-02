import Foundation
@testable import govuk_ios

enum MockRemoteConfigError: Error {
    case generic
}

class MockRemoteConfigServiceClient: RemoteConfigServiceClientInterface {
    
    var _stubbedRemoteConfigValues: [String: Any] = [:]
    var _fetchError: Error?
    var _activateError: Error?
    
    private var fetchedValues: [String: Any] = [:]
    private var activatedValues: [String: Any] = [:]
    
    var fetchCallCount = 0
    var activateCallCount = 0
    
    func fetch() async throws {
        fetchCallCount += 1
        
        if let fetchError = _fetchError {
            throw fetchError
        }
        fetchedValues = _stubbedRemoteConfigValues
    }
    
    func activate() async throws {
        activateCallCount += 1
        
        if let activateError = _activateError {
            throw activateError
        }
        activatedValues = fetchedValues
    }
    
    func string(forKey key: String) -> String? {
        return activatedValues[key] as? String
    }
    
    func bool(forKey key: String) -> Bool? {
        return activatedValues[key] as? Bool
    }
    
    func int(forKey key: String) -> Int? {
        return activatedValues[key] as? Int
    }
    
    func double(forKey key: String) -> Double? {
        return activatedValues[key] as? Double
    }
    
}
