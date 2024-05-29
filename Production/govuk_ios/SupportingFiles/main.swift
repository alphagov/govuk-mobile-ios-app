import UIKit
import Foundation

let klass: AnyClass = NSClassFromString("govuk_ios_unit_tests.TestAppDelegate") ??
                      AppDelegate.self

let classString = NSStringFromClass(klass)

let rawPointer = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
let argv = rawPointer.bindMemory(to: UnsafeMutablePointer<Int8>.self,
                                 capacity: Int(CommandLine.argc))
_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, classString)
