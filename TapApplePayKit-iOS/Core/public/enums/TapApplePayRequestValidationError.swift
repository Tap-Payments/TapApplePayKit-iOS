//
//  TapApplePayRequestValidationError.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 02/06/2023.
//  Copyright © 2023 Tap Payments. All rights reserved.
//

import Foundation
/// This enum to list validation issues with data passed by the merchant
@objc public enum TapApplePayRequestValidationError:Int {
    /// This means the passed currency is not allowed for this merchant. Please contact Tap team to enable it
    case NotSupportedCurrency
    /// This means the passed card brand is not allowed for this merchant. Please contact Tap team to enable it
    case NotSupportedCardBrand
    /// This means that apple pay is not enabled for you. please contact Tap team to enable it
    case NotSupportedApplPay
    /// This means you didn't first initialize the tap apple pay sdk. you need to first call TapApplePay.setupTapMerchantApplePay
    case NotInitialized
    /// This means we can start the transaction safely
    case Valid
    
    
    public func TapApplePayRequestValidationErrorRawValue() -> String {
        switch self {
        case .NotSupportedCurrency:
            return "The passed currency is not allowed for this merchant. Please contact Tap team to enable it"
        case .NotSupportedCardBrand:
            return "The passed card brand is not allowed for this merchant. Please contact Tap team to enable it"
        case .NotInitialized:
            return "You didn't first initialize the tap apple pay sdk. you need to first call TapApplePay.setupTapMerchantApplePay"
        case .NotSupportedApplPay:
            return "This means that apple pay is not enabled for you. please contact Tap team to enable it"
        case .Valid:
            return "We can start the transaction safely"
        }
    }
}
