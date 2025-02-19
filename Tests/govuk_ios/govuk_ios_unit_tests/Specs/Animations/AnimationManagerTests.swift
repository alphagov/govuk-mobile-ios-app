import Testing
import Factory

@testable import govuk_ios

@Suite(.serialized)
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
    @MainActor
    func animate_whenAnimationsEnabled_callsAnimates() async throws {
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

    @Test
    @MainActor
    func animate_whenAnimationsDisabled_doesNotCallAnimate() async {
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
