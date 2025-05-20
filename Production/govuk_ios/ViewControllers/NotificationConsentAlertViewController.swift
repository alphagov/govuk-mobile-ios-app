import Foundation
import UIKit
import GOVKit

class NotificationConsentAlertViewController: BaseViewController {
    var grantConsentAction: (() -> Void)?
    var openSettingsAction: (() -> Void)?

    private var titleLabel: UILabel = {
        let localView = UILabel()
        localView.font = UIFont.govUK.largeTitleBold
        localView.textColor = UIColor.govUK.text.primary
        localView.text = String.notifications.localized("consentAlertTitle")
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private var bodyLabel: UILabel = {
        let localView = UILabel()
        localView.font = UIFont.govUK.body
        localView.textColor = UIColor.govUK.text.primary
        localView.text = String.notifications.localized("consentAlertBody")
        localView.numberOfLines = 0
        localView.lineBreakMode = .byWordWrapping
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private lazy var privacyButton: UIButton = {
        let localView = UIButton()
        localView.titleLabel?.font = UIFont.govUK.body
        localView.titleLabel?.numberOfLines = 0
        localView.titleLabel?.lineBreakMode = .byWordWrapping
        localView.setTitleColor(UIColor.govUK.text.link, for: .normal)
        localView.setTitle(
            String.notifications.localized("consentAlertButtonTitle"),
            for: .normal
        )
        localView.contentHorizontalAlignment = .leading
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.accessibilityHint = String.common.localized("openWebLinkHint")
        return localView
    }()

    private lazy var linkImage: UIImageView = {
        let localView = UIImageView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.image = UIImage(systemName: "arrow.up.right")
        localView.tintColor = UIColor.govUK.text.link
        localView.isAccessibilityElement = false
        return localView
    }()

    private var privacyStackView: UIStackView = {
        let localView = UIStackView()
        localView.axis = .horizontal
        localView.distribution = .fillProportionally
        localView.alignment = .center
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private lazy var settingsButton: UIButton = {
        let localView = UIButton.govUK.secondary
        localView.viewModel = .init(
            localisedTitle: String.notifications.localized("consentAlertSecondaryButtonTitle"),
            action: { [weak self] in
                self?.openSettingsAction?()
            }
        )
        return localView
    }()

    private lazy var actionButton: UIButton = {
        let localView = UIButton.govUK.primary
        localView.viewModel = .init(
            localisedTitle: String.notifications.localized("consentAlertPrimaryButtonTitle"),
            action: { [weak self] in
                self?.grantConsentAction?()
            }
        )
        return localView
    }()

    private lazy var footerView: StickyFooterView = {
        let localView = StickyFooterView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    override init(analyticsService: AnalyticsServiceInterface) {
        super.init(analyticsService: analyticsService)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        privacyStackView.addArrangedSubview(privacyButton)
        privacyStackView.addArrangedSubview(linkImage)
        view.addSubview(privacyStackView)

        footerView.addView(actionButton)
        actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        footerView.addView(settingsButton)
        settingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(footerView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 48
            ),
            titleLabel.leftAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leftAnchor
            ),
            titleLabel.rightAnchor.constraint(
                equalTo: view.rightAnchor
            ),

            bodyLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 24
            ),
            bodyLabel.trailingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.trailingAnchor
            ),
            bodyLabel.leadingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leadingAnchor
            ),

            linkImage.widthAnchor.constraint(equalToConstant: 17),

            privacyStackView.topAnchor.constraint(
                equalTo: bodyLabel.bottomAnchor,
                constant: 24
            ),
            privacyStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor
            ),
            privacyStackView.leadingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leadingAnchor
            ),

            footerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        privacyButton.accessibilityFrame = privacyStackView.frame
    }
}
