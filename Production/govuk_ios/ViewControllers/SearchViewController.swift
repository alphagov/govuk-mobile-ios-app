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
            action: #selector(searchReturnTapped),
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
    private func searchReturnTapped() {
        self.searchBar.resignFirstResponder()

        let searchText = searchBar.text!
        viewModel.trackSearchTerm(searchTerm: searchText)

        viewModel.searchErrorState = .none
        viewModel.fetchSearchResults(
            searchText: searchText,
            completion: {
                self.tableView.reloadData()

                switch self.viewModel.searchErrorState {
                case .networkUnavailable:
                    self.errorView.configure(
                        title: "You’re offline",
                        errorDesc: "Check your internet connection and try again"
                    )

                    self.errorView.isHidden = false
                case .apiUnavailable:
                    self.errorView.configure(
                        title: "There’s a problem",
                        errorDesc: """
                        Search is not working. Try again later, or search on the GOV.UK website.
                        """,
                        linkText: "Go to the GOV.UK website",
                        link: "https://www.gov.uk"
                    )

                    self.errorView.isHidden = false
                case .noResults:
                    self.errorView.configure(errorDesc: "No results for ’\(searchText)’")

                    self.errorView.isHidden = false
                case .none:
                    self.errorView.isHidden = true
                }
            }
        )
    }
}

extension SearchViewController: UITableViewDelegate,
                                UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults?.count ?? 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCell.identifier, for: indexPath
        ) as? SearchResultCell else {
            fatalError("Unable to dequeue")
        }

        guard viewModel.searchResults != nil
        else { return cell }

        cell.configure(
            title: viewModel.itemTitle(indexPath.row),
            description: viewModel.itemDescription(indexPath.row)
        )

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let searchResults = viewModel.searchResults
        else { return }

        let item = searchResults[indexPath.row]
        let url = URLComponents(string: item.link)
        guard url?.host != nil
        else {
            let govukURL = "https://www.gov.uk\(item.link)"
            return UIApplication.shared.open(URL(string: govukURL)!)
        }

        UIApplication.shared.open(URL(string: item.link)!)
    }
}
