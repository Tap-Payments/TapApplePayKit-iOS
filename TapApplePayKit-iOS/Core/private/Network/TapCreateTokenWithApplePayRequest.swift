//
//  TapCreateTokenWithApplePayRequest.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 02/01/2023.
//  Copyright © 2023 Tap Payments. All rights reserved.
//

import Foundation
import CommonDataModelsKit_iOS

/// A model to represent the data we will send in a create token for apple pay token api request
internal struct TapCreateTokenWithApplePayRequest:TapCreateTokenRequest, Encodable,Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// The apple pay token data to be shared with the tokenize request
    internal let appleToken: TapApplePayTokenModel
    /// The payment type identifier required for the tokenize request
    internal let paymentType: String
    internal let route: CommonDataModelsKit_iOS.TapNetworkPath = .tokens
    // MARK: Methods
    
    /// Initializes the model with decoded apple pay token
    ///
    /// - Parameters:
    ///   - appleToken: The apple pay token data to be shared with the tokenize request
    internal init(appleToken: TapApplePayTokenModel) {
        
        self.appleToken = appleToken
        self.paymentType = "applepay"
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case appleToken     = "token_data"
        case paymentType     = "type"
    }
}




/// Model to represent the apple pay token we pass to the tokinize request
internal struct TapApplePayTokenModel: Encodable,Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// The apple pay iOS token version parameter
    internal let version: String
    /// The apple pay iOS token data
    internal let data: String
    /// The apple pay iOS token signature
    internal let signature: String
    /// The apple pay iOS token header data info
    internal let header: AppleTokenHeaderModel
    // MARK: Methods
    
    /// Initializes the model with decoded apple pay token
    ///
    /// - Parameters:
    ///     - version: The apple pay iOS token version parameter
    ///     - data: The apple pay iOS token data
    ///     - signature: The apple pay iOS token signature
    ///     - header: The apple pay iOS token header data info
    internal init(version: String,data: String,signature: String,header: AppleTokenHeaderModel) {
        
        self.version = version
        self.data = data
        self.signature = signature
        self.header = header
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case version    = "version"
        case data       = "data"
        case signature  = "signature"
        case header     = "header"
    }
}




/// Responsible for holding the apple pay header model to submit in the request call
internal struct AppleTokenHeaderModel: Encodable,Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Card identifier.
    internal let ephemeralPublicKey: String
    internal let publicKeyHash: String
    internal let transactionId: String
    // MARK: Methods
    
    /// Initializes the model with decoded apple pay token
    ///
    /// - Parameters:
    ///   - appleToken: The base64 apple pay token
    internal init(ephemeralPublicKey: String,publicKeyHash: String,transactionId: String) {
        
        self.ephemeralPublicKey = ephemeralPublicKey
        self.publicKeyHash = publicKeyHash
        self.transactionId = transactionId
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case ephemeralPublicKey        = "ephemeralPublicKey"
        case publicKeyHash             = "publicKeyHash"
        case transactionId             = "transactionId"
    }
}


