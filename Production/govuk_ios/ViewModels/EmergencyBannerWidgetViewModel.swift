import Foundation
import UIKit

import SwiftUI
import GOVKit

struct EmergencyBannerWidgetViewModel {
    let id: String
    let title: String?
    let body: String
    let link: EmergencyBanner.Link?
    let type: EmergencyBannerType
    let allowsDismissal: Bool
    let openURLAction: (URL) -> Void
    let dismissAction: () -> Void
    let sortPriority: Double

    private let analyticsService: AnalyticsServiceInterface

    init(banner: EmergencyBanner,
         analyticsService: AnalyticsServiceInterface,
         sortPriority: Int,
         openURLAction: @escaping (URL) -> Void,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.sortPriority = Double(sortPriority) * 10
        self.openURLAction = openURLAction
        self.dismissAction = dismissAction
        id = banner.id
        title = banner.title
        body = banner.body
        link = banner.link
        type = EmergencyBannerType(
            rawValue: (banner.type ?? "information")
        ) ?? .information
        allowsDismissal = banner.allowsDismissal ?? true
    }

    var backgroundColor: Color {
        switch type {
        case .notableDeath:
            Color(.govUK.fills.surfaceCardEmergencyNotableDeath)
        case .nationalEmergency:
            Color(.govUK.fills.surfaceCardEmergencyNational)
        case .localEmergency:
            Color(.govUK.fills.surfaceCardEmergencyLocal)
        case .information:
            Color(.govUK.fills.surfaceCardEmergencyInfo)
        }
    }

    var foregroundColor: Color {
        if type == .information {
            Color(.govUK.text.primary)
        } else {
            Color.white
        }
    }

    var dismissButtonColor: Color {
        if type == .information {
            Color(.govUK.text.secondary)
        } else {
            Color.white
        }
    }

    var linkColor: Color {
        if type == .information {
            Color(.govUK.text.linkSecondary)
        } else {
            Color.white
        }
    }

    var borderColor: Color {
        switch type {
        case .notableDeath:
            Color(.govUK.strokes.surfaceCardEmergencyNotableDeath)
        case .nationalEmergency, .localEmergency:
            Color(.clear)
        case .information:
            Color(.govUK.strokes.surfaceCardEmergencyInfo)
        }
    }

    func open() {
        guard let link = self.link
        else { return }
        let event = AppEvent.widgetNavigation(
            text: link.title,
            external: true,
            params: ["url": link.url.absoluteString]
        )
        analyticsService.track(event: event)
        openURLAction(link.url)
    }

    func dismiss() {
        let analyticsText = link?.title ?? id
        let event = AppEvent.buttonFunction(
            text: analyticsText,
            section: "Banner",
            action: "Remove")
        analyticsService.track(event: event)
        dismissAction()
    }
}
