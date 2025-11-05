import Foundation
import UIKit

import SwiftUI
import GOVKit

struct EmergencyBannerWidgetViewModel {
    let id: String
    let title: String?
    let body: String
    let linkUrl: URL?
    let linkTitle: String?
    let type: EmergencyBannerType
    let allowsDismissal: Bool
    let openURLAction: (URL) -> Void
    let dismiss: () -> Void
    let sortPriority: Double

    init(banner: EmergencyBanner,
         sortPriority: Int,
         openURLAction: @escaping (URL) -> Void,
         dismiss: @escaping () -> Void) {
        self.id = banner.id
        self.title = banner.title
        self.body = banner.body
        self.linkUrl = banner.link?.url
        self.linkTitle = banner.link?.title
        self.openURLAction = openURLAction
        self.dismiss = dismiss
        self.type = EmergencyBannerType(
            rawValue: (banner.type ?? "information")
        ) ?? .information
        self.allowsDismissal = banner.allowsDismissal ?? true
        self.sortPriority = Double(sortPriority) * 10
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
        guard let localUrl = linkUrl
        else { return }
        openURLAction(localUrl)
    }
}
