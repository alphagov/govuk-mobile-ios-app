import Foundation

protocol DeeplinkServiceInterface {
    func handle(url: String?,
                completion: @escaping () -> Void)
}

struct DeeplinkService: DeeplinkServiceInterface {
    func handle(url: String?,
                completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion()
        }
    }
}
