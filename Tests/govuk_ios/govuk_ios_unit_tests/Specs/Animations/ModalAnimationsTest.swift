import Testing

@testable import govuk_ios

@Suite
struct ModalAnimationsTest {

    @Test
    func returnAnimation_returnsCorrectAnimation() {
        let sut = ModalAnimation.fade
        let animation = sut.returnAnimation as? FadeAnimation
        #expect(animation != nil)
    }

}
