import Foundation

extension Decodable {
//    func extractDataSliceForKey(_ key: CodingKey,
//                                from jsonData: Data,
//                                removePrettyPrint: Bool = true) -> Data? {
//        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
//            return nil
//        }
//
//        guard let sliceRange = jsonString.range(of: "\"\(key.stringValue)\":") else {
//            return nil
//        }
//
//        let endIndex = endBraceIndex(for: jsonString,
//                                     in: sliceRange)
//        let stringSlice = String(jsonString[sliceRange.upperBound..<endIndex])
//
//        return data(from: stringSlice,
//                    removePrettyPrint: removePrettyPrint)
//    }

    private func endBraceIndex(for jsonString: String,
                               in range: Range<String.Index>) -> String.Index {
        let start = range.upperBound
        var braceCount = 0
        var endIndex = start
        for index in jsonString[start...].indices {
            let char = jsonString[index]
            if char == "{" {
                braceCount += 1
            } else if char == "}" {
                braceCount -= 1
                if braceCount == 0 {
                    endIndex = jsonString.index(after: index)
                    break
                }
            }
        }
        return endIndex
    }

    private func data(from jsonString: String, removePrettyPrint: Bool) -> Data? {
        var stringCopy = jsonString
        if removePrettyPrint {
            stringCopy = jsonString
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: " ", with: "")
        }
        return stringCopy.data(using: .utf8)
    }
}
