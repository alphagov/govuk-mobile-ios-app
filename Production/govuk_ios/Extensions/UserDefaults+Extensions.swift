//

import Foundation

extension UserDefaults {
    func saveDeepLinkPath(for deepLinkPath: String) {
      setValue(deepLinkPath, forKey: "deepLinkPath")
    }

    var deepLinkPath: String? {
      guard let link = string(forKey: "deepLinkPath") else { return nil }
      return link
    }
}
