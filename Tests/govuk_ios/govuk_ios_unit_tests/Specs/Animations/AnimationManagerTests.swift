import Testing
import Factory

@testable import govuk_ios

@Suite
class AnimationManagerTests {

    private var mockAccessibilityManager: MockAccessibilityManager!

    init() {
        mockAccessibilityManager = MockAccessibilityManager()
        Container.shared.accessibilityManager.register(
            factory: {
                self.mockAccessibilityManager
            }
        )
    }

    @Test
    func test_animationsEnabled_callsAnimates() async throws {
        let sut = AnimationsManager()
        mockAccessibilityManager.animationsEnabled = true

        var called = false
        sut.animate(
            withDuration: 0.0,
            animations: { },
            completion: { _ in
                called = true
            }
        )
        #expect(called == false)
    }

    @MainActor
    func animationsEnabled_doesNotCallAnimate() async {
        let sut = AnimationsManager()
        mockAccessibilityManager.animationsEnabled = false

        var called = false
        sut.animate(
            withDuration: 0.0,
            animations: { },
            completion: { _ in
                called = true
            }
        )
        #expect(called == true)
    }
}
