import Foundation
import SwiftUI
import UIKit

public final class AnalyticsConsent {
    private let analyticsService: AnalyticsServiceInterface
    private let dismissAction: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.dismissAction = dismissAction
    }

    public lazy var viewController: UIViewController = {
        let viewModel = AnalyticsConsentContainerViewModel(
            analyticsService: analyticsService,
            dismissAction: dismissAction
        )
        let containerView = AnalyticsConsentContainerView(viewModel: viewModel)
        return UIHostingController(rootView: containerView)
    }()
}
