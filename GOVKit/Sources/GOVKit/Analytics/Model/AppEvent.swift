import Foundation

public struct AppEvent {
    public let name: String
    public let params: [String: Any]?
    
    public init(name: String,
                params: [String : Any]?) {
        self.name = name
        self.params = params
    }
}
