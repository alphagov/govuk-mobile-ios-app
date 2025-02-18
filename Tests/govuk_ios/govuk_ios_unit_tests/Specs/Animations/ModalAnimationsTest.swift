import Testing

@testable import govuk_ios

@Suite
struct ModalAnimationsTest {

    @Test
    func returnAnimation_returnsCorrectAnimation() async throws {
        let sut = ModalAnimations.fadeAnimation
        guard let animation = sut.returnAnimation as? FadeAnimation
        else { return }
        #expect(animation != nil)
    }

}
