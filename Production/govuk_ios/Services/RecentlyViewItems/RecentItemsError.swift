import Foundation

enum RecentItemsError: LocalizedError {
    case noRecentlyVisitedItems
    var  errorDescription: (String, String) {
        switch self {
        case .noRecentlyVisitedItems:
            return (NSLocalizedString("errorViewTitle",
                                      bundle: .main,
                                      comment: ""),
                    NSLocalizedString("errorViewDescription",
                                      bundle: .main,
                                      comment: "")
            )
        }
    }
}
