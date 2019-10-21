import Alamofire

public typealias APIResult<T, Type: Decodable> = (Result<T, APIError<Type>>) -> Void

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
    
    public func request<T: Decodable, D: Decodable>(
        path: String,
        queryParameters: [String: Any],
        jsonParameters: [String: Any],
        headerParameters: [String: String],
        method: HTTPMethod,
        authorizationHeader: AuthorizationHeader,
        isRequestValidatable: Bool,
        completion: @escaping APIResult<T, D>) {
        
        let request = RequestBuilder(
            header: authorizationHeader,
            baseURL: baseURL,
            queryParameters: queryParameters,
            jsonParameters: jsonParameters,
            headerParameters: headerParameters,
            method: method,
            path: path)

        session.request(request)
            .response { dataResponse in
                guard dataResponse.error == nil, let response = dataResponse.response else {
                    completion(.failure(.failed))
                    return
                }
                
                if isRequestValidatable {
                    let value: T = true as! T
                    completion(.success(value))
                    return
                }
                
                guard let data = dataResponse.data else {
                    completion(.failure(.noData))
                    return
                }
                
                if let error = self.responseValidator.validate(
                    D.self,
                    request: dataResponse.request,
                    response: response,
                    data: dataResponse.data
                ) {
                    completion(.failure(error))
                    return
                }
                
                guard let decoded = try? self.responseDecoder.decode(T.self, from: data) else {
                    completion(.failure(.decodingFailure))
                    return
                }
                completion(.success(decoded))
            }
    }  
    
}
