import UIKit
import UIComponents

class SearchViewController: BaseViewController {
    private let viewModel: SearchViewModel

    private lazy var modalView: UIView = {
        let view = UIView()
        view.backgroundColor = GOVUKColors.fills.surfaceModal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
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

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .always
        textField.leftViewMode = .always
        textField.leftView = imageContainerView
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

        self.title = "Search"
        let appearence = UINavigationBarAppearance()
        appearence.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.govUK.bodySemibold
        ]
        appearence.titlePositionAdjustment.vertical = 8
        appearence.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearence
        navigationItem.compactAppearance = appearence
        navigationItem.scrollEdgeAppearance = appearence

        if #available(iOS 15.0, *) {
            let sheet = self.sheetPresentationController
            sheet?.prefersGrabberVisible = true
        }

        configureUI()
        configureConstraints()
    }

    private func configureUI() {
        view.addSubview(modalView)
        modalView.addSubview(searchBoxView)
        searchBoxView.addSubview(searchBoxTextField)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            modalView.heightAnchor.constraint(equalToConstant: view.bounds.height),

            searchBoxView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBoxView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            searchBoxView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            searchBoxView.heightAnchor.constraint(equalToConstant: 36),

            searchBoxTextField.topAnchor.constraint(equalTo: searchBoxView.topAnchor),
            searchBoxTextField.leftAnchor.constraint(equalTo: searchBoxView.leftAnchor),
            searchBoxTextField.rightAnchor.constraint(equalTo: searchBoxView.rightAnchor),
            searchBoxTextField.heightAnchor.constraint(equalTo: searchBoxView.heightAnchor)
        ])
    }
}
