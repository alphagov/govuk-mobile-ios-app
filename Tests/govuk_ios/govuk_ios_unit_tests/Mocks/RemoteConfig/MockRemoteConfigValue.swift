import Foundation
@testable import govuk_ios

struct MockRemoteConfigValue: RemoteConfigValueInterface {

    var stringValue: String
    var boolValue: Bool
    var numberValue: NSNumber
    var isSourceStatic: Bool

    init(stringValue: String = "",
         boolValue: Bool = false,
         numberValue: NSNumber = 0,
         isSourceStatic: Bool = true) {
        self.stringValue = stringValue
        self.boolValue = boolValue
        self.numberValue = numberValue
        self.isSourceStatic = isSourceStatic
    }

}
