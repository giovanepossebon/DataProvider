import RealmSwift

public protocol Repository {
    associatedtype EntityType
    
    init(realm: Realm)
    func all() -> [EntityType]
    func insert(item: EntityType)
}

public class RealmRepository<T>: Repository where T: RealmEntity, T: Object, T.EntityType: Entity {
    typealias RealmEntityType = T
    
    private let realm: Realm
    
    public required init(realm: Realm) {
        self.realm = realm
    }
    
    public func insert(item: T.EntityType) {
        try? realm.write {
            realm.add(Object(value: item))
        }
    }
    
    public func all() -> [T.EntityType] {
        return realm.objects(T.self).compactMap { $0.entity }
    }
}
