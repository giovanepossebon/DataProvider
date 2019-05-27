public protocol TimelineProviderProtocol: class {
    func getTimeline(completion: @escaping ([TimelineEventModel]?, CustomError?) -> ())
}

public final class TimelineProvider: TimelineProviderProtocol {
    
    private let id: Int
    private let api: TimelineAPIContract
    private let db: TimelineDBContract
    
    public convenience init(id: Int) {
        self.init(id: id, api: TimelineAPI(), db: TimelineDB())
    }
    
    public init(id: Int, api: TimelineAPIContract, db: TimelineDBContract) {
        self.id = id
        self.api = api
        self.db = db
    }
    
    public func getTimeline(completion: @escaping ([TimelineEventModel]?, CustomError?) -> ()) {
        let db = TimelineDB()
        let events = db.getEvents(for: self.id)
        let eventsModel = events.map { TimelineEventModel(id: $0.id, relatedEventId: 0, title: $0.title) }
        
        completion(eventsModel , nil)
    }
    
}

