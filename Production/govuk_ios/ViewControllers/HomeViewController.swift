import Foundation
import UIKit
import GOVKit

class HomeViewController: BaseViewController {
    private var searchViewController: UIViewController!
    private var homeContentViewController: UIViewController!
    private var viewModel: HomeViewModel
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
        localSearchBar.searchTextField.backgroundColor = .white
        localSearchBar.enablesReturnKeyAutomatically = false
        localSearchBar.translatesAutoresizingMaskIntoConstraints = false
        localSearchBar.backgroundImage = UIImage()
        localSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: String.search.localized("searchBarPlaceholder"),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.govUK.text.secondary,
                NSAttributedString.Key.font: UIFont.govUK.body
            ]
        )
        localSearchBar.searchTextField.leftView?.tintColor = UIColor.govUK.text.secondary
        localSearchBar.delegate = self

        return localSearchBar
    }()

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(analyticsService: viewModel.analyticsService)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        configureContentControllers()
    }

    private func configureContentControllers() {
        searchViewController = SearchViewController(
            viewModel: viewModel.searchViewModel,
            searchBar: searchBar
        )
        homeContentViewController = HomeContentViewController(
            viewModel: viewModel
        )
        displayContentController(homeContentViewController!)
    }


    private func configureUI() {
        view.addSubview(logoImageView)
        view.addSubview(searchBar)

        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = UIColor.govUK.fills.surfaceHomeHeaderBackground
    }

    private func displayContentController(_ content: UIViewController) {
        addChild(content)
        view.addSubview(content.view)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            content.view.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            content.view.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            content.view.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor,
                constant: 8
            ),
            content.view.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
        content.didMove(toParent: self)
    }

    private func removeContentController(_ content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            logoImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),

            searchBar.topAnchor.constraint(
                equalTo: logoImageView.bottomAnchor,
                constant: 16
            ),
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
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        (searchBar.value(forKey: "cancelButton") as? UIButton)?.tintColor = UIColor.white
        displayContentController(searchViewController)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        displayContentController(homeContentViewController)
    }
}
