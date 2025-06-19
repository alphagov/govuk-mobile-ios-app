import Foundation
import SwiftUI

public final class HostingViewController<T>: UIHostingController<T> where T: View {
    private let navigationBarHidden: Bool
    private let statusBarStyle: UIStatusBarStyle
    public var shouldAutoFocusVoiceover: Bool = true

    public init(rootView: T,
                navigationBarHidden: Bool = false,
                statusBarStyle: UIStatusBarStyle = .default) {
        self.navigationBarHidden = navigationBarHidden
        self.statusBarStyle = statusBarStyle
        super.init(rootView: rootView)
    }

    @MainActor @preconcurrency
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController else { return }

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
        guard shouldAutoFocusVoiceover else { return }
        UIAccessibility.post(
            notification: .screenChanged,
            argument: view
        )
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }
}
