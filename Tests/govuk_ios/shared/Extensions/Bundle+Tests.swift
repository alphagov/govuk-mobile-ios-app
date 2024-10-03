import Foundation

extension Bundle {
    static var current: Bundle {
        class TestClass { }
        return Bundle(for: TestClass.self)
    }
}
