import Alamofire

public class AuthorizationRequestInterceptorDefault: RequestInterceptor {
    
    private var accessTokenCredentials: AccessTokenCredentials!
    private let lock = NSLock()
    private var token: AccessToken? {
        return accessTokenCredentials.accessToken
    }
    
    public init(accessTokenCredentials: AccessTokenCredentials) {
        self.accessTokenCredentials = accessTokenCredentials
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AFResult<URLRequest>) -> Void) {
        guard let token = token else {
            completion(AFResult.success(urlRequest))
            return
        }
        
        if token.isNearToExpire() {
            // Refresh token
            lock.lock()
            self.refreshToken(on: session) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let token):
                    self.accessTokenCredentials.accessToken = token
                }
                self.lock.unlock()
            }
        }
        
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
    
    private func refreshToken(on session: Session, completion: @escaping (AFResult<AccessToken>) -> Void) {
        let newToken = AccessTokenDefaultImp(token: "", refreshToken: "", expires: Date())
        completion(.success(newToken))
    }

}
