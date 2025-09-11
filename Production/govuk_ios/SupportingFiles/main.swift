import UIKit
import Foundation

let klass: AnyClass = NSClassFromString("TestAppDelegate") ??
                      AppDelegate.self

let classString = NSStringFromClass(klass)

let rawPointer = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
let argv = rawPointer.bindMemory(
    to: UnsafeMutablePointer<Int8>.self,
    capacity: Int(CommandLine.argc)
)
_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, classString)
