import RealmSwift
import Realm

public final class TimelineEventEntity: Object, RealmEntity {
    public typealias EntityType = TimelineEventModel
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    
    public convenience init(event: EntityType) {
        self.init()
        self.id = event.id
        self.title = event.title
    }

    public var entity: EntityType {
        return EntityType(id: self.id,
                          relatedEventId: 0,
                          title: self.title)
    }
    
}
