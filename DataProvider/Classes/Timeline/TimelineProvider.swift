public protocol TimelineProviderProtocol: class {
    func getTimeline(completion: ([TimelineEventModel]?, CustomError?) -> ())
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
    
    public func getTimeline(completion: ([TimelineEventModel]?, CustomError?) -> ()) {
        let storedEvents = db.getEvents(for: 0)
        
        api.fetchTimelineEvents { events, error in
            guard error == nil else {
                completion(storedEvents.compactMap { TimelineEventModel(id: $0.id, relatedEventId: 0, title: $0.title) }, error as? CustomError)
                return
            }
            
            TimelineEventEntity.save(events: events)
            completion(events, nil)
        }
    }
 
}

