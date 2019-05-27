public protocol Entity { }

public protocol RealmEntity {
    associatedtype EntityType

    var entity: EntityType { get }
}
