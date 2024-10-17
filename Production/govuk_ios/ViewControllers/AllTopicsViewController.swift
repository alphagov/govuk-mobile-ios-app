import Foundation
import UIKit
import UIComponents

class AllTopicsViewController: BaseViewController, TrackableScreen {
    let viewModel: AllTopicsViewModel

    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TopicTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.govUK.fills.surfaceBackground
        return tableView
    }()

    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(viewModel: AllTopicsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    var trackingName: String { "All topics" }

    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self

        super.viewDidLoad()

        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
        setupUI()
        configureConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(
            false,
            animated: animated
        )
    }

    private func setupUI() {
        title = String.topics.localized("allTopicsTitle")
        view.addSubview(tableView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            tableView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor
            ),
            tableView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
}

extension AllTopicsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TopicTableViewCell = tableView.dequeue(indexPath: indexPath)

        cell.configure(topic: viewModel.topics[indexPath.row], viewModel: viewModel)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.topics.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = viewModel.topics[indexPath.row]
        viewModel.didTapTopic(topic)
    }
}

class TopicTableViewCell: UITableViewCell {
    var topicCard: UIView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(topic: Topic, viewModel: AllTopicsViewModel) {
        selectionStyle = .none
        contentView.backgroundColor = UIColor.govUK.fills.surfaceBackground

        topicCard = TopicRowView(topic: topic)
        addSubview(topicCard)
        configureConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.topicCard.subviews.forEach({ $0.removeFromSuperview() })
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            topicCard.topAnchor.constraint(
                equalTo: topAnchor
            ),
            topicCard.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            topicCard.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            topicCard.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -16
            ),
            topicCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 72)
        ])
    }
}
