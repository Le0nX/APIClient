import Foundation

public protocol ResponseDecoder {
    
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
    
    func decode(from data: Data) throws -> Any
}

public class ResponseDecoderDefault: ResponseDecoder {
    
    private let decoder: JSONDecoder
    
    public init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoded = try decoder.decode(type, from: data)
        return decoded
    }
    
    public func decode(from data: Data) throws -> Any {
        return data
    }
}
