import Foundation
import UIKit
import GOVKit

class HomeViewController: BaseViewController {
    private var searchViewController: SearchViewController!
    private var viewModel: HomeViewModel
    private var homeContentViewController: UIViewController!
    private lazy var logoImageView: UIImageView = {
        let uiImageView = UIImageView(image: .homeLogo)
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.isAccessibilityElement = true
        uiImageView.accessibilityLabel = String.home.localized("logoAccessibilityTitle")
        uiImageView.accessibilityTraits = .header
        return uiImageView
    }()
    private lazy var searchBar: UISearchBar = {
        let localSearchBar = UISearchBar()
        localSearchBar.searchTextField.backgroundColor = UIColor.govUK.fills.surfaceSearch
        localSearchBar.enablesReturnKeyAutomatically = false
        localSearchBar.translatesAutoresizingMaskIntoConstraints = false
        localSearchBar.barTintColor = UIColor.govUK.fills.surfaceHomeHeaderBackground
        localSearchBar.layer.borderColor = UIColor.govUK.fills.surfaceHomeHeaderBackground.cgColor
        localSearchBar.layer.borderWidth = 1
        localSearchBar.searchTextField.defaultTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.govUK.text.primary,
            NSAttributedString.Key.font: UIFont.govUK.body,
        ]
        localSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: String.search.localized("searchBarPlaceholder"),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.govUK.text.secondary,
                NSAttributedString.Key.font: UIFont.govUK.body
            ]
        )
        localSearchBar.searchTextField.leftView?.tintColor = UIColor.govUK.text.secondary
        localSearchBar.searchTextField.rightView?.tintColor = UIColor.govUK.text.secondary
        localSearchBar.tintColor = UIColor.govUK.text.secondary
        colorSearchBarButton()
        localSearchBar.delegate = self
        return localSearchBar
    }()

    private let imageHeight = 28.0
    private lazy var logoHeightConstraint = {
        logoImageView.heightAnchor.constraint(
            equalToConstant: imageHeight
        )
    }()
    private lazy var searchTopConstraint = {
        searchBar.topAnchor.constraint(
            equalTo: logoImageView.bottomAnchor,
            constant: 16
        )
    }()

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(analyticsService: viewModel.analyticsService)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateWidgets()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        if viewModel.searchEnabled {
            configureSearchBar()
        }
        configureContentViewController()
        displayHomeContent()
    }

    private func configureContentViewController() {
        let contentView = HomeContentView(
            viewModel: viewModel
        )
        let contentViewController = HostingViewController(
            rootView: contentView
        )
        homeContentViewController = contentViewController
    }

    private func displayHomeContent() {
        displayController(homeContentViewController)
    }

    private func configureSearchBar() {
        searchViewController = SearchViewController(
            viewModel: viewModel.searchViewModel,
            searchBar: searchBar
        )

        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            logoHeightConstraint,
            searchTopConstraint,
            searchBar.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -8
            ),
            searchBar.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 8
            )
        ])
    }

    private func configureUI() {
        view.addSubview(logoImageView)
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = UIColor.govUK.fills.surfaceHomeHeaderBackground
    }

    private func displayController(_ content: UIViewController) {
        addController(content)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        let header = viewModel.searchEnabled ? searchBar : logoImageView
        let headerBottomPadding = viewModel.searchEnabled ? 8.0 : 16.0
        NSLayoutConstraint.activate([
            content.view.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            content.view.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            content.view.topAnchor.constraint(
                equalTo: header.bottomAnchor,
                constant: headerBottomPadding
            ),
            content.view.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            logoImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            )
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if viewModel.searchEnabled {
            setLogoHidden(searchBar.searchTextField.isEditing)
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                searchBar.layer.borderColor = UIColor.govUK
                                                     .fills
                                                     .surfaceHomeHeaderBackground
                                                     .cgColor
            }
        }
    }

    fileprivate func setLogoHidden(_ hideLogo: Bool) {
        // Flush any pending layouts before animating header layout
        self.view.layoutIfNeeded()
        if hideLogo &&
            traitCollection.verticalSizeClass == .compact {
            logoHeightConstraint.constant = 0
            searchTopConstraint.constant = -4
        } else {
            logoHeightConstraint.constant = imageHeight
            searchTopConstraint.constant = 16
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    private func colorSearchBarButton() {
        let searchBarButton = UIBarButtonItem.appearance(
            whenContainedInInstancesOf: [UISearchBar.self]
        )
        let foregroundColor = NSAttributedString.Key.foregroundColor.rawValue
        searchBarButton.setTitleTextAttributes(
            [NSAttributedString.Key(rawValue: foregroundColor): UIColor.govUK.text.linkHeader],
            for: .normal
        )
    }

    private func cancelSearch() {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchViewController.clearResults()
        removeController(searchViewController)
        displayController(homeContentViewController)
        setLogoHidden(false)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        removeController(homeContentViewController)
        displayController(searchViewController)
        setLogoHidden(true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelSearch()
    }
}

extension HomeViewController: ResetsToDefault {
    func resetState() {
        if viewModel.searchEnabled {
            cancelSearch()
        }
        viewModel.homeContentScrollToTop = true
    }
}
