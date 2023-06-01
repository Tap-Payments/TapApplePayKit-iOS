//
//  TopUpApplication.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 06/09/2022.
//  Copyright © 2022 Tap Payments. All rights reserved.
//

import Foundation


/// TopUpApplication model.
@objcMembers
@objc(CheckoutTopUpApplication) public final class TopUpApplication: NSObject,Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// The minimum amount is $0.50 US or equivalent in charge currency.
    public let amount: Decimal
    
    /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
    public let currency: TapCurrencyCode
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case amount             = "amount"
        case currency           = "currency"
    }
    
    // MARK: Methods
    
    public init(amount: Decimal, currency:TapCurrencyCode) {
        
        self.amount             = amount
        self.currency           = currency
    }
}

// MARK: - Decodable
extension TopUpApplication {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let amount          = try container.decode          (Decimal.self,           forKey: .amount)
        let currency        = try container.decode          (TapCurrencyCode.self,          forKey: .currency)
        
        self.init(amount: amount, currency: currency)
    }
}
