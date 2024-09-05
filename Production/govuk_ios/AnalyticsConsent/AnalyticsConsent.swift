import Foundation
import SwiftUI
import UIKit

public final class AnalyticsConsent {
    private let dismissAction: () -> Void
    private let analyticsService: AnalyticsServiceInterface

    init(analyticsService: AnalyticsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
        self.analyticsService = analyticsService
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
