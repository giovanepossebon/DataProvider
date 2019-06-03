import RealmSwift

public protocol Repository {
    associatedtype Entity: Object, RealmEntity
    associatedtype EntityType = Entity.EntityType
    
    init(realmConfiguration: Realm.Configuration)
        
    func all(completion: @escaping([Entity.EntityType]) -> Void)
    func find(_ id: Any, completion: @escaping(Entity.EntityType?) -> Void)
    func findResults(completion: @escaping(Results<Entity>?) -> Void)
    func findResults(_ query: NSPredicate, completion: @escaping([Entity.EntityType]) -> Void)
    func insert(item: EntityType, completion: ((_ : Bool, _ error: String?) -> Void)?)
    func insert(items: [EntityType], completion: ((_ : Bool, _ error: String?) -> Void)?)
    func update(item: EntityType, completion: ((_ : Bool, _ error: String?) -> Void)?)
    func deleteAll(completion: ((_ : Bool, _ error: String?) -> Void)?)
    func delete(_ id: Any, completion: ((_ : Bool, _ error: String?) -> Void)?)
}

// DISCUSSION: background transactions working with completions

public class RealmRepository<T>: Repository where T: Object, T: RealmEntity {
    
    public typealias Entity = T
    
    private let realmConfiguration: Realm.Configuration
    
    public let realm: Realm
    
    let background = { (block: @escaping () -> Void) in
        DispatchQueue.global(qos: .background).async(execute: block)
    }
    
    public required init(realmConfiguration: Realm.Configuration) {
        self.realmConfiguration = realmConfiguration
        self.realm = try! Realm(configuration: realmConfiguration)
    }
    
    public func insert(item: T, completion: ((Bool, String?) -> Void)?) {
        background { [weak self] in
            guard let `self` = self else { return }
            
            do {
                let realm = try Realm(configuration: self.realmConfiguration)
                try realm.safeWrite {
                    realm.add(item)
                }
                
                completion?(true, nil)
            } catch {
                completion?(false, error.localizedDescription)
            }
        }
    }
    
    public func insert(items: [T], completion: ((Bool, String?) -> Void)?) {
        background { [weak self] in
            guard let `self` = self else { return }
            
            do {
                let realm = try Realm(configuration: self.realmConfiguration)
                try realm.safeWrite {
                    items.forEach { realm.add($0) }
                }
                
                completion?(true, nil)
            } catch {
                completion?(false, error.localizedDescription)
            }
        }
    }
    
    public func update(item: T, completion: ((Bool, String?) -> Void)?) {
        background { [weak self] in
            guard let `self` = self else { return }
            
            do {
                let realm = try Realm(configuration: self.realmConfiguration)
                try realm.safeWrite {
                    realm.add(item, update: true)
                }
                
                completion?(true, nil)
            } catch {
                completion?(false, error.localizedDescription)
            }
        }
    }
    
    public func all(completion: @escaping ([T.EntityType]) -> Void) {
        background { [weak self] in
            guard let `self` = self else { return }
            
            do {
                let realm = try Realm(configuration: self.realmConfiguration)
                completion(realm.objects(Entity.self).compactMap { $0.entity } ?? [])
            } catch {
                completion([])
            }
        }
    }
    
    public func find(_ id: Any, completion: @escaping (T.EntityType?) -> Void) {
        background { [weak self] in
            guard let `self` = self else { return }
            
            do {
                let realm = try Realm(configuration: self.realmConfiguration)
                completion(realm.object(ofType: Entity.self, forPrimaryKey: id)?.entity)
            } catch {
                completion(nil)
            }
        }
    }
    
    public func findResults(_ query: NSPredicate, completion: @escaping ([T.EntityType]) -> Void) {
        background { [weak self] in
            guard let `self` = self else { return }
            
            do {
                let realm = try Realm(configuration: self.realmConfiguration)
                completion(realm.objects(Entity.self).filter(query).map { $0.entity })
            } catch {
                completion([])
            }
        }
    }
    
    public func findResults(completion: @escaping (Results<T>?) -> Void) {
        background { [weak self] in
            guard let `self` = self else { return }
            
            do {
                let realm = try Realm(configuration: self.realmConfiguration)
                completion(realm.objects(EntityType.self))
            } catch {
                completion(nil)
            }
        }
    }
    
    public func deleteAll(completion: ((Bool, String?) -> Void)?) {
        background { [weak self] in
            guard let `self` = self else { return }
            
            do {
                let realm = try Realm(configuration: self.realmConfiguration)
                try realm.safeWrite {
                    realm.deleteAll()
                }
                
                completion?(true, nil)
            } catch {
                completion?(false, error.localizedDescription)
            }
        }

    }

    public func delete(_ id: Any, completion: ((Bool, String?) -> Void)?) {
        background { [weak self] in
            guard let `self` = self else { return }

            do {
                let realm = try Realm(configuration: self.realmConfiguration)
                
                guard let result = realm.object(ofType: Entity.self, forPrimaryKey: id) else {
                    completion?(false, "There are no entities with \(id) primary key")
                    return
                }
                
                try realm.safeWrite {
                    realm.delete(result)
                }
                
                completion?(true, nil)
            } catch {
                completion?(false, error.localizedDescription)
            }
        }
    }
}


