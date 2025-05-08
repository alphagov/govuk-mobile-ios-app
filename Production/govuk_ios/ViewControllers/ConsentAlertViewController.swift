import Foundation
import UIKit

class ConsentAlertViewController: UIViewController {
    var grantConsentAction: (() -> Void)?
    var openSettingsAction: (() -> Void)?

    private lazy var stackView: UIStackView = {
        let localView = UIStackView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.axis = .vertical
        return localView
    }()

    private lazy var settingsButton: UIButton = {
        let localView = UIButton(type: .system)
        localView.setTitle("Settings", for: .normal)
        localView.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        return localView
    }()

    private lazy var actionButton: UIButton = {
        let localView = UIButton(type: .system)
        localView.setTitle("Grant Consent", for: .normal)
        localView.addTarget(self, action: #selector(grantConsentButtonPressed), for: .touchUpInside)
        return localView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        view.backgroundColor = .white
    }

    private func configureUI() {
        stackView.addArrangedSubview(settingsButton)
        settingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(actionButton)
        actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc
    private func grantConsentButtonPressed() {
        grantConsentAction?()
    }

    @objc
    private func settingsButtonPressed() {
        openSettingsAction?()
    }
}
