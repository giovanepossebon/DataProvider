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
                repo.insert(item: PetEntity(entity: pet), completion: nil)
                
                expect(testRealm.objects(PetEntity.self).count).to(equal(1))
                expect(testRealm.objects(PetEntity.self).first?.name) == "Chewie"
                expect(testRealm.objects(PetEntity.self).first?.age) == 6
            }
            
            it("it edit a pet in the Realm") {
                expect(testRealm.objects(PetEntity.self).count).to(equal(0))
                
                let pet = PetEntity.mock
                let repo = RealmRepository<PetEntity>(realm: testRealm)
                repo.insert(item: PetEntity(entity: pet), completion: nil)
                
                expect(testRealm.objects(PetEntity.self).count).to(equal(1))
                
                let petToEdit = repo.findResults(pet.id)
                
                guard let oldPet = petToEdit.first else {
                    fail("cant find any pet")
                    return
                }
                
                let newPet = Pet(id: oldPet.id, name: "Chewie", age: oldPet.age)
                
                repo.update(item: PetEntity(entity: newPet), completion: nil)
                
                expect(testRealm.objects(PetEntity.self).count).to(equal(1))
                expect(testRealm.objects(PetEntity.self).first?.name) == "Chewie"
            }
            
            it("it deletes all objects from the Realm") {
                expect(testRealm.objects(PetEntity.self).count).to(equal(0))
                
                let repo = RealmRepository<PetEntity>(realm: testRealm)
                
                var pets: [Pet] = []
                for _ in 1...5 {
                    pets.append(PetEntity.mock)
                }
                
                repo.insert(items: pets.map { PetEntity(entity: $0) }, completion: nil)
                expect(testRealm.objects(PetEntity.self).count).to(equal(5))
                
                repo.deleteAll(completion: nil)
                expect(testRealm.objects(PetEntity.self).count).to(equal(0))
            }
            
            it("it adds an array of pets to the Realm") {
                expect(testRealm.objects(PetEntity.self).count).to(equal(0))
                
                let repo = RealmRepository<PetEntity>(realm: testRealm)
                
                var pets: [Pet] = []
                for _ in 1...5 {
                    pets.append(PetEntity.mock)
                }
                
                repo.insert(items: pets.map { PetEntity(entity: $0) }, completion: nil)
                
                expect(testRealm.objects(PetEntity.self).count).to(equal(5))
            }
            
            it("it get all pets in Realm") {
                expect(testRealm.objects(PetEntity.self).count).to(equal(0))
                
                let repo = RealmRepository<PetEntity>(realm: testRealm)
                
                let pet = Pet(id: "1", name: "Chewie", age: 6)
                let pet2 = Pet(id: "2", name: "Luke", age: 3)
                repo.insert(item: PetEntity(entity: pet), completion: nil)
                repo.insert(item: PetEntity(entity: pet2), completion: nil)
                
                expect(repo.all().count).to(equal(2))
            }
            
            describe("getting results with primary key from realm") {
                
                context("and there is a result with primary key") {
                    
                    it("it should get pet by primary key in Realm") {
                        expect(testRealm.objects(PetEntity.self).count).to(equal(0))
                        
                        let repo = RealmRepository<PetEntity>(realm: testRealm)
                        
                        let pet = Pet(id: "3", name: "Han", age: 4)
                        let petEntity = PetEntity(entity: pet)
                        repo.insert(item: petEntity, completion: nil)
                        
                        expect(repo.find(petEntity.id)).toNot(beNil())
                        expect(repo.find(petEntity.id)?.name) == "Han"
                    }
                    
                }
                
                context("and there's no result with primary key") {
                    
                    it("it shouldn't get any pet in Realm") {
                        expect(testRealm.objects(PetEntity.self).count).to(equal(0))
                        
                        let repo = RealmRepository<PetEntity>(realm: testRealm)
                        
                        let pet = Pet(id: "3", name: "Han", age: 4)
                        let petEntity = PetEntity(entity: pet)
                        repo.insert(item: petEntity, completion: nil)
                        
                        expect(repo.find("wrong")).to(beNil())
                    }
                    
                }
            }
        }
        
    }
    
}
