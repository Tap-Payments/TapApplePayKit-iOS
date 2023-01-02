//
//  TapNetworkManager.swift
//  TapNetworkManager/Core
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//
import Foundation

/// Network Manager class.
public class TapNetworkManager {
    
    // MARK: - Public -
    
    /// The logged in requests/responses since the init of the network manager till the moment
    public var loggedInApiCalls:[TapLogStackTraceEntryModel] = []
    
    /// Request completion closure.
    public typealias RequestCompletionClosure = (URLSessionDataTask?, Any?, Error?) -> Void
    
    /// Inner Request completion closure.
    public typealias InnerRequestCompletionClosure = (URLSessionDataTask?, Any?, Error?,TapLogStrackTraceRequstModel?) -> Void
    
    // MARK: Properties
    /// Defines if request logging enabled.
    public var isRequestLoggingEnabled = false
    
    /// Defines if you want to enable printing to the console the api calls as it go
    public var consolePrintLoggingEnabled = false
    
    /// Base URL.
    public private(set) var baseURL: URL
    
    /// Current active request operations
    public private(set) var currentRequestOperations: [TapNetworkRequestOperation] = []
    
    // MARK: Methods
    /// Creates an instance of TapNetworkManager with the base URL and session configuration.
    public required init(baseURL: URL, configuration: URLSessionConfiguration = .default) {
        
        self.baseURL = baseURL
        self.session = URLSession(configuration: configuration)
        // Clear the previous api calls, this should be empty by default but just in case :)
        loggedInApiCalls = []
    }
    
    /// Performs request operation and calls completion when request finishes.
    ///
    /// - Parameters:
    ///   - operation: Network request operation.
    ///   - completion: Completion closure that is called when request finishes.
    public func performRequest(_ operation: TapNetworkRequestOperation, completion: InnerRequestCompletionClosure?) {
        
        var request: URLRequest
        // The object that will hold the request model for logging this api call in the stacktrace
        var tapLoggingRequestModel:TapLogStrackTraceRequstModel?
        
        do {
            // Generate a http request by the provided operation
            request = try self.createURLRequest(from: operation)
            // Generate a string representations for the headers and the body
            let headersString:String    = String(data: try! JSONSerialization.data(withJSONObject: (request.allHTTPHeaderFields ?? [:]), options: .prettyPrinted), encoding: .utf8 )!
            var bodyString:String = ""
            if let body = request.httpBody {
                bodyString = String(data: try! JSONSerialization.data(withJSONObject: JSONSerialization.jsonObject(with: body, options: []), options: .prettyPrinted), encoding: .utf8 )!
            }
            
            // Create the tapLoggingRequest model with the http request
            tapLoggingRequestModel = .init(request: request, headers: headersString, body: bodyString)
            
            
            var dataTask: URLSessionDataTask?
            let dataTaskCompletion: (Data?, URLResponse?, Error?) -> Void = { [weak self] (data, response, anError) in
                
                //                guard let strongSelf = self else { return }
                if let operationIndex = self?.currentRequestOperations.firstIndex(of: operation) {
                    
                    self?.currentRequestOperations.remove(at: operationIndex)
                }
                
                // Check for errors first
                if let error = anError {
                    // Failure with api/network error
                    completion?(dataTask, nil, error, tapLoggingRequestModel)
                }else if let d = data {
                    
                    do {
                        
                        let responseObject = try TapSerializer.deserialize(d, with: operation.responseType)
                        // Success case all went good
                        completion?(dataTask, responseObject, anError, tapLoggingRequestModel)
                        
                    } catch {
                        // Failure case parsing the response into the required model
                        completion?(dataTask, nil, error, tapLoggingRequestModel)
                    }
                    
                } else {
                    // Failure case where no data passed back from the api Network or api errror
                    completion?(dataTask, nil, anError, tapLoggingRequestModel)
                }
            }
            
            if consolePrintLoggingEnabled {
                var loggString:String = "Request :\n========\n\(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")\nHeaders :\n------\n\(String(data: try! JSONSerialization.data(withJSONObject: (request.allHTTPHeaderFields ?? [:]), options: .prettyPrinted), encoding: .utf8 )!)"
                
                if let body = request.httpBody {
                    loggString = "\(loggString)\nBody :\n-----\n\(String(data: try! JSONSerialization.data(withJSONObject: JSONSerialization.jsonObject(with: body, options: []), options: .prettyPrinted), encoding: .utf8 )!)\n---------------\n"
                }else{
                    loggString = "\(loggString)\nBody :\n-----\n{\n}\n---------------\n"
                }
                print(loggString)
            }
            
            let task = self.session.dataTask(with: request, completionHandler: dataTaskCompletion)
            dataTask = task
            operation.task = task
            task.resume()
            
            self.currentRequestOperations.append(operation)
            
        } catch {
            // Failire case of general internal issue while calling the api
            completion?(nil, nil, error, tapLoggingRequestModel)
        }
    }
    
    
    /// Performs request operation and calls completion when request finishes.
    ///
    /// - Parameters:
    ///   - operation: Network request operation.
    ///   - completion: Completion closure that is called when request finishes.
    public func performRequest<T:Decodable>(_ operation: TapNetworkRequestOperation, completion: RequestCompletionClosure?,codableType:T.Type) {
        
        // The object that will hold the response model for logging this api call in the stacktrace
        var tapLoggingResponseModel:TapLogStrackTraceResponseModel?
        
        performRequest(operation) { (dataTask, data, error, requestModel) in
            let headersString   = String(data: try! JSONSerialization.data(withJSONObject: (dataTask?.response as? HTTPURLResponse)?.allHeaderFields ?? [:], options: .prettyPrinted), encoding: .utf8 )!
            let bodySting       = String(data: try! JSONSerialization.data(withJSONObject: (data ?? [:]), options: .prettyPrinted), encoding: .utf8 )!
            
            let loggString:String = "Response :\n========\n\(operation.httpMethod.rawValue) \(operation.path)\nHeaders :\n------\n\(headersString)\nBody :\n-----\n\(bodySting)\n---------------\n"
            
            if self.consolePrintLoggingEnabled {
                print(loggString)
            }
            
            if let nonNullError = error {
                // Failure case for network/api/internal
                tapLoggingResponseModel = .init(headers: headersString, error_code: "Network/Internal", error_message: nonNullError.localizedDescription, error_description: nonNullError.debugDescription, body: bodySting)
                
                completion?(dataTask, nil, nonNullError)
            }else if let jsonObject = data {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
                    let decodedResponse = try JSONDecoder().decode(codableType, from: jsonData)
                    // Success case
                    tapLoggingResponseModel = .init(headers: headersString, error_code: nil, error_message: nil, error_description: nil, body: bodySting)
                    DispatchQueue.main.async {
                        completion?(dataTask, decodedResponse, error)
                    }
                } catch {
                    // Failure case serialization
                    tapLoggingResponseModel = .init(headers: headersString, error_code: "Serialization", error_message: error.localizedDescription, error_description: error.debugDescription, body: bodySting)
                    
                    DispatchQueue.main.async {
                        completion?(dataTask, jsonObject, error)
                    }
                }
            }else {
                // Failure case Network or API
                tapLoggingResponseModel = .init(headers: headersString, error_code: "API", error_message: "No data to parse", error_description: nil, body: bodySting)
                
                DispatchQueue.main.async {
                    completion?(nil, nil, error)
                }
            }
            self.loggedInApiCalls.append(.init(request: requestModel, response: tapLoggingResponseModel))
        }
    }
    
    
    /// Cancels network request operation.
    ///
    /// - Parameter operation: Operation to cancel.
    public func cancelRequest(_ operation: TapNetworkRequestOperation) {
        
        operation.task?.cancel()
    }
    
    /// Cancels all request operations.
    public func cancelAllOperations() {
        
        self.currentRequestOperations.forEach { self.cancelRequest($0) }
    }
    
    // MARK: - Private -
    private struct Constants {
        
        fileprivate static let contentTypeHeaderName        = "Content-Type"
        fileprivate static let jsonContentTypeHeaderValue   = "application/json"
        fileprivate static let plistContentTypeHeaderValue  = "application/x-plist"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    private var session: URLSession
    
    // MARK: Methods
    private func createURLRequest(from operation: TapNetworkRequestOperation) throws -> URLRequest {
        
        let url = try self.prepareFullRequestURL(for: operation)
        let configuration = self.session.configuration
        var request = URLRequest(url: url, cachePolicy: configuration.requestCachePolicy, timeoutInterval: configuration.timeoutIntervalForRequest)
        
        request.httpMethod = operation.httpMethod.rawValue
        
        for (headerField, headerValue) in operation.additionalHeaders {
            
            if request.value(forHTTPHeaderField: headerField) == nil {
                
                request.addValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        if let bodyModel = operation.bodyModel {
            
            guard bodyModel.serializationType != .url else {
                
                throw TapNetworkError.serializationError(.wrongData)
            }
            
            request.httpBody = try TapSerializer.serialize(bodyModel.body, with: bodyModel.serializationType) as? Data
            
            if request.value(forHTTPHeaderField: Constants.contentTypeHeaderName) == nil {
                
                let value = self.requestContentTypeHeaderValue(for: bodyModel.serializationType)
                request.setValue(value, forHTTPHeaderField: Constants.contentTypeHeaderName)
            }
        }
        
        return request
    }
    
    private func prepareFullRequestURL(for operation: TapNetworkRequestOperation) throws -> URL {
        
        var relativePath: String
        
        if let urlModel = operation.urlModel {
            
            guard let serializedQuery = try TapSerializer.serialize(urlModel, with: .url) as? String else {
                
                throw TapNetworkError.serializationError(.wrongData)
            }
            
            relativePath = operation.path + serializedQuery
            
        } else {
            
            relativePath = operation.path
        }
        
        guard let resultingURL = URL(string: relativePath, relativeTo: self.baseURL)?.absoluteURL else {
            
            throw TapNetworkError.wrongURL(self.baseURL.absoluteString + relativePath)
        }
        
        return resultingURL
    }
    
    private func requestContentTypeHeaderValue(for dataType: TapSerializationType) -> String {
        
        switch dataType {
        
        case .json:
            
            return Constants.jsonContentTypeHeaderValue
            
        case .propertyList:
            
            return Constants.plistContentTypeHeaderValue
            
        default: return ""
        }
    }
    
    
}


extension Error {
    
    var debugDescription:String {
        return (self as NSError).debugDescription
    }
}
