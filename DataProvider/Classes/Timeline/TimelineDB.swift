import RealmSwift

public protocol TimelineDBContract {
    func getEvents(for id: Int) -> [TimelineEventEntity]
}

final class TimelineDB: TimelineDBContract {
    
    func getEvents(for id: Int) -> [TimelineEventEntity] {
        let timelineRepo = RealmRepository<TimelineEventEntity>()
        return timelineRepo.all().map { TimelineEventEntity(event: $0) }
    }
    
}
