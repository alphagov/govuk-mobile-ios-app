import Foundation

struct SettingsViewModel {
    var analyticsService: AnalyticsServiceInterface

    func logScreen() {
        let screen = SettingsScreen(name: "settings")
        analyticsService.trackScreen(screen)
    }
}
