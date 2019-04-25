import RealmSwift

class TimelineEventEntity: Object {
     @objc dynamic var id = 0
     @objc dynamic var title = ""
    
    convenience init(id: Int, title: String) {
        self.init()
        self.id = id
        self.title = title
    }
    
    class func save(events: [TimelineEventModel]) {
        let realm = try! Realm()
        
        var eventsToSave: [TimelineEventEntity] = []
        events.forEach { event in
            let event = TimelineEventEntity(id: event.id, title: event.title)
            eventsToSave.append(event)
        }
        
        try! realm.write {
            realm.add(eventsToSave)
        }
    }
    
    class func events() -> Results<TimelineEventEntity> {
        let realm = try! Realm()
        return realm.objects(TimelineEventEntity.self)
    }
}
