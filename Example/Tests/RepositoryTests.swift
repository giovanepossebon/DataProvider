import Quick
import Nimble
import DataProvider
import RealmSwift

final class RepositoryTests: QuickSpec {
    
    override func spec() {
        
        describe("RepositoryTests") {
            
            var testRealm: Realm!
            
            beforeEach{
                let objectTypes = [PetEntity.self]
                testRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "pet-realm", objectTypes: objectTypes))
            }
            
            afterEach {
                try! testRealm.write {
                    testRealm.deleteAll()
                }
            }
            
            it("it adds a pet to the Realm") {
                expect(testRealm.objects(PetEntity.self).count).to(equal(0))
                
                let pet = Pet(name: "Chewie", age: 6)
                let repo = RealmRepository<PetEntity>(realm: testRealm)
                repo.insert(item: pet)
                
                expect(testRealm.objects(PetEntity.self).count).to(equal(1))
                expect(testRealm.objects(PetEntity.self).first?.name) == "Chewie"
                expect(testRealm.objects(PetEntity.self).first?.age) == 6
            }
            
        }
        
    }
    
}

class PetEntity: Object, RealmEntity {
    typealias EntityType = Pet
    
    dynamic var name = ""
    dynamic var age = 0
    
    public convenience init(entity: EntityType) {
        self.init()
        self.name = entity.name
        self.age = entity.age
    }
    
    var entity: Pet {
        return Pet(name: self.name,
                   age: self.age)
    }
    
}

struct Pet: Entity {
    let name: String
    let age: Int
}
