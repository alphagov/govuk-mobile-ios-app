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
        self.id = banner.id
        self.title = banner.title
        self.body = banner.body
        self.link = banner.link
        self.type = EmergencyBannerType(
            rawValue: (banner.type ?? "information")
        ) ?? .information
        self.allowsDismissal = banner.allowsDismissal ?? true
    }

    var backgroundColor: Color {
        switch type {
        case .notableDeath:
            return Color(.govUK.fills.surfaceCardEmergencyNotableDeath)
        case .nationalEmergency:
            return Color(.govUK.fills.surfaceCardEmergencyNational)
        case .localEmergency:
            return Color(.govUK.fills.surfaceCardEmergencyLocal)
        case .information:
            return Color(.govUK.fills.surfaceCardEmergencyInfo)
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
        let event = AppEvent.buttonFunction(
            text: "Dismiss",
            section: "Banner",
            action: "dismiss")
        analyticsService.track(event: event)
        self.dismissAction()
    }
}
