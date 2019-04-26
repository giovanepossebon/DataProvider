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
        api.fetchTimelineEvents { response in
            
        switch response.result {
            case .success:
                completion(response.data, nil)
            case .error(message: let error):
                completion(nil, CustomError(description: error))
            }
        }
    }
 
}

