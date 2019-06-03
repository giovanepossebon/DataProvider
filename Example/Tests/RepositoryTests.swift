import Quick
import Nimble
import DataProvider
import RealmSwift

final class RepositoryTests: QuickSpec {
    
    override func spec() {
        
        describe("RepositoryTests") {
            
            var repo: RealmRepository<PetEntity>!
            
            describe("Adding pet to the Realm") {
                
                it("it should add a pet to the Realm") {
                    let repo = RealmRepository<PetEntity>(realmConfiguration: Realm.Configuration(inMemoryIdentifier: "pet-realm5"))
                    
                    let pet = Pet(id: "1", name: "Chewie", age: 6)
                    
                    repo.insert(item: PetEntity(entity: pet), completion: { _, _ in
                        repo.all(completion: { pets in
                            expect(pets.count).to(equal(1))
                            expect(pets.first?.name) == "Chewie"
                            expect(pets.first?.age) == 6
                        })
                    })
                }
            }
            
            describe("Editing a pet of the Realm") {
                
                it("it edit a pet in the Realm") {
                    let repo = RealmRepository<PetEntity>(realmConfiguration: Realm.Configuration(inMemoryIdentifier: "pet-realm"))
                    
                    let pet = PetEntity.mock
                    let petEntity = PetEntity(entity: pet)
                    repo.insert(item: petEntity, completion: { _, _ in
                        repo.find(petEntity.id, completion: { result in
                            guard let oldPet = result else {
                                fail("cant find any pet")
                                return
                            }
                            
                            let newPet = Pet(id: oldPet.id, name: "Chewie", age: oldPet.age)
                            
                            repo.update(item: PetEntity(entity: newPet), completion: { _, _ in
                                repo.all(completion: { pets in
                                    expect(pets.count).to(equal(1))
                                    expect(pets.first?.name) == "Chewie"
                                })
                            })
                        })
                    })
                }
            }
            

            describe("Deleting all pet from the Realm") {
                
                it("it should deletes all pets from the Realm") {
                    let repo = RealmRepository<PetEntity>(realmConfiguration: Realm.Configuration(inMemoryIdentifier: "pet-realm1"))
                    
                    var pets: [Pet] = []
                    for _ in 1...5 {
                        pets.append(PetEntity.mock)
                    }
                    
                    repo.insert(items: pets.map { PetEntity(entity: $0) }, completion: { _, _ in
                        repo.all(completion: { pets in
                            expect(pets.count).to(equal(5))
                            
                            repo.deleteAll(completion: { _, _ in
                                repo.all(completion: { pets in
                                    expect(pets.count).to(equal(0))
                                })
                            })
                        })
                    })
                }
            }

            describe("Deleting a pet from the Realm") {
                
                it("it should delete a pet from the Realm") {
                    let repo = RealmRepository<PetEntity>(realmConfiguration: Realm.Configuration(inMemoryIdentifier: "pet-realm8"))
                    
                    let pet = Pet(id: "2", name: "Luke", age: 3)
                    let petEntity = PetEntity(entity: pet)
                    repo.insert(item: petEntity, completion: { _, _ in
                        repo.all(completion: { pets in
                            expect(pets.count).to(equal(1))
                            
                            repo.delete(petEntity.id, completion: { _, _ in
                                repo.all(completion: { pets in
                                    expect(pets.count).to(equal(0))
                                })
                            })
                        })
                    })
                }
            }

            describe("Adding a group of pets to the Realm") {
                
                it("it should add an group of pets to the Realm") {
                    let repo = RealmRepository<PetEntity>(realmConfiguration: Realm.Configuration(inMemoryIdentifier: "pet-realm3"))
                    
                    var pets: [Pet] = []
                    for _ in 1...5 {
                        pets.append(PetEntity.mock)
                    }
                    
                    repo.insert(items: pets.map { PetEntity(entity: $0) }, completion: { _, _ in
                        repo.all(completion: { pets in
                            expect(pets.count).to(equal(5))
                        })
                    })
                }
            }
            
            describe("Getting all pets of the Realm") {
            
                it("it should get all pets in Realm") {
                    let repo = RealmRepository<PetEntity>(realmConfiguration: Realm.Configuration(inMemoryIdentifier: "pet-realm4"))
                    
                    let pets = [Pet(id: "1", name: "Chewie", age: 6),
                                Pet(id: "2", name: "Luke", age: 3)]
                    
                    repo.insert(items: pets.map { PetEntity(entity: $0) }, completion: { _, _ in
                        repo.all(completion: { pets in
                            expect(pets.count).to(equal(2))
                        })
                    })
                }
            }

            describe("Finding a pet with filter in the Realm") {
                
                it("it should find pets with a filter in the Realm") {
                    let repo = RealmRepository<PetEntity>(realmConfiguration: Realm.Configuration(inMemoryIdentifier: "pet-realm9"))
                    let pets = [Pet(id: "1", name: "Chewie", age: 6),
                                Pet(id: "2", name: "Luke", age: 3)]
                    
                    repo.insert(items: pets.map { PetEntity(entity: $0) }, completion: { _, _ in
                        repo.findResults(NSPredicate(format: "name = %@", "Chewie"), completion: { pets in
                            expect(pets.first?.id) == "1"
                        })
                    })
                }
            }


            describe("getting results with primary key from realm") {

                context("and there is a result with primary key") {

                    it("it should get pet by primary key in Realm") {
                        let repo = RealmRepository<PetEntity>(realmConfiguration: Realm.Configuration(inMemoryIdentifier: "pet-realm10"))

                        let pet = Pet(id: "3", name: "Han", age: 4)
                        let petEntity = PetEntity(entity: pet)
                        repo.insert(item: petEntity, completion: { _, _ in
                            repo.find(petEntity.id, completion: { pet in
                                expect(pet?.id).toNot(beNil())
                                expect(pet?.name) == "Han"
                            })
                        })
                    }

                }

                context("and there's no result with primary key") {

                    it("it shouldn't get any pet in Realm") {
                        let repo = RealmRepository<PetEntity>(realmConfiguration: Realm.Configuration(inMemoryIdentifier: "pet-realm11"))

                        let pet = Pet(id: "3", name: "Han", age: 4)
                        let petEntity = PetEntity(entity: pet)
                        repo.insert(item: petEntity, completion: { _, _ in
                            repo.find("wrong", completion: { pet in
                                expect(pet).to(beNil())
                            })
                        })
                    }
                }
            }
        }
    }
}
