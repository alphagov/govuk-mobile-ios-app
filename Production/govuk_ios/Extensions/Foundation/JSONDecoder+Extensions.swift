import Foundation

extension JSONDecoder {
    func decode<T>(from data: Data) throws -> T where T: Decodable {
        try decode(T.self, from: data)
    }
}
