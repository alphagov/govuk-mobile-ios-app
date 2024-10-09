import Foundation
import UIKit

private typealias DataSource = UITableViewDiffableDataSource<ActivitySection, String>
private typealias Snapshot = NSDiffableDataSourceSnapshot<ActivitySection, String>

class GroupedListViewModel {
    var sections: [ActivitySection] = [
        .today,
        .thisMonth
    ]
}

class GroupedListViewController: UIViewController,
                                 UITableViewDelegate {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GroupedListTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    private lazy var dataSource: DataSource = {
        let localDataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell: GroupedListTableViewCell = tableView.dequeue(indexPath: indexPath)
                let section = self.viewModel.sections[indexPath.section]
                cell.set(
                    title: item,
                    top: indexPath.row == 0,
                    bottom: item == section.items.last
                )
                return cell
            }
        )
        localDataSource.defaultRowAnimation = .fade
        return localDataSource
    }()

    private let viewModel: GroupedListViewModel

    init(viewModel: GroupedListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.setEditing(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        tableView.delegate = self
        tableView.dataSource = dataSource
        reloadSnapshot()
    }

    private func configureUI() {
        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
        view.addSubview(tableView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            tableView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -10
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            tableView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 10
            )
        ])
    }

    private func reloadSnapshot() {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        viewModel.sections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems($0.items, toSection: $0)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        10
    }
}

class GroupedListTableViewCell: UITableViewCell {
    private lazy var borderLayer: CAShapeLayer = {
        let borderLayer = CAShapeLayer()
        borderLayer.lineWidth = 0.5
        borderLayer.strokeColor = UIColor.govUK.strokes.listDivider.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        return borderLayer
    }()

    private lazy var separatorView: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        localView.backgroundColor = UIColor.govUK.strokes.listDivider
        return localView
    }()

    var isTop = false
    var isBottom = false

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.addSublayer(borderLayer)
        layer.masksToBounds = true
        contentView.addSubview(separatorView)
        separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(
            equalTo: contentView.leftAnchor,
            constant: 16
        ).isActive = true
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(title: String,
             top: Bool,
             bottom: Bool) {
        textLabel?.text = title
        self.isTop = top
        self.isBottom = bottom
        updateMask()
        separatorView.isHidden = bottom
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }

    private func updateMask() {
        var corners: UIRectCorner = isTop ? [.topLeft, .topRight] : []
        if isBottom {
            corners =  [corners, .bottomLeft, .bottomRight]
        }
        var newFrame = bounds
        newFrame.size.height += 4
        let widthDelta: CGFloat = 1
        newFrame.size.width -= widthDelta
        if isTop {
            newFrame.origin = .init(x: widthDelta / 2, y: 0.5)
        } else if isBottom {
            newFrame.origin = .init(x: widthDelta / 2, y: -4.5)
        } else {
            newFrame.origin = .init(x: widthDelta / 2, y: -2)
        }

        let path = UIBezierPath(
            roundedRect: newFrame,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: 10, height: 10)
        )
        borderLayer.path = path.cgPath
//        borderLayer.frame = newFrame
    }
}

struct ActivitySection: Hashable {
    let items: [String]
}

extension ActivitySection {
    static var today: ActivitySection {
        .init(
            items: [
                "0 - 0",
                "0 - 1",
                "0 - 2",
                "0 - 3",
                "0 - 4"
            ]
        )
    }

    static var thisMonth: ActivitySection {
        .init(
            items: [
                "1 - 0",
                "1 - 1",
                "1 - 2",
                "1 - 3",
                "1 - 4"
            ]
        )
    }
}
