import Foundation

public class MockNotificationCenter: NotificationCenter,
                                     @unchecked Sendable {

    public var _receivedObservers: [(name: NSNotification.Name, object: Any)] = []
    public override func addObserver(
        forName name: NSNotification.Name?,
        object obj: Any?,
        queue: OperationQueue?,
        using
        block: @escaping (Notification) -> Void) -> any NSObjectProtocol {
            if let name = name, let obj = obj {
                _receivedObservers.append((name: name, object: obj))
            }
            return super.addObserver(
                forName: name,
                object: obj,
                queue: queue,
                using: block
            )
        }

}
