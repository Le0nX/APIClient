//
//  ViewController.swift
//  IOS Example
//
//  Created by Alexandr Klavsut on 19/08/2019.
//  Copyright © 2019 Alexandr Klavsut. All rights reserved.
//

import UIKit

import APIClient
import Alamofire

class ViewController: UIViewController {
    
    let client: APIClient = {
        let s = AccessTokenCredentialsDefaultImp()

        let interceptor = AuthorizationRequestInterceptorDefault(accessTokenCredentials: AccessTokenCredentialsDefaultImp())

        let responseDecoder = ResponseDecoderDefault(decoder: JSONDecoder())
        let responseValidator = ResponseValidatorDefault()

        let session = Session(configuration: .default,
                              delegate: SessionDelegate(),
                              rootQueue: .global(),
                              startRequestsImmediately: true,
                              requestQueue: nil, serializationQueue: nil, interceptor: interceptor, serverTrustManager: nil, redirectHandler: nil, cachedResponseHandler: nil, eventMonitors: [NetworkLoggerMonitor()])

        let client = APIClient(baseURL: URL(string: "http://127.0.0.1:5000")!, session: session, responseDecoder: responseDecoder, responseValidator: responseValidator)

        return client
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = UserServiceImpl(apiClient: client)
        
        service.fetchDataNoHeader { result in
            print(result)
        }
    }


}

