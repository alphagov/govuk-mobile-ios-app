import Foundation
import GOVKit

extension String {
    static var recentActivity: LocalStringBuilder {
        .init(
            tableName: "RecentActivity",
            bundle: .module
        )
    }
}
