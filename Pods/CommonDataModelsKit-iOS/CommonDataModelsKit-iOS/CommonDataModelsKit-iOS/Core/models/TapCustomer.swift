//
//  TapCustomer.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 11/15/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
/** Represents the model for parsing the a customer object coming from Tap backend
 {
 "customer": {
 "id": "cus_xxxxxxxx",
 "first_name": "haitham",
 "middle_name": "mohammad",
 "last_name": "elsheshtawy",
 "email": "haitham@test.com",
 "phone": {
 "country_code": "965",
 "number": "00000000"
 },
 "description": "test",
 "metadata": {
 "udf1": "test"
 },
 "nationality": "KW",
 "currency": "KWD"
 }
 }
 - tag: TapCustomer
 */
@objcMembers public class TapCustomer : NSObject, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Customer identifier (if you know it).
    public var identifier: String?
    
    /// Customer's email address. Please check [TapEmailAddress](x-source-tag://TapEmailAddress)
    public var emailAddress: TapEmailAddress?
    
    /// Customer's phone number. Please check [TapPhone](x-source-tag://TapPhone)
    public var phoneNumber: TapPhone?
    
    /// Customer's first name.
    public var firstName: String?
    
    /// Customer's address
    public var address: Address?
    
    /// Customer's middle name.
    public var middleName: String?
    
    /// Customer's last name.
    public var lastName: String?
    
    /// An arbitrary string attached to the object. Often useful for displaying to users.
    public var descriptionText: String?
    
    /// Set of key/value pairs that you can attach to an object. It can be useful for storing additional information about the object in a structured format. Please check [TapMetadata](x-source-tag://TapMetadata)
    public var metadata: TapMetadata?
    
    /// Customer title.
    public var title: String?
    
    /// Customer's nationality.
    public var nationality: String?
    
    /// Currency in which customer can be charged.
    public var currency: TapCurrencyCode?
    
    /// Customer's locale.
    public var locale: String?
    
    /// If we want to preload a name valye in the card holder name field
    public var nameOnCard:String = ""
    /// If we want to make the card holder name field editable
    public var editable:Bool = true
    
    // MARK: Methods
    
    
    /**
     Used internally to create a default testing customer.
     - Returns: A default tap customer for testing with the email of "taptestingemail@gmail.com"
     */
    public static func defaultCustomer() -> TapCustomer {
        return try! .init(emailAddress: TapEmailAddress(emailAddressString: "taptestingemail@gmail.com"), phoneNumber: .init(isdNumber: "965", phoneNumber: "90064542"), name: "Tap Testing Default",address: nil)
    }
    
    
    /// Initializes the customer with email address, phone number and a name.
    ///
    /// - Parameters:
    ///   - emailAddress: Email address. Please check [TapEmailAddress](x-source-tag://TapEmailAddress)
    ///   - phoneNumber: Phone number. Please check [TapPhone](x-source-tag://TapPhone)
    ///   - name: Name.
    ///   - nameOnCard: If we want to preload a name valye in the card holder name field
    ///   - editable: If we want to make the card holder name field editable
    /// - Throws: Invalid customer info error.
    public convenience init(emailAddress: TapEmailAddress?, phoneNumber: TapPhone?, name: String,address:Address?, nameOnCard:String = "", editable:Bool = true) throws {
        try self.init(emailAddress: emailAddress, phoneNumber: phoneNumber, firstName: name, middleName: nil, lastName: nil,address:address, nameOnCard: nameOnCard, editable: editable)
    }
    
    /// Initializes the customer with email address, phone number and a name.
    ///
    /// - Parameters:
    ///   - emailAddress: Email address. Please check [TapEmailAddress](x-source-tag://TapEmailAddress)
    ///   - phoneNumber: Phone number. Please check [TapPhone](x-source-tag://TapPhone)
    ///   - name: Name.
    ///   - nameOnCard: If we want to preload a name valye in the card holder name field
    ///   - editable: If we want to make the card holder name field editable
    /// - Warning: This method returns `nil` if you pass invalid customer data.
    @available(swift, obsoleted: 1.0)
    @objc(initWithEmailAddress:phoneNumber:name:address:nameOnCard:editable:)
    public convenience init?(with emailAddress: TapEmailAddress, phoneNumber: TapPhone, name: String,address:Address?, nameOnCard:String = "", editable:Bool = true) {
        
        try? self.init(emailAddress: emailAddress, phoneNumber: phoneNumber, name: name, address: address, nameOnCard: nameOnCard, editable: editable)
    }
    
    /// Initializes the customer with email address, phone number, first name, middle name and last name.
    ///
    /// - Parameters:
    ///   - emailAddress: Email address. Please check [TapEmailAddress](x-source-tag://TapEmailAddress)
    ///   - phoneNumber: Phone number. Please check [TapPhone](x-source-tag://TapPhone)
    ///   - firstName: First name.
    ///   - middleName: Middle name.
    ///   - lastName: Last name.
    ///   - nameOnCard: If we want to preload a name valye in the card holder name field
    ///   - editable: If we want to make the card holder name field editable
    /// - Throws: Invalid customer info error.
    public convenience init(emailAddress: TapEmailAddress?, phoneNumber: TapPhone?, firstName: String, middleName: String?, lastName: String?, address:Address?, nameOnCard:String = "", editable:Bool = true) throws {
        if emailAddress == nil && phoneNumber == nil {
            throw("A customer must have at least an email or a phone number")
        }
        try self.init(identifier: nil, emailAddress: emailAddress, phoneNumber: phoneNumber, firstName: firstName, middleName: middleName, lastName: lastName, address: address, nameOnCard: nameOnCard, editable: editable)
    }
    
    /// Initializes the customer with email address, phone number, first name, middle name and last name.
    ///
    /// - Parameters:
    ///   - emailAddress: Email address. Please check [TapEmailAddress](x-source-tag://TapEmailAddress)
    ///   - phoneNumber: Phone number. Please check [TapPhone](x-source-tag://TapPhone)
    ///   - firstName: First name.
    ///   - middleName: Middle name.
    ///   - lastName: Last name.
    ///   - nameOnCard: If we want to preload a name valye in the card holder name field
    ///   - editable: If we want to make the card holder name field editable
    /// - Warning: This method returns `nil` if you pass invalid customer data.
    @available(swift, obsoleted: 1.0)
    @objc(initWithEmailAddress:phoneNumber:firstName:middleName:lastName:address:nameOnCard:editable:)
    public convenience init?(with emailAddress: TapEmailAddress, phoneNumber: TapPhone, firstName: String, middleName: String?, lastName: String?, address:Address?, nameOnCard:String = "", editable:Bool = true) {
        
        try? self.init(emailAddress: emailAddress, phoneNumber: phoneNumber, firstName: firstName, middleName: middleName, lastName: lastName, address: address, nameOnCard: nameOnCard, editable: editable)
    }
    
    /// Initializes the customer with the customer identifier.
    ///
    /// - Parameters:
    ///    - identifier: Customer identifier.
    ///   - nameOnCard: If we want to preload a name valye in the card holder name field
    ///   - editable: If we want to make the card holder name field editable
    ///
    /// - Throws: Invalid customer info error.
    public convenience init(identifier: String,  nameOnCard:String = "", editable:Bool = true) throws {
        
        try self.init(identifier: identifier, emailAddress: nil, phoneNumber: nil, firstName: nil, middleName: nil, lastName: nil, address: nil, nameOnCard: nameOnCard, editable: editable)
    }
    
    /// Initializes the customer with the customer identifier.
    ///
    /// - Parameter identifier: Customer identifier.
    /// - Warning: This method returns `nil` if you pass invalid customer data.
    @available(swift, obsoleted: 1.0)
    @objc(initWithIdentifier:)
    public convenience init?(with identifier: String) {
        
        try? self.init(identifier: identifier)
    }
    
    /// Checks if the receiver is equal to `object.`
    ///
    /// - Parameter object: Object to test equality with.
    /// - Returns: `true` if the receiver is equal to `object`, `false` otherwise.
    public override func isEqual(_ object: Any?) -> Bool {
        
        guard let otherCustomer = object as? TapCustomer else { return false }
        
        if let firstIdentifier = self.identifier, let otherIdentifier = otherCustomer.identifier, firstIdentifier.tap_length > 0, otherIdentifier.tap_length > 0 {
            
            return firstIdentifier == otherIdentifier
        }
        
        return
        
        self.firstName      == otherCustomer.firstName      &&
        self.middleName     == otherCustomer.middleName     &&
        self.lastName       == otherCustomer.lastName       &&
        self.emailAddress   == otherCustomer.emailAddress   &&
        self.phoneNumber    == otherCustomer.phoneNumber
    }
    
    /// Checks if 2 objects are equal.
    ///
    /// - Parameters:
    ///   - lhs: First object.
    ///   - rhs: Second object.
    /// - Returns: `true` if 2 objects are equal, `fale` otherwise.
    public static func == (lhs: TapCustomer, rhs: TapCustomer) -> Bool {
        
        return lhs.isEqual(rhs)
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func validateFields() {
        
        if let identifier = self.identifier, identifier.tap_length == 0 {
            
            self.identifier = nil
        }
        
        self.firstName              = self.firstName?.tap_trimWhitespacesAndNewlines(nullifyIfResultIsEmpty: true)
        self.middleName             = self.middleName?.tap_trimWhitespacesAndNewlines(nullifyIfResultIsEmpty: true)
        self.lastName               = self.lastName?.tap_trimWhitespacesAndNewlines(nullifyIfResultIsEmpty: true)
        self.descriptionText        = self.descriptionText?.tap_trimWhitespacesAndNewlines(nullifyIfResultIsEmpty: true)
        self.title                  = self.title?.tap_trimWhitespacesAndNewlines(nullifyIfResultIsEmpty: true)
        self.nationality            = self.nationality?.tap_trimWhitespacesAndNewlines(nullifyIfResultIsEmpty: true)
        self.nameOnCard             = self.nameOnCard.tap_trimWhitespacesAndNewlines(nullifyIfResultIsEmpty: true) ?? ""
        self.locale                 = "ar"
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier         = "id"
        case emailAddress       = "email"
        case phoneNumber        = "phone"
        case firstName          = "first_name"
        case middleName         = "middle_name"
        case lastName           = "last_name"
        case descriptionText    = "description"
        case metadata           = "metadata"
        case title              = "title"
        case nationality        = "nationality"
        case currency           = "currency"
        case address            = "address"
        case locale             = "locale"
        case nameOnCard         = "name_on_card"
        case editable           = "editable"
    }
    
    // MARK: Methods
    
    @available(*, unavailable) private override init() { super.init() }
    
    private init(identifier: String?, emailAddress: TapEmailAddress?, phoneNumber: TapPhone?, firstName: String?, middleName: String?, lastName: String?, address:Address?, nameOnCard:String = "", editable:Bool = true) throws {
        
        self.identifier         = identifier
        self.emailAddress       = emailAddress
        self.phoneNumber        = phoneNumber
        self.firstName          = firstName
        self.middleName         = middleName
        self.lastName           = lastName
        self.address            = address
        self.locale             = "ar"
        self.nameOnCard         = nameOnCard
        self.editable           = editable
        super.init()
        
        self.validateFields()
    }
}

// MARK: - NSCopying
extension TapCustomer: NSCopying {
    
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        let emailAddressCopy    = self.emailAddress?.copy() as? TapEmailAddress
        let phoneNumberCopy        = self.phoneNumber?.copy() as? TapPhone
        let currencyCopy        = self.currency
        let addressCopy         = self.address?.copy() as? Address
        
        let result = try! TapCustomer(identifier:   self.identifier,
                                      emailAddress: emailAddressCopy,
                                      phoneNumber:  phoneNumberCopy,
                                      firstName:    self.firstName,
                                      middleName:   self.middleName,
                                      lastName:     self.lastName,
                                      address:      addressCopy,
                                      nameOnCard:   self.nameOnCard,
                                      editable:     self.editable)
        
        result.descriptionText  = self.descriptionText
        result.metadata         = self.metadata
        result.title            = self.title
        result.nationality      = self.nationality
        result.currency         = currencyCopy
        result.locale           = self.locale
        result.nameOnCard       = self.nameOnCard
        result.editable         = self.editable
        return result
    }
}

// MARK: - Encodable
extension TapCustomer: Encodable {
    
    /// Encodes the contents of the receiver.
    ///
    /// - Parameter encoder: Encoder.
    /// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        self.validateFields()
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.identifier,      forKey: .identifier)
        try container.encodeIfPresent(self.emailAddress,    forKey: .emailAddress)
        try container.encodeIfPresent(self.phoneNumber,     forKey: .phoneNumber)
        try container.encodeIfPresent(self.firstName,       forKey: .firstName)
        try container.encodeIfPresent(self.middleName,      forKey: .middleName)
        try container.encodeIfPresent(self.lastName,        forKey: .lastName)
        try container.encodeIfPresent(self.descriptionText, forKey: .descriptionText)
        try container.encodeIfPresent(self.metadata,        forKey: .metadata)
        try container.encodeIfPresent(self.title,           forKey: .title)
        try container.encodeIfPresent(self.nationality,     forKey: .nationality)
        try container.encodeIfPresent(self.currency,        forKey: .currency)
        try container.encodeIfPresent(self.address,         forKey: .address)
        try container.encodeIfPresent(self.locale,          forKey: .locale)
        try container.encodeIfPresent(self.nameOnCard,      forKey: .nameOnCard)
        try container.encodeIfPresent(self.editable,        forKey: .editable)
        
        
    }
}
