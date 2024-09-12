import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localizedWithFormat(arguments: CVarArg...) -> String {
       return String(format: self.localized, arguments: arguments)
    }
}
