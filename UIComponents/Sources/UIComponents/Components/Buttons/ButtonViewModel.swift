import Foundation

extension GOVUKButton {
    public struct ButtonViewModel {
        public let localisedTitle: String
        public let action: () -> Void

        public init(localisedTitle: String,
                    action: @escaping () -> Void) {
            self.localisedTitle = localisedTitle
            self.action = action
        }
    }
}
