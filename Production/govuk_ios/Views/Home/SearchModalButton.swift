import UIKit
import UIComponents

final public class SearchModalButton: UIButton {
    init() {
        super.init(frame: .zero)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let width = titleLabel?.frame.width else { return }
        titleLabel?.preferredMaxLayoutWidth = width
    }

    public override var intrinsicContentSize: CGSize {
        let titlesize = titleLabel?.intrinsicContentSize ?? .zero
        let widthEdgeInserts = contentEdgeInsets.left + contentEdgeInsets.right
        let heightEdgeInserts = contentEdgeInsets.top + contentEdgeInsets.bottom

        return CGSize(
            width: titlesize.width + widthEdgeInserts,
            height: titlesize.height + heightEdgeInserts
        )
    }

    private func configureUI() {
        let image = UIImage(
            systemName: "magnifyingglass"
        )

        adjustsImageSizeForAccessibilityContentSizeCategory = true

        let buttonTitle = String.home.localized("searchButtonTitle")
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.adjustsFontForContentSizeCategory = true
        setTitle(buttonTitle, for: .normal)
        setTitleColor(GOVUKColors.text.secondary, for: .normal)
        titleLabel?.font = UIFont.govUK.body
        titleEdgeInsets.left = 13

        setImage(image, for: .normal)
        imageView?.clipsToBounds = true
        imageView?.tintColor = GOVUKColors.text.secondary
        imageEdgeInsets.left = 8

        contentHorizontalAlignment = .left
        backgroundColor = GOVUKColors.fills.surfaceSearchBox
        layer.cornerRadius = 10
    }
}
