public enum APIError: Error {
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case decodingFailure
    
    var errorDescription: String {
        switch self {
        case .authenticationError: return "You need to be authenticate first."
        case .badRequest: return "Bad request"
        case .outdated: return "The url you requested is outdated."
        case .failed: return "Network request failed."
        case .noData: return "Response returned with no data"
        case .decodingFailure: return "We could not decode the response."
        }
    }
}
