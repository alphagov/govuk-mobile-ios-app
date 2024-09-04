import Foundation

extension HTTPURLResponse {

    static var arrangeSuccess: HTTPURLResponse {
        .arrange(statusCode: 200)
    }

    static func arrange(url: URL = URL(string: "https://www.google.com")!,
                        statusCode: Int,
                        httpVersion: String? = nil,
                        headerFields: [String: String]? = nil) -> HTTPURLResponse {
        .init(
            url: url,
            statusCode: statusCode,
            httpVersion: httpVersion,
            headerFields: headerFields
        )!
    }
}
