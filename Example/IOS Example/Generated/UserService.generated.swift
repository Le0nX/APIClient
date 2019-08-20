// Generated using Sourcery 0.16.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Alamofire
import APIClient

class UserServiceImpl: UserService {

    private let apiClient: APIClient


    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }    

    func fetchData(                                           completion: @escaping APIResult<Bool>) {

        let queryParameters: [String: Any] = [
        :
        ]

        let pathParameters: [String: Any] = [
        :
        ]

        let jsonParameters: [String: Any] = [
        :
        ]

        let headerParameters: [String: String] = [
        :
        ]

        let method: HTTPMethod = .get
        var path = "/data"
        pathParameters.forEach { key, value in
            path = path.replacingOccurrences(
                    of: "{\(key)}",
                    with: "\(value)")
        }

        let authorizationHeader: AuthorizationHeader = .auth

        let isRequestValidatable = true

         apiClient.request(path: path, queryParameters: queryParameters, jsonParameters: jsonParameters,headerParameters: headerParameters, method: method, authorizationHeader: authorizationHeader, isRequestValidatable: isRequestValidatable, completion: completion)


    }

    func fetchDataNoHeader(                                           completion: @escaping APIResult<Bool>) {

        let queryParameters: [String: Any] = [
        :
        ]

        let pathParameters: [String: Any] = [
        :
        ]

        let jsonParameters: [String: Any] = [
        :
        ]

        let headerParameters: [String: String] = [
        :
        ]

        let method: HTTPMethod = .get
        var path = "/data"
        pathParameters.forEach { key, value in
            path = path.replacingOccurrences(
                    of: "{\(key)}",
                    with: "\(value)")
        }

        let authorizationHeader: AuthorizationHeader = .none

        let isRequestValidatable = true

         apiClient.request(path: path, queryParameters: queryParameters, jsonParameters: jsonParameters,headerParameters: headerParameters, method: method, authorizationHeader: authorizationHeader, isRequestValidatable: isRequestValidatable, completion: completion)


    }

    func fetchUsers(                 requestId: Int,                    dataId: String,                   rootId: String,               he1: String,                                           completion: @escaping APIResult<Bool>) {

        let queryParameters: [String: Any] = [
            "root_id": rootId
        ]

        let pathParameters: [String: Any] = [
            "request_id": requestId
        ]

        let jsonParameters: [String: Any] = [
            "data_id": dataId
        ]

        let headerParameters: [String: String] = [
            "he1_header": he1
        ]

        let method: HTTPMethod = .post
        var path = "/users"
        pathParameters.forEach { key, value in
            path = path.replacingOccurrences(
                    of: "{\(key)}",
                    with: "\(value)")
        }

        let authorizationHeader: AuthorizationHeader = .custom("Rule")

        let isRequestValidatable = true

         apiClient.request(path: path, queryParameters: queryParameters, jsonParameters: jsonParameters,headerParameters: headerParameters, method: method, authorizationHeader: authorizationHeader, isRequestValidatable: isRequestValidatable, completion: completion)


    }
}
