import Foundation

struct Topic: Decodable {
    let ref: String
    let title: String

    var iconName: String {
        switch self.ref {
        case "driving-transport":
            return "car.fill"
        case "benefits":
            return "sterlingsign"
        case "care":
            return "heart.fill"
        case "parenting":
            return "figure.and.child.holdinghands"
        case "business":
            return "briefcase.fill"
        default:
            return "star.fill"
        }
    }
}
