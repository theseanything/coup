import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    let propertyController = PropertyController()
    try router.register(collection: propertyController)

    let issueController = IssueController()
    try router.register(collection: issueController)
}
