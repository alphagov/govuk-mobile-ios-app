import Foundation
import SwiftUI

class HostingViewController<T>: UIHostingController<T> where T: View {
    private let navigationBarHidden: Bool

    init(rootView: T,
         navigationBarHidden: Bool = false) {
        self.navigationBarHidden = navigationBarHidden
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
}
