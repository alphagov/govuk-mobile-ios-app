import Foundation

struct AppConfig: Decodable {
    let platform: String
    let config: Config
}
