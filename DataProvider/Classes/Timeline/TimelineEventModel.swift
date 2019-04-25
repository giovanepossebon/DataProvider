public struct TimelineEventModel {
    public let id: Int
    public let relatedEventId: Int
    public let title: String
    
    public init(id: Int, relatedEventId: Int, title: String) {
        self.id = id
        self.relatedEventId = relatedEventId
        self.title = title
    }
}
