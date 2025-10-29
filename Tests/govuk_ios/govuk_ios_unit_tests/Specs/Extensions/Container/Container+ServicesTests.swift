import Foundation
import Testing

import Factory

@testable import govuk_ios

@Suite
struct Container_ServicesTests {
    @Test
    func analyticsService_returnsExpectedValue() async {
        let container = Container()
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsSignedIn = false
        container.authenticationService.register { mockAuthenticationService }
        let mockFirebaseClient = MockAnalyticsClient()
        container.firebaseClient.register { mockFirebaseClient }
        container.crashlyticsClient.register { MockAnalyticsClient() }
        let mockUserDefaultsService = MockUserDefaultsService()
        container.userDefaultsService.register { mockUserDefaultsService }
        mockUserDefaultsService._stub(value: true, key: UserDefaultsKeys.acceptedAnalytics.rawValue)

        let sut = container.analyticsService.resolve()
        sut.track(event: .init(name: "test", params: nil))
        #expect(mockFirebaseClient._trackEventReceivedEvents.count == 0)
        container.authenticationService.reset()
    }

    @Test
    func authenticationService_returnsExpectedValue() {
        let container = Container()
        container.authenticationService.reset()
        container.authenticationServiceClient.register { MockAuthenticationServiceClient() }
        container.authenticatedSecureStoreService.register { MockSecureStoreService() }
        container.returningUserService.register { MockReturningUserService() }
        container.userDefaultsService.register { MockUserDefaultsService() }
        container.analyticsService.register { MockAnalyticsService() }
        container.appConfigService.register { MockAppConfigService() }

        let sut = container.authenticationService.resolve()
        #expect(sut is AuthenticationService)
    }

    @Test
    func firebaseClient_returnsExpectedValue() async {
        let container = Container()
        container.appAttestService.register { MockAppAttestService() }
        let client = container.firebaseClient.resolve()
        #expect(client is FirebaseClient)
    }

    @Test
    func crashlyticsClient_returnsExpectedValue() async {
        let container = Container()
        let client = container.crashlyticsClient.resolve()
        #expect(client is CrashlyticsClient)
    }
}
