import Foundation

public protocol AccessTokenCredentials {
    
    var accessToken: AccessToken? {get set}
}

public class AccessTokenCredentialsDefaultImp: AccessTokenCredentials {
    
    private var token: AccessToken? = AccessTokenDefaultImp(token: "TOKEN72492365872", refreshToken: "", expires: Date())
    
    public var accessToken: AccessToken? {
        get {
            return token
        }
        set {
            token = newValue
        }
    }
    
    public init() {}
}
