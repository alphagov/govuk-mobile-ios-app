import Foundation
import UIKit

extension UITableView {
    static var groupedList: UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GroupedListTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.estimatedSectionHeaderHeight = 24
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }
}
