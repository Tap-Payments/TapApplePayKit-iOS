//
//  CreateTokenSavedCard.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 7/7/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation

/// Model that holds existing card details for token creation.
public struct CreateTokenSavedCard: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Card identifier.
    internal let cardIdentifier: String
    
    /// Customer identifier.
    internal let customerIdentifier: String
    
    /// The ccv parameter
    internal let cardCVV:String?
    
    // MARK: Methods
    
    /// Initializes the model with card identifier and customer identifier.
    ///
    /// - Parameters:
    ///   - cardIdentifier: Card identifier.
    ///   - customerIdentifier: Customer identifier.
    public init(cardIdentifier: String, customerIdentifier: String, cardCVV:String?) {
        
        self.cardIdentifier = cardIdentifier
        self.customerIdentifier = customerIdentifier
        if let nonNullCardCVV:String = cardCVV,
           let encryptedCVV:String = try? nonNullCardCVV.secureEncoded() {
            self.cardCVV = encryptedCVV
        }else{
            self.cardCVV = cardCVV
        }
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case cardIdentifier     = "card_id"
        case customerIdentifier = "customer_id"
        case cardCVV            = "cvc"
    }
}



fileprivate extension String {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Secure encodes the model.
    ///
    /// - Parameter encoder: Encoder to use.
    /// - Returns: Secure encoded model.
    /// - Throws: Either encoding error or serialization error.
    func secureEncoded() throws -> String {
        
        guard let encryptionKey = SharedCommongDataModels.sharedCommongDataModels.encryptionKey else {
            
            throw "Secure encoding wrong data missing encryption key"
        }
        
        guard let encrypted = Crypter.encrypt(self, using: encryptionKey) else {
            
            throw "Secure encoding wrong data encrypting with the encryption key"
        }
        
        return encrypted
    }
}
