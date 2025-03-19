import Foundation
import UIKit

extension UITableView {
    public func register(_ klass: UITableViewCell.Type) {
        register(klass, forCellReuseIdentifier: klass.identifierString)
    }

    public func dequeue<T: UITableViewCell>(indexPath: IndexPath) -> T {
        // swiftlint:disable force_cast
        dequeueReusableCell(
            withIdentifier: T.identifierString,
            for: indexPath
        ) as! T
        // swiftlint:enable force_cast
    }

    public func selectAllRows(animated: Bool) {
        for section in 0..<numberOfSections {
            for row in 0..<numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                _ = delegate?.tableView?(self, willSelectRowAt: indexPath)
                selectRow(at: indexPath, animated: animated, scrollPosition: .none)
                delegate?.tableView?(self, didSelectRowAt: indexPath)
            }
        }
    }

    public func deselectAllRows(animated: Bool) {
        for section in 0..<numberOfSections {
            for row in 0..<numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                _ = delegate?.tableView?(self, willDeselectRowAt: indexPath)
                deselectRow(at: indexPath, animated: animated)
                delegate?.tableView?(self, didDeselectRowAt: indexPath)
            }
        }
    }
}
