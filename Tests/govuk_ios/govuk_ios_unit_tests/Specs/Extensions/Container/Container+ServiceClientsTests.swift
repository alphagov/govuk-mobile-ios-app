import Foundation
import Testing

import FactoryKit

@testable import govuk_ios

@Suite
struct Container_ServiceClientsTests {

    @Test
    func authenticationServiceClient_returnsExpectedValue() {
        let container = Container()
        container.appEnvironmentService.register { MockAppEnvironmentService() }
        container.revokeTokenAPIClient.register { MockAPIServiceClient() }
        container.appAttestService.register { MockAppAttestService() }

        let sut = container.authenticationServiceClient.resolve()
        #expect(sut is AuthenticationServiceClient)
    }

    @Test
    func remoteConfigServiceClient_returnsExpectedValue() {
        let container = Container()
        container.remoteConfig.register {
            MockRemoteConfig()
        }

        let sut = container.remoteConfigServiceClient.resolve()
        #expect(sut is RemoteConfigServiceClient)
    }

}
