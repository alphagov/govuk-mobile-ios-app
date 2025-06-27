import Foundation
import UIKit
import Testing

@testable import UIComponents

@Suite
@MainActor
final class UIButtonExtensionsTests: NSObject {
    var sut: UIButton!
    var action: UIAction!

    override init() {
        self.sut = UIButton()
        self.action = UIAction(handler: { _ in })
        super.init()
    }

    @Test
    func removeAllActions_withUIAction_removesAction() {
        #expect(sut.allControlEvents.isEmpty)
        sut.addAction(action, for: .touchUpInside)
        #expect(!sut.allControlEvents.isEmpty)

        sut.removeAllActions()
        #expect(sut.allControlEvents.isEmpty)
    }

    @Test
    func removeAllActions_withTargetAction_removesAction() {
        #expect(sut.allControlEvents.isEmpty)
        sut.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        #expect(!sut.allControlEvents.isEmpty)

        sut.removeAllActions()
        #expect(sut.allControlEvents.isEmpty)
    }


    @objc func buttonAction() {
        // no implementation
    }
}
