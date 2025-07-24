import Foundation

extension URL {
    init(base: URL, request: GOVRequest) {
        var components = URLComponents(url: base, resolvingAgainstBaseURL: true)
        var basePath = components?.path ?? ""
        basePath = basePath.appending(request.urlPath)
        components?.path = basePath
        components?.queryItems = request.queryParameters?.map(URLQueryItem.init)
        self = components?.url ?? base
    }
}
