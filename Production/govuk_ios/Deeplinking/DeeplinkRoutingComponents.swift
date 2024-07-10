import Foundation

struct DeeplinkRoutingComponents {
    let sourceURL: URL
    let route: DeeplinkRoute
    let sourceComponents: URLComponents?
    let routeComponents: URLComponents?

    init(sourceURL: URL,
         route: DeeplinkRoute) {
        self.sourceURL = sourceURL
        self.route = route
        var components = URLComponents(
            url: sourceURL,
            resolvingAgainstBaseURL: true
        )
        self.sourceComponents = components
        components?.path = route.pattern
        self.routeComponents = components
    }

    var sourcePathComponents: [String] {
        sourceURL.pathComponents
    }

    var sourceQueryParams: [URLQueryItem]? {
        sourceComponents?.queryItems
    }

    var patternPathComponents: [String] {
        routeComponents?.url?.pathComponents ?? []
    }

    func hasMatchingUrls() -> Bool {
        guard sourcePathComponents.count == patternPathComponents.count
        else { return false }

        return sourcePathComponents
            .enumerated()
            .first {
                !matches(
                    component: $0.element,
                    patternComponent: patternPathComponents[$0.offset]
                )
            } == nil
    }

    private func matches(component: String,
                         patternComponent: String) -> Bool {
        patternComponent == "*" ||
        patternComponent.hasPrefix(":") ||
        patternComponent == component
    }

    func resolveParameters() -> [String: String] {
        var params: [String: String] = [:]
        patternPathComponents
            .enumerated()
            .forEach {
                if $0.element.hasPrefix(":") {
                    let key = $0.element.dropFirst()
                    params[String(key)] = sourcePathComponents[$0.offset]
                }
            }
        sourceQueryParams?.forEach {
            params[$0.name] = $0.value
        }
        return params
    }
}
