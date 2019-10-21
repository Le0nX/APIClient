import Foundation

public protocol ResponseValidator {
    
    func validate<T: Decodable>(_ type: T.Type, request: URLRequest?, response: HTTPURLResponse, data: Data?) -> APIError<T>?
}

public class ResponseValidatorDefault: ResponseValidator {
    
    public init() {}
    
    public func validate<T: Decodable>(_ type: T.Type, request: URLRequest?, response: HTTPURLResponse, data: Data?) -> APIError<T>? {
        
        if let data = data, let error = try? JSONDecoder().decode(T.self, from: data) {
            return .custom(error)
        }
        
        switch response.statusCode {
        case 200...299: return nil
        case 401...500: return APIError.authenticationError
        case 501...599: return APIError.badRequest
        case 600: return APIError.outdated
        default: return APIError.failed
        }
    }
}
