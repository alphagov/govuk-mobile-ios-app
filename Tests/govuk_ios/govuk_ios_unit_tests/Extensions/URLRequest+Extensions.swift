import Foundation

extension URLRequest {

    var bodyStreamData: Data? {

        guard let bodyStream = self.httpBodyStream else { return nil }

        bodyStream.open()

        let bufferSize: Int = 16

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)

        var data = Data()

        while bodyStream.hasBytesAvailable {

            let readDat = bodyStream.read(buffer, maxLength: bufferSize)
            data.append(buffer, count: readDat)
        }

        buffer.deallocate()

        bodyStream.close()
        return data
    }
}
