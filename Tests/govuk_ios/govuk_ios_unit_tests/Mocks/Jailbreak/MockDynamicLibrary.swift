import Foundation
@testable import govuk_ios

final class MockDynamicLibrary: DynamicLibraryInterface {

    var _stubbedDyldImageCount: UInt32 = 0
    func dyldImageCount() -> UInt32 {
        _stubbedDyldImageCount
    }

    var _stubbedImageName: String = ""
    func dyldGetImageName(_ imageIndex: UInt32) -> UnsafePointer<CChar>! {
        _stubbedImageName.withCString { ptr in
            return ptr
        }
    }
}
