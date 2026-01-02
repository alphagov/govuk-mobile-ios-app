import Foundation
import Testing

@testable import govuk_ios

@Suite
struct RemoteConfigServiceTests {
    private var sut: RemoteConfigService!
    private var mockRemoteConfigServiceClient: MockRemoteConfigServiceClient!
    private var mockAnalyticsService: MockAnalyticsService!
    
    init() {
        mockRemoteConfigServiceClient = MockRemoteConfigServiceClient()
        mockAnalyticsService = MockAnalyticsService()
        sut = RemoteConfigService(
            remoteConfigServiceClient: mockRemoteConfigServiceClient,
            analyticsService: mockAnalyticsService
        )
    }
    
    @Test
    func stringForKey_whenFetchedAndActivated_withValidKey_returnsExpectedValue() async throws {
        mockRemoteConfigServiceClient._stubbedRemoteConfigValues = ["test_key": "testStringValue"]
        
        let _ = await sut.fetch()
        await sut.activate()
        
        let result = sut.string(forKey: .testKey, defaultValue: "defaultStringValue")
        
        #expect(result == "testStringValue")

        #expect(mockRemoteConfigServiceClient._fetchCallCount == 1)
        #expect(mockRemoteConfigServiceClient._activateCallCount == 1)
    }

    @Test
    func stringForKey_whenFetchedAndActivated_withInvalidKey_returnsDefaultValue() async throws {
        mockRemoteConfigServiceClient._stubbedRemoteConfigValues = ["test_key_1" : "testStringValue"]
        
        let _ = await sut.fetch()
        await sut.activate()
        
        let result = sut.string(forKey: .testKey, defaultValue: "defaultStringValue")
        #expect(result == "defaultStringValue")
    }
    
    @Test
    func boolForKey_whenFetchedAndActivated_withValidKey_returnsExpectedValue() async throws {
        mockRemoteConfigServiceClient._stubbedRemoteConfigValues = ["test_key": true]
        
        let _ = await sut.fetch()
        await sut.activate()
        
        let result = sut.bool(forKey: .testKey, defaultValue: false)
        #expect(result == true)
    }
    
    @Test
    func intForKey_whenFetchedAndActivated_withValidKey_returnsExpectedValue() async throws {
        mockRemoteConfigServiceClient._stubbedRemoteConfigValues = ["test_key": 3]
        
        let _ = await sut.fetch()
        await sut.activate()
        
        let result = sut.int(forKey: .testKey, defaultValue: 5)
        #expect(result == 3)
    }
    
    @Test
    func doubleForKey_whenFetchedAndActivated_withValidKey_returnsExpectedValue() async throws {
        mockRemoteConfigServiceClient._stubbedRemoteConfigValues = ["test_key": 10.0]
        
        let _ = await sut.fetch()
        await sut.activate()
        
        let result = sut.double(forKey: .testKey, defaultValue: 30.0)
        #expect(result == 10.0)
    }

    @Test
    func fetch_success_returnsExpectedResult() async {
        let result = await sut.fetch()
        var wasSuccessful: Bool
        switch result {
        case .success:
            wasSuccessful = true
        case .failure(_):
            wasSuccessful = false
        }
        #expect(wasSuccessful)
    }

    @Test
    func fetch_whenFails_returnsExpectedResult() async {
        mockRemoteConfigServiceClient._stubbedFetchError = MockRemoteConfigError.generic
        let result = await sut.fetch()

        var returnedError: Error?
        switch result {
        case .failure(let error):
            returnedError = error
        default:
            break
        }
        #expect(returnedError as? MockRemoteConfigError == .generic)

    }

    @Test
    func fetch_whenFails_tracksErrorInAnalytics() async throws {
        mockRemoteConfigServiceClient._stubbedFetchError = MockRemoteConfigError.generic

        let _ = await sut.fetch()
        
        #expect(mockAnalyticsService._trackErrorReceivedErrors.count == 1)
        #expect(mockAnalyticsService._trackErrorReceivedErrors.first as? MockRemoteConfigError == MockRemoteConfigError.generic)
    }
    
    @Test
    func activate_whenFails_tracksErrorInAnalytics() async throws {
        mockRemoteConfigServiceClient._stubbedActivateError = MockRemoteConfigError.generic

        await sut.activate()
        
        #expect(mockAnalyticsService._trackErrorReceivedErrors.count == 1)
        #expect(mockAnalyticsService._trackErrorReceivedErrors.first as? MockRemoteConfigError == .generic)
    }
}

