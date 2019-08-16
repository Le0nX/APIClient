import Alamofire

public typealias APIResult<T> = (Result<T, APIError>) -> Void

open class APIClient {
    
    private let baseURL: URL!
    private let session: Session!
    private let responseDecoder: ResponseDecoder!
    private let responseValidator: ResponseValidator!
    
    public init(baseURL: URL, session: Session, responseDecoder: ResponseDecoder, responseValidator: ResponseValidator) {
        self.baseURL = baseURL
        self.session = session
        self.responseDecoder = responseDecoder
        self.responseValidator = responseValidator
    }
    
    public func request<T: Decodable>(
        path: String,
        queryParameters: [String: Any],
        jsonParameters: [String: Any],
        headerParameters: [String: String],
        authorizationHeader: AuthorizationHeader,
        method: HTTPMethod,
        completion: @escaping APIResult<T>) {
        
        let request = RequestBuilder(
            header: authorizationHeader,
            baseURL: baseURL,
            queryParameters: queryParameters,
            jsonParameters: jsonParameters,
            headerParameters: headerParameters,
            method: method,
            path: path)

        session.request(request)
            .response { response in
                guard response.error == nil, let r = response.response, let data = response.data else {
                    completion(.failure(.failed))
                    return
                }
                
                if let error = self.responseValidator.validate(request: response.request, response: r, data: response.data) {
                    completion(.failure(error))
                    return
                }
                
                if let decoded = try? self.responseDecoder.decode(T.self, from: data) {
                    completion(.success(decoded))
                } else {
                    completion(.failure(.decodingFailure))
                }
            }
    }
    
    public func request_no_reply(
        path: String,
        queryParameters: [String: Any],
        jsonParameters: [String: Any],
        headerParameters: [String: String],
        authorizationHeader: AuthorizationHeader,
        method: HTTPMethod,
        completion: @escaping APIResult<Bool>) {
        
        let request = RequestBuilder(
            header: authorizationHeader,
            baseURL: baseURL,
            queryParameters: queryParameters,
            jsonParameters: jsonParameters,
            headerParameters: headerParameters,
            method: method,
            path: path)
        
        session.request(request)
            .response { response in
                guard response.error == nil, let r = response.response else {
                    completion(.failure(.failed))
                    return
                }
                
                if let error = self.responseValidator.validate(request: response.request, response: r, data: response.data) {
                    completion(.failure(error))
                    return
                }
                completion(.success(true))
            }
    }
    
    
}
