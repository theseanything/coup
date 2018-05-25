import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class Property    : SQLiteModel {
    // Table name
    static let entity = "properties"
    
    /// The unique identifier for this `Property`.
    var id: Int?
    
    /// A title describing what this `Property` entails.
    var address: String
    
    /// Creates a new `Property`.
    init(id: Int? = nil, address: String) {
        self.id = id
        self.address = address
    }
}

/// Allows `Property` to be used as a dynamic migration.
extension Property: Migration {}

/// Allows `Property` to be encoded to and decoded from HTTP messages.
extension Property: Content { }

/// Allows `Property` to be used as a dynamic parameter in route definitions.
extension Property: Parameter { }

extension Property {
    var issues: Children<Property, Issue>{
        return children(\.propertyId)
    }
}
