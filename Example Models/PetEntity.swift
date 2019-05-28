import DataProvider
import RealmSwift

public class PetEntity: Object, RealmEntity {
    public typealias EntityType = Pet
    
    @objc public dynamic var id = UUID().uuidString
    @objc public dynamic var name = ""
    @objc public dynamic var age = 0
    
    public convenience init(entity: EntityType) {
        self.init()
        self.name = entity.name
        self.age = entity.age
    }
    
    public var entity: Pet {
        return Pet(id: id,
                   name: self.name,
                   age: self.age)
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
}
