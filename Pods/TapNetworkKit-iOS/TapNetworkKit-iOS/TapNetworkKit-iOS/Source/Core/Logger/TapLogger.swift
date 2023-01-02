//
//  TapLogger.swift
//  TapNetworkKit-iOS
//
//  Created by Kareem Ahmed on 8/12/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

/// TapLogger
@objc public class TapLogger: NSObject {
    static private let logApiUrl = "https://demo6774314.mockable.io/log"
    @objc public class func log(event: String, value: [String: Any]) {
        let manager = TapNetworkManager(baseURL: URL(string: logApiUrl)!)
        manager.isRequestLoggingEnabled = true
        let body = TapBodyModel(body: value)
        let requestOperation = TapNetworkRequestOperation(path: "", method: .POST, headers: nil, urlModel: .none, bodyModel: body, responseType: .json)
        
        manager.performRequest(requestOperation, completion: { (session, result, error,_) in
            print("result is: \(String(describing: result))")
            print("error: \(String(describing: error))")
        })
    }
    
    @objc public class func log(with urlRequest: URLRequest, bodyParmeters: [String: Any]?) {
        if urlRequest.url?.absoluteString == logApiUrl {
            return
        }
        let parameters = ["event": "API Request",
                          "url": urlRequest.url?.absoluteString ?? "",
                          "headers": urlRequest.allHTTPHeaderFields ?? [],
                          "body": bodyParmeters ?? ["":""]] as [String: Any]
        sendLogRequest(parameters)
    }
    
    
    @objc public class func log(urlRequest: URLRequest?, apiResponse: Any) {
        if urlRequest?.url?.absoluteString == logApiUrl {
            return
        }
        let parameters = ["logs": ["event": "API Response",
                                   "response": apiResponse]] as [String: Any]
        sendLogRequest(parameters)
    }
    
    @objc public class func log(urlRequest: URLRequest?, error: Error?) {
        if urlRequest?.url?.absoluteString == logApiUrl {
            return
        }
        let parameters = ["event": "API Response Error",
                          "error": error?.localizedDescription ?? "unknown error"] as [String: Any]
        sendLogRequest(parameters)
    }
    
    fileprivate static func sendLogRequest(_ parameters: [String : Any]) {
        let manager = TapNetworkManager(baseURL: URL(string: logApiUrl)!)
        manager.isRequestLoggingEnabled = true
        let body = TapBodyModel(body: parameters)
        let requestOperation = TapNetworkRequestOperation(path: "", method: .POST, headers: nil, urlModel: .none, bodyModel: body, responseType: .json)
        
        manager.performRequest(requestOperation, completion: { (session, result, error,_) in
            print("result is: \(String(describing: result))")
            print("error: \(String(describing: error))")
        })
    }
}
