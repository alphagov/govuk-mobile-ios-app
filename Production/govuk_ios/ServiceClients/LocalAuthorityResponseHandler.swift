import Foundation

struct LocalAuthorityResponseHandler: ResponseHandler {
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

        switch statusCode {
        case 400:
            return LocalAuthorityError.invalidPostcode
        case 404:
            return LocalAuthorityError.unknownPostcode
        default:
            return LocalAuthorityError.apiUnavailable
        }
    }
}
