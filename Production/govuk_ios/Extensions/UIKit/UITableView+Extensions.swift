import Foundation
import UIKit

extension UITableView {
    func register(_ klass: UITableViewCell.Type) {
        register(klass, forCellReuseIdentifier: klass.identifierString)
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
