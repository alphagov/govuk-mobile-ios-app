import Foundation
import ImageIO

extension CGImageSource {
    func pngFrameDuration(at index: Int) -> TimeInterval {
        guard let properties = CGImageSourceCopyPropertiesAtIndex(
            self,
            index,
            nil
        ) as? [CFString: Any],
              let pngProperties = properties[kCGImagePropertyPNGDictionary] as? [CFString: Any],
              let unclampedDelay = pngProperties[kCGImagePropertyAPNGUnclampedDelayTime] as? Double
                ?? pngProperties[kCGImagePropertyAPNGDelayTime] as? Double else {
            return 0.1
        }

        return unclampedDelay < 0.01 ? 0.1 : unclampedDelay
    }
}
