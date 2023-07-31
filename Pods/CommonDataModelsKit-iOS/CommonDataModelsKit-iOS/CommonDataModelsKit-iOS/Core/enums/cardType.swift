//
//  cardType.swift
//  goSellSDK
//
//  Created by Osama Rabie on 01/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//


/// Enum defining SDK mode.
@objc(CheckoutCardTypes) public enum cardTypes: Int, CaseIterable {
    
    @objc(Credit)       case Credit
    @objc(Debit)        case Debit
    @objc(All)          case All
}

// MARK: - Encodable
extension cardTypes: Encodable {
}

// MARK: - Decodable
extension cardTypes: Decodable {
}


// MARK: - CustomStringConvertible
extension cardTypes: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            case .Credit:         return "Credit"
            case .Debit:          return "Debit"
            case .All:            return "All"
        }
    }
    
    public static func from(string:String) -> cardTypes {
        guard let cardType:cardTypes = cardTypes.allCases.first(where: { $0.description.lowercased() == string.lowercased() }) else {
            fatalError("Cannot create a card of type \(string)")
        }
        return cardType
    }
}

