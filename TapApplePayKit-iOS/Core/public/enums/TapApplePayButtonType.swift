//
//  TapApplePayButtonType.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 01/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import PassKit.PKConstants

/// Enum to define  the type/context of the TapApplePayButton, this will effect the title on the button
@objc public enum TapApplePayButtonType: Int, RawRepresentable, CaseIterable {
    
    case AppleLogoOnly
    case BuyWithApplePay
    case SetupApplePay
    case PayWithApplePay
    case DonateWithApplePay
    case CheckoutWithApplePay
    case BookWithApplePay
    case SubscribeWithApplePay
    
    
    
    /// Coming constcutors to spport creating enums from String in case of parsing it from JSON
    public init?(rawValue: String) {
        switch rawValue.lowercased() {
            case "plain":
                self = .AppleLogoOnly
            case "buy":
            self = .BuyWithApplePay
            case "setup":
                self = .SetupApplePay
            case "pay":
                self = .PayWithApplePay
            case "donate":
                self = .DonateWithApplePay
            case "checkout":
                self = .CheckoutWithApplePay
            case "book":
                self = .BookWithApplePay
            case "subscripe":
                self = .SubscribeWithApplePay
            default:
                return nil
        }
    }
    
    
    public init?(applePayButtonType: PKPaymentButtonType) {
        switch applePayButtonType {
        case .plain:
            self = .AppleLogoOnly
        case .buy:
        self = .BuyWithApplePay
        case .setUp:
            self = .SetupApplePay
        case .inStore:
            self = .PayWithApplePay
        case .donate:
            self = .DonateWithApplePay
        case .checkout:
            self = .CheckoutWithApplePay
        case .book:
            self = .BookWithApplePay
        case .subscribe:
            self = .SubscribeWithApplePay
            default:
                return nil
        }
    }
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
            case .AppleLogoOnly:
                return "Plain"
            case .BuyWithApplePay:
            return "Buy"
            case .SetupApplePay:
                return "Setup"
            case .PayWithApplePay:
                return "Pay"
            case .DonateWithApplePay:
                return "Donate"
            case .CheckoutWithApplePay:
                return "Checkout"
            case .BookWithApplePay:
                return "Book"
            case .SubscribeWithApplePay:
                return "Subscribe"
        default:
            return ""
        }
    }
    
    public var applePayButtonType: PKPaymentButtonType? {
        switch self {
            case .AppleLogoOnly:
                return .plain
            case .BuyWithApplePay:
                return .buy
            case .SetupApplePay:
                return .setUp
            case .PayWithApplePay:
                return .inStore
            case .DonateWithApplePay:
                return .donate
            case .CheckoutWithApplePay:
                return .checkout
            case .BookWithApplePay:
                return .book
            case .SubscribeWithApplePay:
                return .subscribe
        default:
            return nil
        }
    }
}
