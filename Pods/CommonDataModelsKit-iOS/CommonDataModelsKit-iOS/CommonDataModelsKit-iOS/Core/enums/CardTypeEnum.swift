//
//  AcceptedCardType.swift
//  goSellSDK
//
//  Created by Osama Rabie on 19/02/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
/// Card Types the merchanty will use to define what types of cards he wants his clients to use
@objcMembers
@objc(CheckoutCardType) public class CardType:NSObject, Decodable {
    
    
    public var cardType:cardTypes = .All
    
    public init(cardTypeString:String) {
        if cardTypeString.lowercased() == "credit"
        {
            self.cardType = .Credit
        }else if cardTypeString.lowercased() == "debit"
        {
            self.cardType = .Debit
        }else
        {
            self.cardType = .All
        }
    }
    
    public init(cardType:cardTypes) {
        self.cardType = cardType
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let other = object as? CardType {
            return self.cardType == other.cardType
        } else {
            return false
        }
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let cardType  = try container.decode(String.self, forKey: .cardType)
        self.init(cardTypeString: cardType)
    }
}





// MARK: - Encodable
extension CardType: Encodable {
    private enum CodingKeys: String, CodingKey {
        
        case cardType = "card_type"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(cardType, forKey: .cardType)
    }
}
