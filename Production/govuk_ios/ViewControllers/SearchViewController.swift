import UIKit

class SearchViewController: BaseViewController {
    private let viewModel: SearchViewModel

    private lazy var modalView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
//        navigationItem.largeTitleDisplayMode = .always
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureConstraints()
        configureUI()
    }

    private func configureUI() {
        view.addSubview(modalView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            modalView.heightAnchor.constraint(equalToConstant: view.bounds.height)
        ])
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
}
