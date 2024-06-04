import UIKit
import Foundation

class LaunchCoordinator: BaseCoordinator {
    
    private let completion: () -> Void
    private let url:String?
    private let deepLinkPaths:[String]
    
    init(navigationController: UINavigationController,url:String?,
         completion: @escaping () -> Void, paths:[String]) {
        self.completion = completion
        self.url = url
        self.deepLinkPaths = paths
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewController = LaunchViewController()
        set(viewController, animated: false)
        canHandleLinks(path:url) ? handleDeepLink(url:url) : sendCompletion()
    }
    
    private func sendCompletion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.completion()
        }
    }
    
    override func canHandleLinks(path: String?) -> Bool {
        return deepLinkPaths.contains(where: {$0 == path}) ? true : false
    }
    
    override func handleDeepLink(url: String?) { }
}
