import Testing

@testable import govuk_ios

@Suite
class InactivityCoordinatorTests {
    @Test
    func start_callsStartMonitoring_callsInactiveAction() async {
        let mockInactivityService = MockInactivityService()
        let mockNavigationController = await MockNavigationController()
        await confirmation() { confirmation in
            let coordinator = await InactivityCoordinator(
                navigationController: mockNavigationController,
                inactivityService: mockInactivityService,
                inactiveAction: {
                    confirmation()
                }
            )
            await coordinator.start(url: nil)
            #expect(mockInactivityService._stubbedStartMonitoringCalled)
            mockInactivityService.simulateInactivity()
        }
    }
}
