import DataProvider

public struct Pet: Entity {
    public let id: String
    public let name: String
    public let age: Int
    
    public init(id: String, name: String, age: Int) {
        self.id = id
        self.name = name
        self.age = age
    }
}
