import Testing

@testable import govuk_ios

@Suite
struct RemoteConfigServiceClientTests {

    private var sut: RemoteConfigServiceClient!
    private var mockRemoteConfig: MockRemoteConfig!

    init() {
        mockRemoteConfig = MockRemoteConfig()
        sut = RemoteConfigServiceClient(remoteConfig: mockRemoteConfig)
    }

    @Test
    func fetch_callsRemoteConfigFetch() async throws {
        try await sut.fetch()
        #expect(mockRemoteConfig._fetchCallCount == 1)
    }

    @Test
    func fetch_throwsWhenRemoteConfigThrows() async {
        mockRemoteConfig._stubbedFetchError = MockRemoteConfigError.generic

        await #expect(throws: MockRemoteConfigError.generic) {
            try await sut.fetch()
        }
    }

    @Test
    func activate_callsRemoteConfigActivate() async throws {
        try await sut.activate()
        #expect(mockRemoteConfig._activateCallCount == 1)
    }

    @Test
    func activate_throwsWhenRemoteConfigThrows() async {
        mockRemoteConfig._stubbedActivateError = MockRemoteConfigError.generic

        await #expect(throws: MockRemoteConfigError.generic) {
            try await sut.activate()
        }

    }

    @Test
    func string_returnsValue_forRemoteSource() {
        mockRemoteConfig._stubbedRemoteConfigValues = [
            "test_key": MockRemoteConfigValue(stringValue: "stringValue",
                                         isSourceStatic: false)
        ]
        #expect(sut.string(forKey: "test_key") == "stringValue")
    }

    @Test
    func string_returnsNil_forStaticSource() {
        mockRemoteConfig._stubbedRemoteConfigValues = [
            "test_key": MockRemoteConfigValue(stringValue: "stringValue",
                                             isSourceStatic: true)
        ]
        #expect(sut.string(forKey: "test_key") == nil)
    }

    @Test
    func bool_returnsExpectedValue() {
        mockRemoteConfig._stubbedRemoteConfigValues = [
            "test_key": MockRemoteConfigValue(boolValue: true,
                                              isSourceStatic: false)
        ]
        #expect(sut.bool(forKey: "test_key") == true)
    }

    @Test
    func int_returnsExpectedValue() {
        mockRemoteConfig._stubbedRemoteConfigValues = [
            "test_key": MockRemoteConfigValue(numberValue: 1,
                                             isSourceStatic: false)
        ]
        #expect(sut.int(forKey: "test_key") == 1)
    }

    @Test
    func double_returnsExpectedValue() {
        mockRemoteConfig._stubbedRemoteConfigValues = [
            "test_key": MockRemoteConfigValue(numberValue: 30.2, isSourceStatic: false)
        ]
        #expect(sut.double(forKey: "test_key") == 30.2)
    }
}

