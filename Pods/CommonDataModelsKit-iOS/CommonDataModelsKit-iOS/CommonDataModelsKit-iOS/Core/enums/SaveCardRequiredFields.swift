//
//  SaveCardRequiredFields.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 01/11/2022.
//

import Foundation

/// Model that defines which data we shall collect when the user chooses to save card for tap
@objcMembers public final class SaveCardRequiredFields: NSObject {
    
    
    // MARK: - Public -
    // MARK: Properties
    
    /// The list of fields to collect under the contact details section
    public let contactDetails: [SaveCardCustomerDataSFieldEnum]?
    
    /// The list of fields to collect under the shipping details section
    public let shippingDetails: [SaveCardCustomerDataSFieldEnum]?
    
    
    
    // MARK: Methods
    
    /// Initializes `SaveCardRequiredFields`.
    ///
    /// - Parameter contactDetails: The list of fields to collect under the contact details section
    /// - Parameter shippingDetails: The list of fields to collect under the shipping details section
    public init(contactDetails: [SaveCardCustomerDataSFieldEnum]? = nil, shippingDetails: [SaveCardCustomerDataSFieldEnum]? = nil) {
        self.contactDetails = contactDetails
        self.shippingDetails = shippingDetails
    }
    
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        case shipping       = "SHIPPING"
        case contact        = "CONACT_DETAILS"
    }
}



// MARK: - Encodable
extension SaveCardRequiredFields: Encodable {
    
    /// Encodes the contents of the receiver.
    ///
    /// - Parameter encoder: Encoder.
    /// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.shippingDetails, forKey: .shipping)
        try container.encodeIfPresent(self.contactDetails, forKey: .contact)
    }
}

// MARK: - Decodable
extension SaveCardRequiredFields: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container       = try decoder.container(keyedBy: CodingKeys.self)
        
        let contact         = try container.decodeIfPresent ([SaveCardCustomerDataSFieldEnum].self,           forKey: .contact)
        let shipping        = try container.decodeIfPresent ([SaveCardCustomerDataSFieldEnum].self,           forKey: .shipping)
        
        self.init(contactDetails: contact, shippingDetails: shipping)
    }
}
