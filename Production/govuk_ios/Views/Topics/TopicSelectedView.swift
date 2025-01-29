import Foundation
import UIKit

class TopicSelectedView: UIStackView {
    private lazy var selectedIconImageView = UIImageView(image: nil)

    private lazy var selectedLabel: UILabel = {
        let localView = UILabel()
        localView.font = .govUK.body
        localView.text = String.topics.localized(
            "topicOnboardingCardUnselected"
        )
        localView.textAlignment = .center
        localView.adjustsFontForContentSizeCategory = true
        localView.numberOfLines = 0
        return localView
    }()

    var isSelected: Bool = false {
        didSet {
            toggleSelectedIconAndTextViews()
        }
    }

    init() {
        super.init(frame: .zero)
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        axis = .horizontal
        spacing = 4
        alignment = .center
        addArrangedSubview(selectedIconImageView)
        addArrangedSubview(selectedLabel)
    }

    private func toggleSelectedIconAndTextViews() {
        selectedLabel.text = isSelected ?
        String.topics.localized("topicOnboardingCardSelected") :
        String.topics.localized("topicOnboardingCardUnselected")

        selectedLabel.textColor = isSelected ?
        UIColor.govUK.text.buttonSuccess :
        UIColor.govUK.text.link

        selectedIconImageView.image = isSelected ?
        UIImage(systemName: "checkmark") :
        UIImage(systemName: "plus")

        selectedIconImageView.tintColor = isSelected ?
        UIColor.govUK.text.buttonSuccess :
        UIColor.govUK.text.buttonCompact
    }
}
