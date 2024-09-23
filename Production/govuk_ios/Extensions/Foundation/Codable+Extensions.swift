import Foundation

extension Decodable {
    func extractDataSliceForKey(_ key: CodingKey,
                                from jsonData: Data,
                                removePrettyPrint: Bool = true) -> Data? {
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }

        if let sliceRange = jsonString.range(of: "\"\(key.stringValue)\":") {
            let start = sliceRange.upperBound
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

            var sliceString =
                String(jsonString[sliceRange.upperBound..<endIndex])
            if removePrettyPrint {
                sliceString = sliceString
                    .replacingOccurrences(of: "\n", with: "")
                    .replacingOccurrences(of: " ", with: "")
            }
            return sliceString.data(using: .utf8)
        }

        return nil
    }
}
