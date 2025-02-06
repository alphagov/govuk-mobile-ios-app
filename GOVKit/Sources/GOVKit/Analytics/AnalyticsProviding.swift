import Foundation

public protocol AnalyticsProviding {
    var analyticsService: AnalyticsServiceInterface? { get set }
}
