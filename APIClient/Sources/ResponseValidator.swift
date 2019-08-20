import Foundation

public protocol ResponseValidator {
    
    func validate(request: URLRequest?, response: HTTPURLResponse, data: Data?) -> APIError?
}

public class ResponseValidatorDefault: ResponseValidator {
    
    public init() {}
    
    public func validate(request: URLRequest?, response: HTTPURLResponse, data: Data?) -> APIError? {
        switch response.statusCode {
        case 200...299: return nil
        case 401...500: return APIError.authenticationError
        case 501...599: return APIError.badRequest
        case 600: return APIError.outdated
        default: return APIError.failed
        }
    }
}
