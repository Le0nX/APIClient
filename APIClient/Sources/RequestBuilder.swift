import Alamofire

public struct RequestBuilder: URLRequestConvertible {
    private(set) var header: AuthorizationHeader
    private(set) var baseURL: URL
    private(set) var queryParameters: [String: Any]
    private(set) var jsonParameters: [String: Any]
    private(set) var headerParameters: [String: String]
    private(set) var method: HTTPMethod
    private(set) var path: String
    
    public func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if header != .none {
            urlRequest.setValue(header.value + "{token}", forHTTPHeaderField: "Authorization")
        }
        
        headerParameters.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if method == .get, !queryParameters.isEmpty {
            urlRequest = try URLEncoding.default.encode(
                urlRequest,
                with: queryParameters)
        } else if method == .post, !jsonParameters.isEmpty {
            urlRequest = try JSONEncoding.default.encode(
                urlRequest,
                with: jsonParameters)
        }
        
        return urlRequest
    }
}
