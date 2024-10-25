import UIKit
import Foundation

@MainActor
class BaseViewController: UIViewController {
    @Inject(\.analyticsService) private(set) var analyticsService: AnalyticsServiceInterface

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPageView()
        setVoiceoverFocus()
    }

    private func setVoiceoverFocus() {
        UIAccessibility.post(
            notification: .screenChanged,
            argument: view
        )
    }

    func accessibilityLayoutChanged(focusView: UIView) {
        UIAccessibility.post(
            notification: .layoutChanged,
            argument: focusView
        )
    }

    private func configureUI() {
        view.layoutMargins.right = 16
        view.layoutMargins.left = 16
    }

    func trackPageView() {
        if let screen = self as? TrackableScreen {
            analyticsService.track(screen: screen)
        }
    }
}
