import Foundation

public struct ActivityItemCreateParams {
    public var id: String
    public var title: String
    public var date: Date
    public var url: String
    
    public init(id: String,
                title: String,
                date: Date,
                url: String) {
        self.id = id
        self.title = title
        self.date = date
        self.url = url
    }
}
