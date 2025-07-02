import UIKit
import GOVKit
import MachO

protocol JailbreakDetectionServiceInterface {
    func isJailbroken() -> Bool
}

final class JailbreakDetectionService: JailbreakDetectionServiceInterface {
    private let fileManager: FileManagerInterface
    private let dynamicLibrary: DynamicLibraryInterface
    private let urlOpener: URLOpener

    init(fileManager: FileManagerInterface = FileManager.default,
         dynamicLibrary: DynamicLibraryInterface = DynamicLibraryInterfaceWrapper(),
         urlOpener: URLOpener) {
        self.fileManager = fileManager
        self.dynamicLibrary = dynamicLibrary
        self.urlOpener = urlOpener
    }

    @inline(__always)
    func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
            return false
        #else
            let result = checkFiles() ||
            checkDynamicLibraries() ||
            checkSandboxPriveleges() ||
            checkURLSchemes()
        return result
        #endif
    }

    func checkFiles() -> Bool {
        return !Self.forbiddenFiles.allSatisfy { !fileManager.fileExists(atPath: $0) }
    }

    func checkDynamicLibraries() -> Bool {
        for index in 0..<dynamicLibrary.dyldImageCount() {
            guard let imageName = dynamicLibrary.dyldGetImageName(index),
                  let libraryName = String(validatingUTF8: imageName) else {
                continue
            }

            let lowercasedLibraryName = libraryName.lowercased()
            if Self.forbiddenDYLD.contains(
                where: { lowercasedLibraryName.contains($0) }
            ) {
                return true
            }
        }
        return false
    }

    func checkSandboxPriveleges() -> Bool {
        let testText = "Jailbreak test"
        for path in Self.forbiddenPaths {
            do {
                try testText.write(
                    toFile: path,
                    atomically: true,
                    encoding: .utf8
                )
                try? fileManager.removeItem(atPath: path)
                return true
            } catch {
                continue
            }
        }
        return false
    }

    func checkURLSchemes() -> Bool {
        for urlScheme in Self.forbiddenURLSchemes {
            if let url = URL(string: urlScheme),
               urlOpener.canOpenURL(url) {
                return true
            }
        }
        return false
    }

    private static var forbiddenFiles: [String] {
        [
            "/.bootstrapped_electra",
            "/.cydia_no_stash",
            "/.installed_unc0ver",
            "/Applications/blackra1n.app",
            "/Applications/Cydia.app",
            "/Applications/FakeCarrier.app",
            "/Applications/HideJB.app",
            "/Applications/Icy.app",
            "/Applications/IntelliScreen.app",
            "/Applications/MxTube.app",
            "/Applications/RockApp.app",
            "/Applications/SBSettings.app",
            "/Applications/SBSetttings.app",
            "/Applications/Sileo.app",
            "/Applications/Snoop-itConfig.app",
            "/Applications/WinterBoard.app",
            "/bin.sh",
            "/bin/bash",
            "/bin/sh",
            "/etc/apt",
            "/etc/apt/sources.list.d/electra.list",
            "/etc/apt/sources.list.d/sileo.sources",
            "/etc/apt/undecimus/undecimus.list",
            "/etc/ssh/sshd_config",
            "/jb/amfid_payload.dylib",
            "/jb/jailbreakd.plist",
            "/jb/libjailbreak.dylib",
            "/jb/lzma",
            "/jb/offsets.plist",
            "/Library/dpkg/info/re.frida.server.list",
            "/Library/LaunchDaemons/re.frida.server.plist",
            "/Library/MobileSubstrate/CydiaSubstrate.dylib",
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
            "/Library/MobileSubstrate/HideJB.dylib",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/Library/PreferenceBundles/ABypassPrefs.bundle",
            "/Library/PreferenceBundles/FlyJBPrefs.bundle",
            "/Library/PreferenceBundles/HideJBPrefs.bundle",
            "/Library/PreferenceBundles/LibertyPref.bundle",
            "/Library/PreferenceBundles/ShadowPreferences.bundle",
            "/private/etc/apt",
            "/private/etc/dpkg/origins/debian",
            "/private/etc/ssh/sshd_config",
            "/private/var/cache/apt/",
            "/private/var/lib/apt",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/log/syslog",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/private/var/mobileLibrary/SBSettingsThemes/",
            "/private/var/stash",
            "/private/var/tmp/cydia.log",
            "/private/var/Users/",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            "/usr/bin/cycript",
            "/usr/bin/ssh",
            "/usr/bin/sshd",
            "/usr/lib/libcycript.dylib",
            "/usr/lib/libhooker.dylib",
            "/usr/lib/libjailbreak.dylib",
            "/usr/lib/libsubstitute.dylib",
            "/usr/lib/substrate",
            "/usr/lib/TweakInject",
            "/usr/libexec/cydia/",
            "/usr/libexec/cydia/firmware.sh",
            "/usr/libexec/sftp-server",
            "/usr/libexec/ssh-keysign",
            "/usr/local/bin/cycript",
            "/usr/sbin/frida-server",
            "/usr/sbin/sshd",
            "/usr/share/jailbreak/injectme.plist",
            "/var/binpack",
            "/var/cache/apt",
            "/var/checkra1n.dmg",
            "/var/lib/apt",
            "/var/lib/cydia",
            "/var/lib/dpkg/info/mobilesubstrate.md5sums",
            "/var/log/apt",
            "/var/log/syslog",
            "/var/tmp/cydia.log"
        ]
    }

    private static var forbiddenPaths: [String] {
        [
            "/",
            "/root/",
            "/private/",
            "/jb/"
        ]
    }

    private static var forbiddenDYLD: [String] {
        [
            "fridagadget",
            "frida",
            "cynject",
            "libcycript"
        ]
    }

    private static var forbiddenURLSchemes: [String] {
        [
            "undecimus://",
            "sileo://",
            "zbra://",
            "filza://",
            "cydia://"
        ]
    }
}

protocol FileManagerInterface {
    func fileExists(atPath: String) -> Bool
    func removeItem(atPath path: String) throws
}

extension FileManager: FileManagerInterface {}
