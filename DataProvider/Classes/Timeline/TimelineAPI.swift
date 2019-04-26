import Foundation

public protocol TimelineAPIContract {
    func fetchTimelineEvents(callback: @escaping  (Response<[TimelineEventModel]>) -> ())
}

public struct TimelineAPI: TimelineAPIContract {
    
    public func fetchTimelineEvents(callback: @escaping (Response<[TimelineEventModel]>) -> ()) {
        
        let url = URL(string: "url")
        
        Network.request(url!) { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    callback(Response<[TimelineEventModel]>(data: [], result: .error(message: "Problem with data")))
                    return
                }
                
                do {
                    let events = try JSONDecoder().decode([TimelineEventModel].self, from: data)
                    callback(Response<[TimelineEventModel]>(data: events, result: .success))
                } catch {
                    callback(Response<[TimelineEventModel]>(data: [], result: .error(message: "Problem with serialization")))
                }
            case .failure(let error):
                callback(Response<[TimelineEventModel]>(data: [], result: .error(message: error.localizedDescription)))
            }
        }
        
    }
    
}

