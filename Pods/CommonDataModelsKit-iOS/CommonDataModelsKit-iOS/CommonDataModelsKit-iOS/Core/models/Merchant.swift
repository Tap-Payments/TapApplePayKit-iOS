//
//  Merchant.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Merchant model.
public struct Merchant: Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Merchant identifier.
    public private(set) var identifier: String?
    
    /// Merchant name
    public private(set) var name: String?
    
    /// Merchant logo URL
    public private(set) var logoURL: String?
    
    /// Merchant Country code
    public private(set) var countryCode: String?
    
    // MARK: Methods
    
    /// Initializes merchant with the identifier.
    ///
    /// - Parameter identifier: Merchant identifier.
    internal init(identifier: String) {
        
        self.identifier    = identifier
    }
    
    
    /// Initializes merchant with the identifier.
    ///
    /// - Parameter logoURL: Merchant logo url.
    /// - Parameter name: Merchant name
    /// - Parameter countryCode: Merchant country code
    internal init(logoURL: String, name: String, countryCode:String? = nil) {
        
        self.name           = name
        self.logoURL        = logoURL
        self.countryCode    = countryCode
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier     = "id"
        case name           = "name"
        case logoURL        = "logo"
        case countryCode    = "country_code"
    }
}
