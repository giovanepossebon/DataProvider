import RealmSwift

public protocol Repository {
    associatedtype EntityType: Object
    
    init(realm: Realm)
    func all() -> Results<EntityType>?
    func insert(item: EntityType)
}

public class RealmRepository<T>: Repository where T: RealmEntity, T: Object, T.EntityType: Entity {
    typealias RealmEntityType = T
    
    private let realm: Realm
    
    public required init(realm: Realm) {
        self.realm = realm
    }
    
    public func insert(item: T) {
        try? realm.write {
            realm.add(item)
        }
    }
    
    public func all() -> Results<EntityType>? {
        return realm.objects(EntityType.self)
    }
}
