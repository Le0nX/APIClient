public enum AuthorizationHeader: Equatable {
    case none
    case bearer
    case auth
    case basic
    case custom(String)
    
    public var value: String {
        switch self {
        case .bearer:
            return "Bearer "
        case .auth:
            return ""
        case .basic:
            return "Basic "
        case .custom(let value):
            return "\(value) "
        default:
            return ""
        }
    }
    
}
