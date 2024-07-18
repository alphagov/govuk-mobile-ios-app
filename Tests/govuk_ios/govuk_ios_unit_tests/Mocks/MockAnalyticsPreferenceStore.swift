import Logging

final class MockAnalyticsPreferenceStore: AnalyticsPreferenceStore {
    private var subscribers = [AsyncStream<Bool>.Continuation]()
    var hasAcceptedAnalytics: Bool?
    
    func stream() -> AsyncStream<Bool> {
        AsyncStream { element in
            subscribers.append(element)
        }
    }
}
