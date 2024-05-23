import UIKit
import Foundation

@testable import govuk_ios

class MockCoordinatorBuilder: CoordinatorBuilder {

    var _stubbedRedCoordinator: MockBaseCoordinator?
    override var red: BaseCoordinator {
        _stubbedRedCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedBlueCoordinator: MockBaseCoordinator?
    override var blue: BaseCoordinator {
        _stubbedBlueCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedGreenCoordinator: MockBaseCoordinator?
    override var green: BaseCoordinator {
        _stubbedGreenCoordinator ?? 
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

}
