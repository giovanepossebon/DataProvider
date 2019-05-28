import Quick
import Nimble
import DataProvider
import RealmSwift

final class RepositoryTests: QuickSpec {
    
    override func spec() {
        
        describe("RepositoryTests") {
            
            var testRealm: Realm!
            
            beforeEach{
                testRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "pet-realm"))
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
                repo.insert(item: PetEntity(entity: pet))
                
                expect(testRealm.objects(PetEntity.self).count).to(equal(1))
                expect(testRealm.objects(PetEntity.self).first?.name) == "Chewie"
                expect(testRealm.objects(PetEntity.self).first?.age) == 6
            }
            
            it("it get all pets in Realm") {
                expect(testRealm.objects(PetEntity.self).count).to(equal(0))
                
                let repo = RealmRepository<PetEntity>(realm: testRealm)
                
                let pet = Pet(name: "Chewie", age: 6)
                repo.insert(item: PetEntity(entity: pet))
                repo.insert(item: PetEntity(entity: pet))
                
                expect(repo.all().count).to(equal(2))
            }
            
        }
        
    }
    
}




