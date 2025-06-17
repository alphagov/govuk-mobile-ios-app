import Foundation
import GOVKit

extension GOVRequest {
    static let token = "<token>"
    private static let additionalHeaders: [String: String] = {
        [
            "Content-Type": "application/json",
            "authorization": "Bearer \(token)"
        ]
    }()
    static func askQuestion(_ question: String,
                            conversationId: String? = nil) -> GOVRequest {
        GOVRequest(
            urlPath: "/conversation/\(conversationId ?? "")",
            method: conversationId != nil ? .put : .post,
            bodyParameters: ["user_question": question],
            queryParameters: nil,
            additionalHeaders: nil
        )
    }

    static func getChatHistory(conversationId: String) -> GOVRequest {
        GOVRequest(
            urlPath: "/conversation/\(conversationId)",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil
        )
    }

    static func getAnswer(conversationId: String,
                          questionId: String) -> GOVRequest {
        GOVRequest(
            urlPath: "/conversation/\(conversationId)/questions/\(questionId)/answer",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil
        )
    }
}
