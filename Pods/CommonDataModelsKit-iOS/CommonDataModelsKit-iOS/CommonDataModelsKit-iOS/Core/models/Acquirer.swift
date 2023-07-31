//
//  Acquirer.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Acquirer information class.
@objcMembers
@objc(CheckoutAcquirer) public final class Acquirer: NSObject, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Acquirer response.
    public private(set) var response: Response?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case response = "response"
    }
}

extension Acquirer: Encodable {
    
}
