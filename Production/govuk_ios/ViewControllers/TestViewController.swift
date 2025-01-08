import UIKit

class TestViewController: BaseViewController {
    private let viewModel: TestViewModel

    private lazy var primaryButton: UIButton = {
        let configuration = UIButton.Configuration.plain()
        let localView = UIButton(configuration: configuration)
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.setTitle(viewModel.primaryTitle, for: .normal)
        localView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        localView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        localView.addTarget(self, action: #selector(primaryButtonPressed), for: .touchUpInside)
        return localView
    }()

    private lazy var secondaryButton: UIButton = {
        let configuration = UIButton.Configuration.plain()
        let localView = UIButton(configuration: configuration)
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.setTitle(viewModel.secondaryTitle, for: .normal)
        localView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        localView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        localView.addTarget(self, action: #selector(secondaryButtonPressed), for: .touchUpInside)
        return localView
    }()

    init(viewModel: TestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.tabTitle
        navigationItem.largeTitleDisplayMode = .always
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.color
        view.addSubview(primaryButton)
        primaryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        primaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(secondaryButton)
        secondaryButton.topAnchor.constraint(
            equalTo: primaryButton.bottomAnchor,
            constant: 30
        ).isActive = true
        secondaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        primaryButton.isHidden = viewModel.primaryTitle ==  nil
        secondaryButton.isHidden = viewModel.secondaryTitle ==  nil
    }

    @objc
    private func primaryButtonPressed() {
        viewModel.primaryAction?()
    }

    @objc
    private func secondaryButtonPressed() {
        viewModel.secondaryAction?()
    }
}
