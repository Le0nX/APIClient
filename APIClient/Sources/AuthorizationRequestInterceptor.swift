import Alamofire

public class AuthorizationRequestInterceptor: RequestInterceptor {
    
    private var accessTokenCredentials: AccessTokenCredentials!
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [RetryResult] = []
    private var token: AccessToken!
    
    public init(accessTokenCredentials: AccessTokenCredentials) {
        self.accessTokenCredentials = accessTokenCredentials
        self.token = accessTokenCredentials.accessToken
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AFResult<URLRequest>) -> Void) {
        var urlRequest = urlRequest
        if let headerValue = urlRequest.value(forHTTPHeaderField: "Authorization"),
            headerValue.contains("{token}") {
            urlRequest.setValue(
                headerValue.replacingOccurrences(of: "{token}", with: token.token),
                forHTTPHeaderField: "Authorization")
        }
        
        completion(AFResult.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }

}
