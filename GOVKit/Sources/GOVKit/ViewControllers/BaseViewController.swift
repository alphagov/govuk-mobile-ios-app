import UIKit
import Foundation

@MainActor
open class BaseViewController: UIViewController {
    public let analyticsService: AnalyticsServiceInterface
    public var shouldAutoFocusVoiceover: Bool = true

    public init(analyticsService: AnalyticsServiceInterface) {
        self.analyticsService = analyticsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPageView()
        setVoiceoverFocus()
    }

    private func setVoiceoverFocus() {
        guard shouldAutoFocusVoiceover else { return }
        UIAccessibility.post(
            notification: .screenChanged,
            argument: view
        )
    }

    public func accessibilityLayoutChanged(focusView: UIView) {
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
