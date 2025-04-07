import Foundation

protocol WebViewModel {
    var url: URL { get }
    var title: String? { get }
    var rightBarButtonTitle: String? { get }
    var javascript: String? { get }

    func didAppear()
    func didDismiss()
}

struct ExampleWebViewModel: WebViewModel {
    let url: URL
    let title: String?
    let rightBarButtonTitle: String? = "Done"
    let javascript: String? = nil

    let appearAction: () -> Void
    let dismissAction: () -> Void

    func didAppear() {
        appearAction()
    }

    func didDismiss() {
        dismissAction()
    }
}
