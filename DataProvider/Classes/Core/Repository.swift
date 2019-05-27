import RealmSwift

public protocol Repository {
    associatedtype EntityType
    
    func all() -> [EntityType]
    func insert(item: EntityType)
}

public class RealmRepository<T>: Repository where T: RealmEntity, T: Object, T.EntityType: Entity {
    typealias RealmEntityType = T
    
    private let realm = try! Realm()
    
    public init() {}
    
    public func insert(item: T.EntityType) {
        try? realm.write {
            realm.add(Object(value: item))
        }
    }
    
    public func all() -> [T.EntityType] {
        return realm.objects(T.self).compactMap { $0.entity }
    }
}
