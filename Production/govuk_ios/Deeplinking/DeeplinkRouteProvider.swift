import Foundation

protocol DeeplinkRouteProvider {
    func route(for: URL) -> ResolvedDeeplinkRoute?
}
