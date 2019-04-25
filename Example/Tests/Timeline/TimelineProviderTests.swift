import Quick
import Nimble
import DataProvider

@testable import DataProvider

final class TimelineProviderTests: QuickSpec {

    override func spec() {

        var sut_provider: TimelineProvider!
        var api: TimelineAPISpy!
        var db: TimelineDBSpy!

        func setup(success: Bool = true, hasOfflineData: Bool = true) {
            api = TimelineAPISpy(success: success)
            db = TimelineDBSpy(hasOfflineData: hasOfflineData)
            sut_provider = TimelineProvider(id: 0, api: api, db: db)
        }

        describe("TimelineInteractor") {

            describe("when provider calls for timeline events") {

                context("and it returns success") {

                    beforeEach {
                        setup(success: true)
                    }

                    it("it should return timeline events") {
                        sut_provider.getTimeline(completion: { events, error in
                            expect(events?.isEmpty).toEventually(beFalse())
                            expect(events?[0].title) == "title value"
                            expect(error).toEventually(beNil())
                        })
                    }

                }

                context("and it returns fail") {

                    context("and has information at database") {
                        
                        beforeEach {
                            setup(success: false, hasOfflineData: true)
                        }
                        
                        it("it should return offline data and internet missing error") {
                            sut_provider.getTimeline { events, error in
                                expect(events?.isEmpty).toEventually(beFalse())
                                expect(error?.description) == "error value"
                            }
                        }
                        
                    }
                    
                    context("and doesn't have information at database") {
                        
                        beforeEach {
                            setup(success: false, hasOfflineData: false)
                        }
                        
                        it("it should return empty and error") {
                            sut_provider.getTimeline { events, error in
                                expect(events?.isEmpty).toEventually(beTrue())
                                expect(error?.description) == "error value"
                            }
                        }
                        
                    }
                }
            }
        }
    }
}

private class TimelineDBSpy: TimelineDBContract {
    let hasOfflineData: Bool
    
    init(hasOfflineData: Bool) {
        self.hasOfflineData = hasOfflineData
    }
    
    func getEvents(for id: Int) -> [TimelineEventEntity] {
        return hasOfflineData ? [TimelineEventEntity(id: 0, title: "title value")] : []
    }
    
}

private class TimelineAPISpy: TimelineAPIContract {
    let success: Bool

    init(success: Bool) {
        self.success = success
    }

    func fetchTimelineEvents(completion: ([TimelineEvent], Error?) -> ()) {
        if success {
            completion([TimelineEvent(id: 0, relatedEventId: 0, title: "title value")], nil)
        } else {
            completion([], CustomError(description: "error value"))
        }
    }
}
