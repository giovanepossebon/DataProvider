import RealmSwift

public protocol Repository {
    associatedtype Entity: Object, RealmEntity
    associatedtype EntityType = Entity.EntityType
    
    init(realm: Realm)
    
    func all() -> [Entity.EntityType]
    func find(_ id: Any) -> Entity.EntityType?
    func findResults(_ id: Any) -> Results<Entity>
    func findResults(_ query: NSPredicate) -> [Entity.EntityType]
    func insert(item: EntityType, completion: ((_ : Bool, _ error: String?) -> Void)?)
    func insert(items: [EntityType], completion: ((_ : Bool, _ error: String?) -> Void)?)
    func update(item: EntityType, completion: ((_ : Bool, _ error: String?) -> Void)?)
    func deleteAll(completion: ((_ : Bool, _ error: String?) -> Void)?)
    func delete(_ id: Any, completion: ((_ : Bool, _ error: String?) -> Void)?)
}

// DISCUSSION: background transactions working with completions

public class RealmRepository<T>: Repository where T: Object, T: RealmEntity {
    
    public typealias Entity = T
    
    private let realm: Realm
    
    public required init(realm: Realm) {
        self.realm = realm
    }
    
    public func insert(item: T, completion: ((Bool, String?) -> Void)?) {
        do {
            try realm.safeWrite {
                realm.add(item)
            }
        } catch {
            completion?(false, error.localizedDescription)
        }
        
        completion?(true, nil)
    }
    
    public func insert(items: [T], completion: ((Bool, String?) -> Void)?) {
        items.forEach { item in
            do {
                try realm.safeWrite {
                    realm.add(item)
                }
            } catch {
                completion?(false, error.localizedDescription)
            }
        }
        
        completion?(true, nil)
    }
    
    public func update(item: T, completion: ((Bool, String?) -> Void)?) {
        do {
            try realm.safeWrite {
                realm.add(item, update: true)
            }
        } catch {
            completion?(false, error.localizedDescription)
        }
        
        completion?(true, nil)
    }
    
    public func all() -> [T.EntityType] {
        return realm.objects(Entity.self).compactMap { $0.entity }
    }
    
    public func find(_ id: Any) -> T.EntityType? {
        return realm.object(ofType: Entity.self, forPrimaryKey: id)?.entity
    }
    
    public func findResults(_ id: Any) -> Results<T> {
        return realm.objects(Entity.self)
    }
    
    public func findResults(_ query: NSPredicate) -> [T.EntityType] {
        return realm.objects(Entity.self).filter(query).map { $0.entity }
    }
    
    public func deleteAll(completion: ((Bool, String?) -> Void)?) {
        let result = realm.objects(Entity.self)
        
        result.forEach { item in
            do {
                try realm.safeWrite {
                    realm.delete(item)
                }
            } catch {
                completion?(false, error.localizedDescription)
            }
        }
        
        completion?(true, nil)
    }

    public func delete(_ id: Any, completion: ((Bool, String?) -> Void)?) {
        guard let result = realm.object(ofType: Entity.self, forPrimaryKey: id) else {
            completion?(false, "There are no entities with \(id) primary key")
            return
        }
        
        do {
            try realm.safeWrite {
                realm.delete(result)
            }
        } catch {
            completion?(false, error.localizedDescription)
        }
        
        completion?(true, nil)
    }
}


