import UIKit

class TestViewController: BaseViewController {
    private let color: UIColor
    private let nextAction: () -> Void
    private let modalAction: () -> Void

    private lazy var nextButton: UIButton = {
        let localView = UIButton(frame: .zero)
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.setTitle("Next", for: .normal)
        localView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        localView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        localView.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return localView
    }()

    private lazy var modalButton: UIButton = {
        let localView = UIButton(frame: .zero)
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.setTitle("Modal", for: .normal)
        localView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        localView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        localView.addTarget(self, action: #selector(modalButtonPressed), for: .touchUpInside)
        return localView
    }()

    private lazy var testLabel: UILabel = {
        let localView = Label()
        localView.dynamicFont = UIFont.govuk.body
        localView.text = "Hello World"
        localView.adjustsFontForContentSizeCategory = true
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    init(color: UIColor,
         tabTitle: String,
         nextAction: @escaping () -> Void,
         modalAction: @escaping () -> Void) {
        self.color = color
        self.nextAction = nextAction
        self.modalAction = modalAction
        super.init(nibName: nil, bundle: nil)
        self.title = tabTitle
        navigationItem.largeTitleDisplayMode = .always
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
        view.addSubview(nextButton)
        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(modalButton)
        modalButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor,
                                        constant: 30).isActive = true
        modalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(testLabel)
        testLabel.topAnchor.constraint(equalTo: modalButton.bottomAnchor,
                                         constant: 30).isActive = true
        testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc
    private func buttonPressed() {
        nextAction()
    }

    @objc
    private func modalButtonPressed() {
        modalAction()
    }
}
