import Foundation

protocol ResponseHandler {
    func handleResponse(_ response: URLResponse?,
                        error: Error?) -> Error?
    func handleStatusCode(_ statusCode: Int) -> Error
}

extension ResponseHandler {
    func handleResponse(_ response: URLResponse?,
                        error: Error?) -> Error? {
        guard error == nil else {
            return error
        }
        guard let httpURLResponse = response as? HTTPURLResponse else {
            return nil
        }

        let statusCode = httpURLResponse.statusCode
        if (200..<300).contains(statusCode) {
            return nil
        }
        return handleStatusCode(statusCode)
    }
}
