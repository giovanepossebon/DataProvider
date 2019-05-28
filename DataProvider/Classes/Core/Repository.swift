import RealmSwift

public protocol Repository {
    associatedtype Entity: Object, RealmEntity
    associatedtype EntityType = Entity.EntityType
    
    init(realm: Realm)
    
    func all() -> [Entity.EntityType]
    func findByPrimaryKey(_ id: Any) -> Entity.EntityType?
    func insert(item: EntityType)
    
    // updateByPrimaryKey
    // deleteAll
    // insert (array)
}

// DISCUSSION: background transactions working with completions

public class RealmRepository<T>: Repository where T: Object, T: RealmEntity {
    public typealias Entity = T
    
    private let realm: Realm
    
    public required init(realm: Realm) {
        self.realm = realm
    }
    
    public func insert(item: T) {
        try? realm.write {
            realm.add(item)
        }
    }
    
    public func all() -> [T.EntityType] {
        return realm.objects(Entity.self).compactMap { $0.entity }
    }
    
    public func findByPrimaryKey(_ id: Any) -> T.EntityType? {
        return realm.object(ofType: Entity.self, forPrimaryKey: id)?.entity
    }
}
