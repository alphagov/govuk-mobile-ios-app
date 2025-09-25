import Foundation
import GOVKit

extension GOVRequest {
    static func askQuestion(_ question: String,
                            conversationId: String? = nil,
                            accessToken: String? = nil) -> GOVRequest {
        var path = "/conversation"
        if let conversationId = conversationId {
            path += "/\(conversationId)"
        }
        return GOVRequest(
            urlPath: path,
            method: conversationId != nil ? .put : .post,
            bodyParameters: ["user_question": question],
            queryParameters: nil,
            additionalHeaders: addtionalHeaders(accessToken)
        )
    }

    static func getChatHistory(conversationId: String,
                               accessToken: String? = nil) -> GOVRequest {
        GOVRequest(
            urlPath: "/conversation/\(conversationId)",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: addtionalHeaders(accessToken)
        )
    }

    static func getAnswer(conversationId: String,
                          questionId: String,
                          accessToken: String? = nil) -> GOVRequest {
        GOVRequest(
            urlPath: "/conversation/\(conversationId)/questions/\(questionId)/answer",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: addtionalHeaders(accessToken)
        )
    }

    private static func addtionalHeaders(_ accessToken: String?) -> [String: String] {
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = "Bearer \(accessToken ?? "")"
        return headers
    }
}
