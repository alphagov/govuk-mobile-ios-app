import Foundation
import SwiftUI

class HostingViewController<T>: UIHostingController<T> where T: View {
    private let navigationBarHidden: Bool
    private let statusBarStyle: UIStatusBarStyle

    init(rootView: T,
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(
            navigationBarHidden,
            animated: animated
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setVoiceoverFocus()
    }

    private func setVoiceoverFocus() {
        UIAccessibility.post(
            notification: .screenChanged,
            argument: view
        )
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }
}
