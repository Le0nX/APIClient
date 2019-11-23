import Alamofire

public class NetworkLoggerMonitor: EventMonitor {
    
    fileprivate let isVerbose = true
    fileprivate let loggerId = "NetworkLoggerMonitor_Logger"
    fileprivate let dateFormatString = "dd/MM/yyyy HH:mm:ss"
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let separator = ", "
    fileprivate let terminator = "\n"
    fileprivate let cURLTerminator = "\\\n"
    fileprivate let output: (_ separator: String, _ terminator: String, _ items: Any...) -> Void = reversedPrint
    fileprivate let requestDataFormatter: ((Data) -> (String))? = nil
    fileprivate let responseDataFormatter: ((Data) -> (Data))? = nil
    
    public init() {}
    
    public func request(_ request: Alamofire.Request, didCreateURLRequest urlRequest: URLRequest) {
        outputItems(logNetworkRequest(request.request))
    }
    
    public func request(_ request: Alamofire.DataRequest, didParseResponse response: Alamofire.DataResponse<Data, Error>) {
        outputItems(logNetworkResponse(response.response, data: response.data, request: request))
    }
    
    fileprivate func outputItems(_ items: [String]) {
        if isVerbose {
            items.forEach { output(separator, terminator, $0) }
        } else {
            output(separator, terminator, items)
        }
    }
    
    var date: String {
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: Date())
    }
    
    func format(_ loggerId: String, date: String, identifier: String, message: String) -> String {
        return "\(loggerId): [\(date)] \(identifier): \(message)"
    }
    
    func logNetworkRequest(_ request: URLRequest?) -> [String] {
        
        var output = [String]()
        
        output += [format(loggerId, date: date, identifier: "Request", message: request?.description ?? "(invalid request)")]
        
        if let headers = request?.allHTTPHeaderFields {
            output += [format(loggerId, date: date, identifier: "Request Headers", message: headers.description)]
        }
        
        if let bodyStream = request?.httpBodyStream {
            output += [format(loggerId, date: date, identifier: "Request Body Stream", message: bodyStream.description)]
        }
        
        if let httpMethod = request?.httpMethod {
            output += [format(loggerId, date: date, identifier: "HTTP Request Method", message: httpMethod)]
        }
        
        if let body = request?.httpBody, let stringOutput = requestDataFormatter?(body) ?? String(data: body, encoding: .utf8) {
            output += [format(loggerId, date: date, identifier: "Request Body", message: stringOutput)]
        }
        
        return output
    }
    
    func logNetworkResponse(_ response: HTTPURLResponse?, data: Data?, request: DataRequest) -> [String] {
        guard let response = response else {
            return [format(loggerId, date: date, identifier: "Response", message: "Received empty network response for \(request.description).")]
        }
        
        var output = [String]()
        
        output += [format(loggerId, date: date, identifier: "Response", message: response.description)]
        
        if let data = data, let stringData = String(data: responseDataFormatter?(data) ?? data, encoding: String.Encoding.utf8) {
            output += [stringData]
        }
        
        return output
    }
    
    static func reversedPrint(_ separator: String, terminator: String, items: Any...) {
        for item in items {
            print(item, separator: separator, terminator: terminator)
        }
    }
}
