import UIKit
import UIComponents

class SearchViewController: BaseViewController,
                            TrackableScreen {
    private let viewModel: SearchViewModel
    private let dismissAction: () -> Void

    private lazy var errorView = {
        let localView = SearchErrorView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.isHidden = true

        return localView
    }()

    private lazy var searchBar: UISearchBar = {
        let localSearchBar = UISearchBar()

        let placeholderText = NSLocalizedString(
            "searchBarPlaceholder",
            comment: ""
        )
        localSearchBar.searchTextField.backgroundColor = UIColor.govUK.fills.surfaceSearchBox
        localSearchBar.enablesReturnKeyAutomatically = false
        localSearchBar.translatesAutoresizingMaskIntoConstraints = false
        localSearchBar.backgroundImage = UIImage()
        localSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.govUK.text.secondary,
                NSAttributedString.Key.font: UIFont.govUK.body
            ]
        )
        localSearchBar.searchTextField.leftView?.tintColor = UIColor.govUK.text.secondary
        localSearchBar.searchTextField.addTarget(
            self,
            action: #selector(searchReturnPressed),
            for: UIControl.Event.editingDidEndOnExit
        )

        return localSearchBar
    }()


    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier
        )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.govUK.fills.surfaceModal

        return tableView
    }()

    var trackingName: String { "Search" }

    init(viewModel: SearchViewModel,
         dismissAction: @escaping () -> Void) {
        self.viewModel = viewModel
        self.dismissAction = dismissAction
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self

        if #available(iOS 15.0, *) {
            let sheet = self.sheetPresentationController
            sheet?.prefersGrabberVisible = true
        }

        configureUI()
        configureConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavBar(animated: animated)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchBar.becomeFirstResponder()
    }

    private func configureUI() {
        title = NSLocalizedString(
            "searchModalTitle",
            comment: ""
        )
        view.backgroundColor = GOVUKColors.fills.surfaceModal
        view.addSubview(searchBar)
        view.addSubview(errorView)
        view.addSubview(tableView)

        view.bringSubviewToFront(errorView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: -10
            ),
            searchBar.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -10
            ),
            searchBar.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 10
            ),
            searchBar.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 36
            ),

            errorView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor, constant: 40
            ),
            errorView.leftAnchor.constraint(
                equalTo: searchBar.leftAnchor,
                constant: 10
            ),
            errorView.rightAnchor.constraint(
                equalTo: searchBar.rightAnchor,
                constant: -10
            ),

            tableView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor,
                constant: 16
            ),
            tableView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor
            ),
            tableView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor
            ),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureNavBar(animated: Bool) {
        let barButton = UIBarButtonItem.cancel(
            target: self,
            action: #selector(cancelButtonPressed)
        )
        navigationItem.setLeftBarButton(
            barButton,
            animated: animated
        )
        navigationItem.standardAppearance = .govUK
        navigationItem.compactAppearance = .govUK
        navigationItem.scrollEdgeAppearance = .govUK
    }

    @objc
    private func cancelButtonPressed(_ sender: UIBarItem) {
        dismissAction()
    }

    @objc
    private func searchReturnPressed() {
        self.searchBar.resignFirstResponder()

        let searchText = searchBar.text
        viewModel.search(
            text: searchText,
            completion: { [weak self] in
                self?.reloadSearchResults(
                    searchText: searchText
                )
            }
        )
    }

    private func reloadSearchResults(searchText: String?) {
        tableView.reloadData()

        switch viewModel.error {
        case .networkUnavailable:
            errorView.configure(
                title: "You’re offline",
                errorDesc: "Check your internet connection and try again"
            )

            errorView.isHidden = false
        case .apiUnavailable:
            errorView.configure(
                title: "There’s a problem",
                errorDesc: """
                        Search is not working. Try again later, or search on the GOV.UK website.
                        """,
                linkText: "Go to the GOV.UK website",
                link: "https://www.gov.uk"
            )
            errorView.isHidden = false
        case .noResults:
            errorView.configure(errorDesc: "No results for ’\(searchText ?? "")’")

            errorView.isHidden = false
        case .none:
            errorView.isHidden = true
        }
    }
}

extension SearchViewController: UITableViewDelegate,
                                UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.results?.count ?? 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCell.identifier, for: indexPath
        ) as? SearchResultCell else {
            fatalError("Unable to dequeue")
        }
        let item = viewModel.results?[indexPath.row]

        cell.configure(
            item: item
        )

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.results?[indexPath.row]
        else { return }
        viewModel.selected(item: item)
    }
}
