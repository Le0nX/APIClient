public enum AuthorizationHeader: Equatable {
    case none
    case bearer
    case auth
    case basic
    
    public var value: String {
        switch self {
        case .bearer:
            return "Bearer "
        case .auth:
            return ""
        case .basic:
            return "Basic "
        default:
            return ""
        }
    }
    
}
