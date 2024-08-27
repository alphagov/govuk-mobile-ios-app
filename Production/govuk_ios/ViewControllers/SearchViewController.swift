import UIKit
import UIComponents

class SearchViewController: BaseViewController {
    private let viewModel: SearchViewModel

    private lazy var modalView: UIView = {
        let view = UIView()
        view.backgroundColor = GOVUKColors.fills.surfaceModal
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.clipsToBounds = true
        return view
    }()

    private lazy var searchBoxView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = GOVUKColors.fills.surfaceSearchBox
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var searchBoxTextField: UITextField = {
        let textField = UITextField()
        let searchIconPadding = 8
        let imageView = UIImageView(frame: CGRect(
            x: searchIconPadding, y: 0, width: 25, height: 22)
        )
        let imageContainerView = UIView(
            frame: CGRect(
                x: 0, y: 0, width: Int(imageView.frame.width) + (searchIconPadding * 2), height: 22
            )
        )
        let image = UIImage(systemName: "magnifyingglass")

        imageContainerView.addSubview(imageView)

        imageView.image = image
        imageView.contentMode = .center
        imageView.tintColor = GOVUKColors.text.secondary

        textField.accessibilityLabel = "Text field"
        textField.accessibilityHint = "Returns content on GOV.UK"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: GOVUKColors.text.secondary]
        )
        textField.textColor = GOVUKColors.text.primary
        textField.clearButtonMode = .always
        textField.leftViewMode = .always
        textField.leftView = imageContainerView
        textField.addTarget(
            self,
            action: #selector(onSearchReturn),
            for: UIControl.Event.editingDidEndOnExit
        )
        return textField
    }()

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

        searchBoxTextField.becomeFirstResponder()
    }

    private func configureUI() {
        configureNavBar()
        view.addSubview(modalView)
        modalView.addSubview(searchBoxView)
        searchBoxView.addSubview(searchBoxTextField)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
//            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            modalView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor
            ),
            modalView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor
            ),
            modalView.heightAnchor.constraint(equalToConstant: view.bounds.height),

            searchBoxView.topAnchor.constraint(
                equalTo: modalView.topAnchor),
            searchBoxView.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 16),
            searchBoxView.rightAnchor.constraint(equalTo: modalView.rightAnchor, constant: -16),
            searchBoxView.heightAnchor.constraint(equalToConstant: 36),

            searchBoxTextField.topAnchor.constraint(equalTo: searchBoxView.topAnchor),
            searchBoxTextField.leftAnchor.constraint(equalTo: searchBoxView.leftAnchor),
            searchBoxTextField.rightAnchor.constraint(equalTo: searchBoxView.rightAnchor),
            searchBoxTextField.heightAnchor.constraint(equalTo: searchBoxView.heightAnchor)
        ])
    }

    private func configureNavBar() {
        self.title = "Search"
        let navBarItem = self.navigationItem
        let appearence = UINavigationBarAppearance()
        appearence.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.govUK.bodySemibold
        ]
//        appearence.titlePositionAdjustment.vertical = 8
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor = GOVUKColors.fills.surfaceModal

        let barButton = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed)
        )
        let attributes = [NSAttributedString.Key.foregroundColor: GOVUKColors.text.link]
        barButton.setTitleTextAttributes(attributes, for: .normal)
//        let attributes = [NSAttributedString.Key.baselineOffset: NSNumber(value: -8)]

//        barButton.setTitlePositionAdjustment(
//            UIOffset(horizontal: 20, vertical: 0),
//            for: UIBarMetrics.default
//        )

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

    @objc func onSearchReturn() {
        self.searchBoxTextField.resignFirstResponder()

        let searchTerm = searchBoxTextField.text!

        if let url = URL(
            string: "https://www.gov.uk/search/all?keywords=\(searchTerm)&order=relevance"
        ) {
            UIApplication.shared.open(url)
        }
    }
}
