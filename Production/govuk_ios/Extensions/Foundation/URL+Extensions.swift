import Foundation

extension URL {
    init(base: URL, request: GOVRequest) {
        var components = URLComponents(url: base, resolvingAgainstBaseURL: true)
        components?.path = request.urlPath
        components?.queryItems = request.queryParameters?.map(URLQueryItem.init)
        self = components?.url ?? base
    }
}
