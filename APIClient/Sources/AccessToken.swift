import Foundation

public protocol AccessToken {
    var token: String {get}
    var refreshToken: String {get}
    var expires: Date {get}
    
    func isNearToExpire() -> Bool
}

public struct AccessTokenDefaultImp: AccessToken, Codable, Equatable {
    
    public let token: String
    public let refreshToken: String
    public let expires: Date
    
    public init(token: String, refreshToken: String, expires: Date) {
        self.token = token
        self.refreshToken = refreshToken
        self.expires = expires
    }
    
    public func isNearToExpire() -> Bool {
        return expires.timeIntervalSinceNow < 60
    }
   
    public var data: [String: Any] {
        return ["token": token, "refreshToken": refreshToken, "expires": Double(expires.timeIntervalSince1970)]
    }
    
    
}
