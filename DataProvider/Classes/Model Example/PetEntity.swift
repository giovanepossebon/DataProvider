import DataProvider
import RealmSwift
import Fakery

public class PetEntity: Object, RealmEntity {
    public typealias EntityType = Pet
    
    @objc public dynamic var id = UUID().uuidString
    @objc public dynamic var name = ""
    @objc public dynamic var age = 0
    
    public convenience init(entity: EntityType) {
        self.init()
        self.id = entity.id
        self.name = entity.name
        self.age = entity.age
    }
    
    public var entity: Pet {
        return Pet(id: id,
                   name: name,
                   age: age)
    }
    
    public static var mock: Pet {
        let faker = Faker()
        return Pet(id: faker.lorem.word(),
                   name: faker.name.firstName(),
                   age: faker.number.randomInt(min: 0, max: 12))
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
}
