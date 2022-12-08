//
//  SaveCardCustomerDataSFieldEnum.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 01/11/2022.
//

import Foundation
import UIKit

/**
 Defines the different fields we may have when we are collecting customer's data when he saves a card for TAP. For example, phone, email etc
 */
@objc public enum SaveCardCustomerDataSFieldEnum: Int, CaseIterable {
    
    /// CONTACT DETAILS --> Email
    @objc(Email) case email
    
    /// CONTACT DETAILS --> Phone
    @objc(Phone) case phone
    
    /// SHIPPING DETAILS --> flat number
    @objc(Flat) case flat
    
    /// SHIPPING DETAILS --> additional line
    @objc(AdditionalLine) case additionalLine
    
    /// SHIPPING DETAILS --> city
    @objc(City) case city
    
    /// SHIPPING DETAILS --> country
    @objc(CountryDetails) case country
    
    
    // MARK: - Internal -
    // MARK: Properties
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringRepresentation: String {
        
        switch self {
        case .email:
            return "email"
        case .phone:
            return "phone"
        case .flat:
            return "flat"
        case .additionalLine:
            return "additionalLine"
        case .city:
            return "city"
        case .country:
            return "country"
        }
    }
    
    // MARK: Methods
    
    private init(stringRepresentation: String) {
        
        switch stringRepresentation {
            
        case SaveCardCustomerDataSFieldEnum.email.stringRepresentation:
            
            self = .email
            
        case SaveCardCustomerDataSFieldEnum.phone.stringRepresentation:
            
            self = .phone
            
        case SaveCardCustomerDataSFieldEnum.flat.stringRepresentation:
            
            self = .flat
            
        case SaveCardCustomerDataSFieldEnum.additionalLine.stringRepresentation:
            
            self = .additionalLine
            
        case SaveCardCustomerDataSFieldEnum.city.stringRepresentation:
            
            self = .city
            
        case SaveCardCustomerDataSFieldEnum.country.stringRepresentation:
            
            self = .country
            
        default:
            
            self = .email
        }
    }
    
    // MARK: Public methods
    /// Decides which keyboard type to be displayed with the field
    public func keyboardType() -> UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        case .phone:
            return .phonePad
        case .flat:
            return .numberPad
        case .additionalLine:
            return .default
        case .city:
            return .default
        case .country:
            return .default
        }
    }
    
    /// Decides which section does this field belong to
    public func fieldSection() -> SaveCardCustomerDataSectionEnum {
        switch self {
        case .email,.phone:
            return .contactDetails
        case .flat,.additionalLine,.city,.country:
            return .shipping
        }
    }
}

// MARK: - CustomStringConvertible
extension SaveCardCustomerDataSFieldEnum: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .email:
            return "email"
        case .phone:
            return "phone"
        case .flat:
            return "flat"
        case .additionalLine:
            return "additionalLine"
        case .city:
            return "city"
        case .country:
            return "country"
        }
    }
}

// MARK: - Encodable
extension SaveCardCustomerDataSFieldEnum: Encodable {
    
    /// Encodes the contents of the receiver.
    ///
    /// - Parameter encoder: Encoder.
    /// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringRepresentation)
    }
}

// MARK: - Decodable
extension SaveCardCustomerDataSFieldEnum: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        self.init(stringRepresentation: stringValue)
    }
}
