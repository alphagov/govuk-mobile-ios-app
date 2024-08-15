import Foundation

extension URLRequest {

    var bodySteamData: Data? {

        guard let bodyStream = self.httpBodyStream else { return nil }

        bodyStream.open()

        // Will read 16 chars per iteration. Can use bigger buffer if needed
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
