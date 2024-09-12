import Foundation

struct SearchViewModel {
    let analyticsService: AnalyticsServiceInterface

    func trackSearchTerm(searchTerm: String) {
        analyticsService.track(
            event: AppEvent.searchTerm(term: searchTerm)
        )
    }
}
