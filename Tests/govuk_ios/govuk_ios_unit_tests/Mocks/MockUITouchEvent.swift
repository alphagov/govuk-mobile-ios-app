import Foundation
import UIKit

class MockUITouchEvent: UIEvent {
    override var type: UIEvent.EventType {
        return .touches
    }
}
