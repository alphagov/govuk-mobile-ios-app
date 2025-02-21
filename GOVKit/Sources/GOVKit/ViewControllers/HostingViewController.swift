import Foundation
import SwiftUI

public final class HostingViewController<T>: UIHostingController<T> where T: View {
    private let navigationBarHidden: Bool
    private let statusBarStyle: UIStatusBarStyle
    private let setNavBarAppearance: (UINavigationBar) -> Void

    public init(rootView: T,
                navigationBarHidden: Bool = false,
                statusBarStyle: UIStatusBarStyle = .default,
                setNavBarAppearance: @escaping (UINavigationBar) -> Void = defaultNavBarAppearance) {
        self.navigationBarHidden = navigationBarHidden
        self.statusBarStyle = statusBarStyle
        self.setNavBarAppearance = setNavBarAppearance
        super.init(rootView: rootView)
    }

    @MainActor @preconcurrency
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController else { return }
        setNavBarAppearance(navigationController.navigationBar)
        navigationController.setNavigationBarHidden(
            navigationBarHidden,
            animated: animated
        )
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setVoiceoverFocus()
    }

    private func setVoiceoverFocus() {
        UIAccessibility.post(
            notification: .screenChanged,
            argument: view
        )
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }

    public static func defaultNavBarAppearance(_ navigationBar: UINavigationBar) {
        UINavigationBar.setStandardAppearance(navigationBar)
    }
}
