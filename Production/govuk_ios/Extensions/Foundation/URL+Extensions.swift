import Foundation

extension URL {
    init(base: URL, request: GOVRequest) {
        var components = URLComponents(url: base, resolvingAgainstBaseURL: true)
        components?.path = request.urlPath
        components?.queryItems = request.queryParameters?.map(URLQueryItem.init)
        self = components?.url ?? base
    }

    static func sqlitePath(storeName: String) -> URL {
        let applicationSupportFolderURL = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let url = applicationSupportFolderURL!.appendingPathComponent(
            "\(storeName).sqlite")
        return url
    }
}
