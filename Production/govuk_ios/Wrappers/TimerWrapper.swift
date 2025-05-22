import Foundation

protocol TimerWrapperInterface {
    func scheduledTimer(withTimeInterval interval: TimeInterval,
                        repeats: Bool,
                        block: @escaping (Timer) -> Void) -> Timer
}

class TimerWrapper: TimerWrapperInterface {
    func scheduledTimer(withTimeInterval interval: TimeInterval,
                        repeats: Bool,
                        block: @escaping (Timer) -> Void) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
    }
}
