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
                
                let pet = Pet(id: "1", name: "Chewie", age: 6)
                
                let repo = RealmRepository<PetEntity>(realm: testRealm)
                repo.insert(item: PetEntity(entity: pet))
                
                expect(testRealm.objects(PetEntity.self).count).to(equal(1))
                expect(testRealm.objects(PetEntity.self).first?.name) == "Chewie"
                expect(testRealm.objects(PetEntity.self).first?.age) == 6
            }
            
            it("it get all pets in Realm") {
                expect(testRealm.objects(PetEntity.self).count).to(equal(0))
                
                let repo = RealmRepository<PetEntity>(realm: testRealm)
                
                let pet = Pet(id: "1", name: "Chewie", age: 6)
                let pet2 = Pet(id: "2", name: "Luke", age: 3)
                repo.insert(item: PetEntity(entity: pet))
                repo.insert(item: PetEntity(entity: pet2))
                
                expect(repo.all().count).to(equal(2))
            }
            
            describe("getting results with primary key from realm") {
                
                context("and there is a result with primary key") {
                    
                    it("it should get pet by primary key in Realm") {
                        expect(testRealm.objects(PetEntity.self).count).to(equal(0))
                        
                        let repo = RealmRepository<PetEntity>(realm: testRealm)
                        
                        let pet = Pet(id: "3", name: "Han", age: 4)
                        let petEntity = PetEntity(entity: pet)
                        repo.insert(item: petEntity)
                        
                        expect(repo.findByPrimaryKey(petEntity.id)).toNot(beNil())
                        expect(repo.findByPrimaryKey(petEntity.id)?.name) == "Han"
                    }
                    
                }
                
                context("and there's no result with primary key") {
                    
                    it("it shouldn't get any pet in Realm") {
                        expect(testRealm.objects(PetEntity.self).count).to(equal(0))
                        
                        let repo = RealmRepository<PetEntity>(realm: testRealm)
                        
                        let pet = Pet(id: "3", name: "Han", age: 4)
                        let petEntity = PetEntity(entity: pet)
                        repo.insert(item: petEntity)
                        
                        expect(repo.findByPrimaryKey("wrong")).to(beNil())
                    }
                    
                }
            }
        }
        
    }
    
}




