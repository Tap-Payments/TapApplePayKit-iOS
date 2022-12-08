//
//  Shipping.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Shipping data model class.
@objcMembers public final class Shipping: NSObject, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Shipping name.
    public var name: String
    
    /// Shipping description.
    public var descriptionText: String?
    
    /// Shipping amount.
    public var amount: Decimal
    
    /// Shipping currency
    public var currency:TapCurrencyCode
    
    /// Shipping reciepent name
    public var recipientName:String?
    
    /// Shipping address
    public var address:Address?
    
    /// Shipping provider
    public var provider:ShippingProvider?
    
    // MARK: Methods
    
    /// Initializes `Shipping` model with the `name` and `amount`.
    ///
    /// - Parameters:
    ///   - name: Shipping name.
    ///   - amount: Shipping amount.
    public convenience init(name: String, amount: Decimal) {
        
        self.init(name: name, descriptionText: nil, amount: amount)
    }
    
    /// Initializes `Shipping` model with the `name`, `descriptionText` and `amount`.
    ///
    /// - Parameters:
    ///   - name: Shipping name.
    ///   - descriptionText: Shipping description.
    ///   - amount: Shipping amount.
    public init(name: String, descriptionText: String?, amount: Decimal, currency: TapCurrencyCode = .undefined, recipientName:String? = nil, address:Address? = nil, provider: ShippingProvider? = nil) {
        
        self.name = name
        self.descriptionText = descriptionText
        self.amount = amount
        self.recipientName = recipientName
        self.currency = currency
        self.address = address
        self.provider = provider
        
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case name               = "name"
        case descriptionText    = "description"
        case amount             = "amount"
        case currency           = "currency"
        case recipientName      = "recipient_name"
        case address            = "address"
        case provider           = "provider"
    }
}

// MARK: - NSCopying
extension Shipping: NSCopying {
    
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        return Shipping(name: self.name, descriptionText: self.descriptionText, amount: self.amount, currency: self.currency, recipientName: self.recipientName, address: self.address, provider: self.provider)
    }
}


/// The shipping provider model class
@objcMembers public final class ShippingProvider: NSObject, Codable {
    
    @objc public init(id: String, name: String? = nil) {
        self.id = id
        self.name = name
    }
    
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Shipping provider id
    public var id: String
    
    /// Shipping provider name.
    public var name: String?
    
    
}
