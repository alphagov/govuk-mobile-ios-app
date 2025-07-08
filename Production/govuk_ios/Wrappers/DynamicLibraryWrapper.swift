import MachO

protocol DynamicLibraryInterface {
    func dyldImageCount() -> UInt32
    func dyldGetImageName(_ imageIndex: UInt32) -> UnsafePointer<CChar>!
}

final class DynamicLibraryInterfaceWrapper: DynamicLibraryInterface {
    func dyldImageCount() -> UInt32 {
        return MachO._dyld_image_count()
    }
    func dyldGetImageName(_ imageIndex: UInt32) -> UnsafePointer<CChar>! {
        return MachO._dyld_get_image_name(imageIndex)
    }
}
