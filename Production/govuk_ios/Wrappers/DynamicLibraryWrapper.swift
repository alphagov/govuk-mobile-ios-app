import MachO

protocol DynamicLibraryInterface {
    func dyldImageCount() -> UInt32
    // swiftlint:disable:next identifier_name
    func dyldGetImageName(_ image_index: UInt32) -> UnsafePointer<CChar>!
}

final class DynamicLibraryInterfaceWrapper: DynamicLibraryInterface {
    func dyldImageCount() -> UInt32 {
        return MachO._dyld_image_count()
    }
    // swiftlint:disable:next identifier_name
    func dyldGetImageName(_ image_index: UInt32) -> UnsafePointer<CChar>! {
        return MachO._dyld_get_image_name(image_index)
    }
}
