import RealmSwift

public protocol TimelineDBContract {
    func getEvents(for id: Int) -> [TimelineEventEntity]
}

final class TimelineDB: TimelineDBContract {
    
    func getEvents(for id: Int) -> [TimelineEventEntity] {
        return Array(TimelineEventEntity.events())
    }
    
}
