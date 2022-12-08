//
//  SaveCardCustomerDataSectionEnum.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 01/11/2022.
//

import Foundation

/**
 Defines the different section we may have when we are collecting customer's data when he saves a card for TAP. For example, Contact details & Shipping.
 */
@objc public enum SaveCardCustomerDataSectionEnum: Int, CaseIterable {
    
    /// CONTACT DETAILS info section
    @objc(ContactDetails) case contactDetails
    
    /// SHIPPING info section
    @objc(ShippingDetails) case shipping
    
    // MARK: - Internal -
    // MARK: Properties
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringRepresentation: String {
        
        switch self {
            
        case .contactDetails:   return "CONTACT_DETAILS"
        case .shipping:         return "SHIPPING"
            
        }
    }
    
    // MARK: Methods
    
    private init(stringRepresentation: String) {
        
        switch stringRepresentation {
            
        case SaveCardCustomerDataSectionEnum.contactDetails.stringRepresentation:
            
            self = .contactDetails
            
        case SaveCardCustomerDataSectionEnum.shipping.stringRepresentation:
            
            self = .shipping
            
        default:
            
            self = .contactDetails
        }
    }
}

// MARK: - CustomStringConvertible
extension SaveCardCustomerDataSectionEnum: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .shipping:             return "SHIPPING"
        case .contactDetails:       return "CONTACT_DETAILS"
        }
    }
}

// MARK: - Encodable
extension SaveCardCustomerDataSectionEnum: Encodable {
    
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
extension SaveCardCustomerDataSectionEnum: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        self.init(stringRepresentation: stringValue)
    }
}
