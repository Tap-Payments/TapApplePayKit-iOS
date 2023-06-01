//
//  TapLoggingType.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 18/02/2023.
//

import Foundation
/// Defines the logging different types provided by TAP
/// - tag: TapLoggingType
@objc public enum TapLoggingType: Int {
    
    /// Log ui events
    @objc(TapLoggingUI) case UI
    
    /// Log api requests/responses
    @objc(TapLoggingApis) case API
    
    /// Log user's events
    @objc(TapLoggingEvents) case EVENTS
    
    /// Log api requests to the xcode console for development purposes
    @objc(TapLoggingConsole) case CONSOLE
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let UIKey        = "UI"
        fileprivate static let APIKey       = "API"
        fileprivate static let EventsKey    = "EVENTS"
        fileprivate static let ConsoleKey   = "CONSOLE"
        
        //@available(*, unavailable) private init() { fatalError("This struct cannot be instantiated.") }
    }
    
    // MARK: Properties
    
    public var stringValue: String {
        
        switch self {
            
        case .UI:        return Constants.UIKey
        case .API:       return Constants.APIKey
        case .EVENTS:    return Constants.EventsKey
        case .CONSOLE:   return Constants.ConsoleKey
            
        }
    }
    
    // MARK: Methods
    
    private init(string: String) throws {
        
        switch string.uppercased() {
            
        case Constants.UIKey:       self = .UI
        case Constants.APIKey:      self = .API
        case Constants.EventsKey:   self = .EVENTS
        case Constants.ConsoleKey:  self = .CONSOLE
            
        default:
            
            let userInfo = [ErrorConstants.UserInfoKeys.tokenType: string]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidTokenType.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
        }
    }
}

// MARK: - Decodable
extension TapLoggingType: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        let string = try container.decode(String.self)
        try self.init(string: string)
    }
}
