import Foundation

public protocol TimelineAPIContract {
    func fetchTimelineEvents(completion: ([TimelineEventModel], Error?) -> ())
}

public struct TimelineAPI: TimelineAPIContract {
    
    public func fetchTimelineEvents(completion: ([TimelineEventModel], Error?) -> ()) {
        return completion([TimelineEventModel(id: 0, relatedEventId: 0, title: "Teste1"),
                           TimelineEventModel(id: 1, relatedEventId: 0, title: "Teste2")], nil)
    }
    
}

