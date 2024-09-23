import Foundation
import UIKit

extension UITableView {

    func register<T: UITableViewCell.Type>(_ klass: T) {
        register(T.self, forCellReuseIdentifier: T.identifierString)
    }

    func dequeue<T: UITableViewCell>(indexPath: IndexPath) -> T {
        // swiftlint:disable force_cast
        dequeueReusableCell(
            withIdentifier: T.identifierString,
            for: indexPath
        ) as! T
        // swiftlint:enable force_cast
    }

}
