import FluentSQLite
import Vapor

/// A single entry of a Issue list.
final class Issue: SQLiteModel {
    /// The unique identifier for this `Issue`.
    var id: Int?
    
    var title: String
    var description: String
    var upVotes: Int = 0
    var downVotes: Int = 0
    var propertyId: Property.ID

    /// Creates a new `Issue`.
    init(id: Int? = nil, title: String, description: String, propertyId: Property.ID) {
        self.id = id
        self.title = title
        self.description = description
        self.propertyId = propertyId
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id)
        self.title = try values.decode(String.self, forKey: .title)
        self.description = try values.decode(String.self, forKey: .description)
        self.propertyId = try values.decode(Int.self, forKey: .propertyId)
    }
}

/// Allows `Issue` to be used as a dynamic migration.
extension Issue: Migration {
    static func prepare(on connection: SQLiteConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.addField(type: SQLiteFieldType.text, name: "upVotes")
            builder.addField(type: SQLiteFieldType.text, name: "downVotes")
        }
    }
}

/// Allows `Issue` to be encoded to and decoded from HTTP messages.
extension Issue: Content { }

/// Allows `Issue` to be used as a dynamic parameter in route definitions.
extension Issue: Parameter { }

extension Issue {
    var property: Parent<Issue, Property> {
        return parent(\.propertyId)
    }
}
