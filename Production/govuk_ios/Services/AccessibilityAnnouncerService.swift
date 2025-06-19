import Foundation
import UIKit

protocol AccessibilityAnnouncerServiceInterface {
    func announce(_ value: String)
}

struct AccessibilityAnnouncerService: AccessibilityAnnouncerServiceInterface {
    func announce(_ value: String) {
        let message = NSAttributedString(
            string: value,
            attributes: [
                .accessibilitySpeechQueueAnnouncement: true
            ]
        )
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.1,
            execute: {
                UIAccessibility.post(
                    notification: .announcement,
                    argument: message
                )
            }
        )
    }
}
