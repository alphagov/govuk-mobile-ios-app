import Foundation

@testable import govuk_ios

class MockTimerWrapper: TimerWrapperInterface {
    var lastCreatedTimer: MockTimer?
    func scheduledTimer(withTimeInterval interval: TimeInterval,
                        repeats: Bool,
                        block: @escaping (Timer) -> Void) -> Timer {
        let timer = MockTimer()
        timer.interval = interval
        timer.block = { block(timer) }
        lastCreatedTimer = timer
        return timer
    }
}

class MockTimer: Timer {
    var invalidateCalled = false
    var block: (() -> Void)?
    var interval: TimeInterval = 0

    override func invalidate() {
        invalidateCalled = true
    }

    override static func scheduledTimer(withTimeInterval interval: TimeInterval,
                                        repeats: Bool,
                                        block: @escaping (Timer) -> Void) -> Timer {
        let timer = MockTimer()
        timer.interval = interval
        timer.block = { block(timer) }
        return timer
    }

    override func fire() {
        block?()
    }
}
