import Foundation
import UIKit

class GovUIWindow: UIWindow {
    private let inactivityService: InactivityServiceInterface

    init(windowScene: UIWindowScene, inactivityService: InactivityServiceInterface) {
        self.inactivityService = inactivityService
        super.init(windowScene: windowScene)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)

        if event.type == .touches {
            resetInactivityTimer()
        }
    }

    private func resetInactivityTimer() {
        inactivityService.resetTimer()
    }
}
