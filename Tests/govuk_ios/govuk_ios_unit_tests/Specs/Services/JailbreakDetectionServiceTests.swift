import UIKit
import Testing


@testable import govuk_ios

final class JailbreakDetectionServiceTests {

    var mockFileManager: MockFileManager!
    var mockURLOpener: MockJailbreakURLOpener!
    var mockDyamicLibrary: MockDynamicLibrary!

    init() {
        mockFileManager = MockFileManager()
        mockURLOpener = MockJailbreakURLOpener()
        mockDyamicLibrary = MockDynamicLibrary()
    }

    deinit {
        mockFileManager = nil
        mockURLOpener = nil
        mockDyamicLibrary = nil
    }

    @Test
    func forbiddenFileDetected_returnsCorrectResult() {
        mockFileManager._stubbedFilePaths = [
            "/Applications/Cydia.app",
            "/Applications/Harmless.app"
        ]

        let sut = JailbreakDetectionService(
            fileManager: mockFileManager,
            urlOpener: mockURLOpener
        )

        #expect(sut.checkFiles())
    }

    @Test
    func noForbiddenFileDetected_returnsCorrectResult() {
        mockFileManager._stubbedFilePaths = [
            "/Applications/Benign.app",
            "/Applications/Harmless.app"
        ]

        let sut = JailbreakDetectionService(
            fileManager: mockFileManager,
            urlOpener: mockURLOpener
        )
        
        #expect(!sut.checkFiles())
    }

    @Test
    func forbiddenURLDetected_returnsCorrectResult() {
        mockURLOpener._openableURLS = ["cydia://"]
        
        let sut = JailbreakDetectionService(
            fileManager: mockFileManager,
            urlOpener: mockURLOpener
        )
        
        #expect(sut.checkURLSchemes())
    }

    @Test
    func allowedURLDetected_returnsCorrectResult() {
        mockURLOpener._openableURLS = ["govuk://services"]

        let sut = JailbreakDetectionService(
            fileManager: mockFileManager,
            urlOpener: mockURLOpener
        )

        #expect(!sut.checkURLSchemes())
    }

    @Test
    func fileSystemPrivileges_returnsCorrectResult() {
        let sut = JailbreakDetectionService(
            fileManager: mockFileManager,
            urlOpener: mockURLOpener
        )

        #expect(!sut.checkSandboxPriveleges())
    }

    @Test
    func forbiddenDynamicLibraries_returnsCorrectResult() {
        mockDyamicLibrary._stubbedDyldImageCount = 1
        mockDyamicLibrary._stubbedImageName = "FridaGadget"
        let sut = JailbreakDetectionService(
            fileManager: mockFileManager,
            dynamicLibrary: mockDyamicLibrary,
            urlOpener: mockURLOpener
        )
        
        #expect(sut.checkDynamicLibraries())
    }

    @Test
    func noForbiddenDynamicLibraries_returnsCorrectResult() {
        mockDyamicLibrary._stubbedDyldImageCount = 1
        mockDyamicLibrary._stubbedImageName = "BenignLibrary"
        let sut = JailbreakDetectionService(
            fileManager: mockFileManager,
            dynamicLibrary: mockDyamicLibrary,
            urlOpener: mockURLOpener
        )

        #expect(!sut.checkDynamicLibraries())
    }
}
