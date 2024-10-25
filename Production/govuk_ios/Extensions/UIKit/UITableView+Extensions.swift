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

    func selectAllRows(animated: Bool) {
        for section in 0..<numberOfSections {
            for row in 0..<numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                _ = delegate?.tableView?(self, willSelectRowAt: indexPath)
                selectRow(at: indexPath, animated: animated, scrollPosition: .none)
                delegate?.tableView?(self, didSelectRowAt: indexPath)
            }
        }
    }

    func deselectAllRows(animated: Bool) {
        for section in 0..<numberOfSections {
            for row in 0..<numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                _ = delegate?.tableView?(self, willDeselectRowAt: indexPath)
                deselectRow(at: indexPath, animated: animated)
                delegate?.tableView?(self, didDeselectRowAt: indexPath)
            }
        }
    }

    func isEveryRowSelected() -> Bool {
        let numVisibleRows = indexPathsForVisibleRows?.count ?? 0
        guard numVisibleRows > 0 else { return false }
        let numSelectedRows = indexPathsForSelectedRows?.count ?? 0
        return numVisibleRows == numSelectedRows
    }
}
