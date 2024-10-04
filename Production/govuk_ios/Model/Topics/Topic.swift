import Foundation

struct Topic: Decodable {
    let ref: String
    let title: String

    var iconName: String {
        switch self.ref {
        case "benefits":
            return "sterlingsign"
        case "business":
            return "briefcase.fill"
        case "care":
            return "heart.fill"
        case "driving-transport":
            return "car.fill"
        case "employment":
            return "list.clipboard.fill"
        case "health-disability":
            return "cross.fill"
        case "money-tax":
            return "chart.pie.fill"
        case "parenting-guardianship":
            return "figure.and.child.holdinghands"
        case "retirement":
            return "chair.lounge.fill"
        case "studying-training":
            return "book.fill"
        case "travel":
            return "airplane"
        default:
            return "star.fill"
        }
    }
}
