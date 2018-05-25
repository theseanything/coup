import Vapor

/// Controlers basic CRUD operations on `Property`s.
final class PropertyController : RouteCollection {
    func boot(router: Router) throws {
        let propertyRoutes = router.grouped("properties")
        propertyRoutes.get(use: index)
        propertyRoutes.delete(Property.parameter, use: delete)
        propertyRoutes.post(Property.self, use: create)
    }
    
    /// Returns a list of all `Property`s.
    func index(_ req: Request) throws -> Future<[Property]> {
        return Property.query(on: req).all()
    }
    
    /// Saves a decoded `Property` to the database.
    func create(_ req: Request, property: Property) throws -> Future<Property> {
        return property.save(on: req)
    }
    
    /// Deletes a parameterized `Property`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Property.self).flatMap(to: Void.self) { property in
            return property.delete(on: req)
            }.transform(to: .ok)
    }
}
