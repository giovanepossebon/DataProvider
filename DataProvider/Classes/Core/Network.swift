import Foundation
import Alamofire

class Network {
    
    class func request(_ url: URL, method: HTTPMethod = .get, parameters: [String: Any]? = nil, log: Bool = true, encoding: ParameterEncoding = JSONEncoding.default, completion: @escaping (DataResponse<Any>) -> Void) {
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: defaultHeaders()).responseJSON(completionHandler: { response in
            
            if log {
                logAlamofireRequest(response: response)
            }
            
            completion(response)
        })
    }
    
    private class func defaultHeaders() -> [String: String] {
        
        let headers: [String: String] = [
            "Content-Type":"application/json",
            "Authorization": ""
        ]
        
        return headers
    }
    
    private class func logAlamofireRequest(response: DataResponse<Any>) {
        
        guard let request = response.request else { return }
        guard let url = request.url else { return }
        guard let httpMethod = request.httpMethod else { return }
        
        print("->REQUEST(\(httpMethod))\n\(url)\n")
        
        if let requestHeaders = request.allHTTPHeaderFields {
            print("->HEADERS\n\(requestHeaders)\n")
        }
        
        if let httpBody = request.httpBody {
            do {
                let jsonBody = try JSONSerialization.jsonObject(with: httpBody)
                print("->BODY\n\(jsonBody)\n")
            } catch {
                
            }
        }
        
        var statusCode = 0
        if let response = response.response {
            statusCode = response.statusCode
        }
        
        let statusCodeString = (statusCode != 0) ? "(\(statusCode))" : ""
        print("->RESPONSE" + statusCodeString + "\n\(response.description)")
    }
}

public struct Response<T> {
    public var data: T?
    public let result: Result
    
    public init(data: T?, result: Result) {
        self.data = data
        self.result = result
    }
}

public enum Result {
    case success
    case error(message: String)
}