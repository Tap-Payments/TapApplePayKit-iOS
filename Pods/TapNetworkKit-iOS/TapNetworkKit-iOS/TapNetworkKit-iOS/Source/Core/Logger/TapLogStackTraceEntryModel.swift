//  Created by Osama Rabie on 7/30/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation


/// Represents a full entry in the stack trace of HTTP request and response
public struct TapLogStackTraceEntryModel: Codable {
    
    /// Represents the request part
    public var request:TapLogStrackTraceRequstModel?
    /// Represents the response part
    public var response:TapLogStrackTraceResponseModel?
    /// Unique id to match this request when needed
    public var id:String
    
    /// Represents a full entry in the stack trace of HTTP request and response
    ///
    /// - Parameters:
    ///   - request: Represents the request part
    ///   - response: Represents the response part
    init(request: TapLogStrackTraceRequstModel?, response: TapLogStrackTraceResponseModel?) {
        self.request = request
        self.response = response
        self.id = "\(NSTimeIntervalSince1970)"
    }
}

/// Represents the request model part of a HTTP call stacktrace
public struct TapLogStrackTraceRequstModel: Codable {
    /// The type of the method
    let method:String?
    /// The headers in the request
    let headers:String?
    /// The base url of the request
    let base_url:String?
    /// The end point called in the request
    let end_point:String?
    /// The body of the request
    let body:String?
    
    /// Represents the request model part of a HTTP call stacktrace
    ///
    /// - Parameters:
    ///   - method: The type of the method
    ///   - headers: The headers in the request
    ///   - base_url: The base url of the request
    ///   - end_point: The end point called in the request
    ///   - body:The body of the request
    init(method: String?, headers: String?, base_url: String?, end_point: String?, body: String?) {
        self.method     = method
        self.headers    = headers
        self.base_url   = base_url
        self.end_point  = end_point
        self.body       = body
    }
    
    /// Represents the request model part of a HTTP call stacktrace
    ///
    /// - Parameters:
    ///   - request: The url request we want to lof
    ///   - headers: The headers in the request in a string format
    ///   - body:    The body of the request in a string format
    init(request:URLRequest,headers:String,body:String) {
        self.method     = request.httpMethod
        self.base_url   = request.url?.host
        self.end_point  = request.url?.path
        self.headers    = headers
        self.body   = body
    }
    
}


/// Represents the response model part of a HTTP call stacktrace
public struct TapLogStrackTraceResponseModel: Codable {
    
    /// The headers in the response
    let headers:String?
    /// The error code coming in the response
    let error_code:String?
    /// The error message coming in the response
    let error_message:String?
    /// The error description coming in the response
    let error_description:String?
    /// The body of the response
    let body:String?
    
    /// Represents the response model part of a HTTP call stacktrace
    ///
    /// - Parameters:
    ///   - headers: The headers in the request
    ///   - error_code: The error code coming in the response
    ///   - error_message: The error message coming in the response
    ///   - error_description:The error description coming in the response
    ///   - body: The body of the response
    init(headers: String?, error_code: String?, error_message: String?, error_description: String?, body: String?) {
        self.headers            = headers
        self.error_code         = error_code
        self.error_message      = error_message
        self.error_description  = error_description
        self.body               = body
    }
    
}
