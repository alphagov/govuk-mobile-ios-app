import UIKit
import SwiftUI

import iOSSnapshotTestCase
import Factory
import Lottie

@testable import govuk_ios

class SnapshotTestCase: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        Container.shared.lottieConfiguration.register {
            LottieConfiguration(renderingEngine: .mainThread)
        }
//        self.recordMode = true
    }

    func VerifySnapshotInNavigationController(view: some View,
                                              mode: UIUserInterfaceStyle,
                                              navBarHidden: Bool = false,
                                              file: StaticString = #file,
                                              line: UInt = #line) {
        let wrappedView = UIHostingController(rootView: view)
        VerifySnapshotInNavigationController(
            viewController: wrappedView,
            mode: mode,
            navBarHidden: navBarHidden,
            file: file,
            line: line
        )
    }

    func VerifySnapshotInNavigationController(viewController: UIViewController,
                                              mode: UIUserInterfaceStyle,
                                              navBarHidden: Bool = false,
                                              prefersLargeTitles: Bool = false,
                                              file: StaticString = #file,
                                              line: UInt = #line) {
//        let navigationController = UINavigationController(rootViewController: viewController)
//        navigationController.setNavigationBarHidden(navBarHidden, animated: false)
//        navigationController.overrideUserInterfaceStyle = mode
//        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
        VerifySnapshotInWindow(
            viewController,
            overallTolerance: 0.001,
            file: file,
            line: line
        )
    }

    func VerifySnapshotInWindow(_ viewController: UIViewController,
                                perPixelTolerance: CGFloat = 0,
                                overallTolerance: CGFloat = 0,
                                file: StaticString = #file, 
                                line: UInt = #line) {
//        wrapInWindow(viewController)
        FBSnapshotVerifyViewController(
            viewController,
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

    func RecordSnapshotInNavigationController(view: some View,
                                              mode: UIUserInterfaceStyle,
                                              navBarHidden: Bool = false,
                                              prefersLargeTitles: Bool = false,
                                              file: StaticString = #file,
                                              line: UInt = #line) {
        let wrappedView = UIHostingController(rootView: view)
        RecordSnapshotInNavigationController(
            viewController: wrappedView,
            mode: mode,
            navBarHidden: navBarHidden,
            prefersLargeTitles: prefersLargeTitles,
            file: file,
            line: line
        )
    }

    func RecordSnapshotInNavigationController(viewController: UIViewController,
                                              mode: UIUserInterfaceStyle,
                                              navBarHidden: Bool = false,
                                              prefersLargeTitles: Bool = false,
                                              file: StaticString = #file,
                                              line: UInt = #line) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(navBarHidden, animated: false)
        navigationController.overrideUserInterfaceStyle = mode
        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
        RecordSnapshotInWindow(
            navigationController,
            file: file,
            line: line
        )
    }

    func RecordSnapshotInWindow(_ viewController: UIViewController,
                                file: StaticString = #file,
                                line: UInt = #line) {
        let initialRecordMode = recordMode
        recordMode = true
        wrapInWindow(viewController)
        FBSnapshotVerifyViewController(
            viewController,
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
        let window = UIApplication.shared.window
        guard let window = window else { return }
        window.rootViewController = viewController
    }
}
