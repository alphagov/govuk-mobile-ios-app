import UIKit
import UIComponents

class SearchViewController: BaseViewController,
                            TrackableScreen {
    private let viewModel: SearchViewModel

    private lazy var searchBar: UISearchBar = {
        let localSearchBar = UISearchBar()

        localSearchBar.searchTextField.backgroundColor = UIColor.govUK.fills.surfaceSearchBox
        localSearchBar.enablesReturnKeyAutomatically = false
        localSearchBar.translatesAutoresizingMaskIntoConstraints = false
        localSearchBar.placeholder = "Search"
        localSearchBar.backgroundImage = UIImage()
        localSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.govUK.text.secondary,
                NSAttributedString.Key.font: UIFont.govUK.body
            ]
        )
        localSearchBar.searchTextField.leftView?.tintColor = UIColor.govUK.text.secondary
        localSearchBar.searchTextField.addTarget(
            self,
            action: #selector(searchReturn),
            for: UIControl.Event.editingDidEndOnExit
        )

        return localSearchBar
    }()

    var trackingName: String { "Search_Modal" }
    var trackingTitle: String? { "Search" }

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 15.0, *) {
            let sheet = self.sheetPresentationController
            sheet?.prefersGrabberVisible = true
        }

        configureUI()
        configureConstraints()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchBar.becomeFirstResponder()
    }

    private func configureUI() {
        view.backgroundColor = GOVUKColors.fills.surfaceModal
        configureNavBar()
        view.addSubview(searchBar)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: -10
            ),
            searchBar.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 10
            ),
            searchBar.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -10
            ),
            searchBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
    }

    private func configureNavBar() {
        self.title = "Search"
        let navBarItem = self.navigationItem
        let appearence = UINavigationBarAppearance()
        appearence.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.govUK.bodySemibold
        ]
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor = GOVUKColors.fills.surfaceModal

        let barButton = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed)
        )
        let attributes = [NSAttributedString.Key.foregroundColor: GOVUKColors.text.link]
        barButton.setTitleTextAttributes(attributes, for: .normal)

        navBarItem.setLeftBarButton(
            barButton,
            animated: true
        )

        navBarItem.standardAppearance = appearence
        navBarItem.compactAppearance = appearence
        navBarItem.scrollEdgeAppearance = appearence
    }

    @objc func cancelButtonPressed(_ sender: UIBarItem) {
        self.navigationController?.dismiss(animated: true)
    }

    @objc func searchReturn() {
        self.searchBar.resignFirstResponder()

        let searchTerm = searchBar.text!
        viewModel.trackSearchTerm(searchTerm: searchTerm)

        if searchTerm.isEmpty {
            let blankSearchURL = "https://www.gov.uk/search?q="
            UIApplication.shared.open(URL(string: blankSearchURL)!)
        } else {
            let searchTermURL = "https://www.gov.uk/search/all?keywords=\(searchTerm)&order=relevance"
            UIApplication.shared.open(URL(string: searchTermURL)!)
        }
    }
}
