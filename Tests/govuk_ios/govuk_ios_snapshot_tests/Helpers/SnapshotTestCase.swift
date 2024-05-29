import UIKit

import iOSSnapshotTestCase

@testable import govuk_ios

class SnapshotTestCase: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
//        self.recordMode = true
    }

    func VerifySnapshotInWindow(_ viewController: UIViewController,
                                perPixelTolerance: CGFloat = 0,
                                overallTolerance: CGFloat = 0,
                                file: StaticString = #file, line: UInt = #line) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        wrapInWindow(navigationController)
        FBSnapshotVerifyViewController(
            navigationController,
            perPixelTolerance: perPixelTolerance,
            overallTolerance: overallTolerance,
            file: file,
            line: line
        )
    }

    func VerifySnapshot(_ viewController: UIViewController,
                        file: StaticString = #file,
                        line: UInt = #line) {
        FBSnapshotVerifyViewController(
            viewController,
            file: file,
            line: line
        )
    }

    func VerifySnapshot(_ view: UIView, 
                        file: StaticString = #file,
                        line: UInt = #line) {
        view.sizeToFit()
        FBSnapshotVerifyView(
            view,
            file: file,
            line: line
        )
    }

    func VerifySnapshot(_ layer: CALayer, 
                        file: StaticString = #file,
                        line: UInt = #line) {
        FBSnapshotVerifyLayer(
            layer,
            file: file,
            line: line
        )
    }

    func RecordSnapshotInWindow(_ viewController: UIViewController, 
                                file: StaticString = #file,
                                line: UInt = #line) {
        let initialRecordMode = recordMode
        recordMode = true
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        wrapInWindow(navigationController)
        FBSnapshotVerifyViewController(
            navigationController,
            file: file,
            line: line
        )
        recordMode = initialRecordMode
    }

    func RecordSnapshot(_ viewController: UIViewController, 
                        file: StaticString = #file,
                        line: UInt = #line) {
        let initialRecordMode = recordMode
        recordMode = true
        FBSnapshotVerifyViewController(
            viewController,
            file: file,
            line: line
        )
        recordMode = initialRecordMode
    }

    func RecordSnapshot(_ view: UIView, 
                        file: StaticString = #file,
                        line: UInt = #line) {
        let initialRecordMode = recordMode
        recordMode = true
        FBSnapshotVerifyView(
            view,
            file: file,
            line: line
        )
        recordMode = initialRecordMode
    }

    func RecordSnapshot(_ layer: CALayer, 
                        file: StaticString = #file,
                        line: UInt = #line) {
        let initialRecordMode = recordMode
        recordMode = true
        FBSnapshotVerifyLayer(
            layer,
            file: file,
            line: line
        )
        recordMode = initialRecordMode
    }

    func wrapInWindow(_ viewController: UIViewController) {
        let window = UIWindow()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
