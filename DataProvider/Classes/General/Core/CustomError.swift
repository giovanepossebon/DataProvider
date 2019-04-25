import Foundation

public struct CustomError: Error {
    public let description: String
    
    public init(description: String) {
        self.description = description
    }
    
    public var localizedDescription: String {
        return NSLocalizedString(description, comment: "")
    }
}
