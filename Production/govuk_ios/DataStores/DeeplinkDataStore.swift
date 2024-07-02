//

import Foundation

struct DeeplinkDataStore {

    private let routes: DeeplinkRoute
    init(routes: DeeplinkRoute) {
        self.routes = routes
    }

}

protocol DeeplinkRoute {

}

struct TestDeeplinkRoute {


}
