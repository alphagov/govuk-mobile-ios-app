import SwiftUI

extension EnvironmentValues {
    var isTesting: Bool {
        get { self[IsTestingKey.self] }
        set { self[IsTestingKey.self] = newValue }
    }
}

private struct IsTestingKey: EnvironmentKey {
    static let defaultValue: Bool = false
}
