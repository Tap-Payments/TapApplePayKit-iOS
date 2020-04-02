//
//  TapApplePayRequest.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 01/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import PassKit

/// The class that represents the request details that identefies the transaction
@objc public class TapApplePayRequest:NSObject {
    
    /// The country code where the user transacts
    lazy var countryCode:TapCountryCode = .US
    /// The currency code the transaction has
    lazy var currencyCode:TapCurrencyCode = .USD
    /// The payment networks you  want to limit the payment to
    lazy var paymentNetworks:[TapApplePayPaymentNetwork] = []
    /// What are the items you want to show in the apple pay sheet
    lazy var paymentItems:[PKPaymentSummaryItem] = []
    /// The total amount you want to collect
    lazy var paymentAmount:Double = 0
    /// The apple pay merchant identefier
    lazy var merchantID:String = ""
    
    /// The actual apple pay request
    internal lazy var appleRequest:PKPaymentRequest = .init()
    
    /**
     Creates a Tap Apple Pay request that can be used afterards to make an apple pay request
     - Parameter countryCode: The country code where the user transacts default .US
     - Parameter currencyCode: The currency code the transaction has default .USD
     - Parameter paymentNetworks:  The payment networks you  want to limit the payment to default []
     - Parameter var paymentItems: What are the items you want to show in the apple pay sheet default  []
     - Parameter paymentAmount: The total amount you want to collect default 0
     - Parameter merchantID: The apple pay merchant identefier default ""
     **/
    public func build(with countryCode:TapCountryCode, paymentNetworks:[TapApplePayPaymentNetwork] = [], paymentItems:[PKPaymentSummaryItem] = [], paymentAmount:Double = 0,currencyCode:TapCurrencyCode = .USD,merchantID:String) {
        self.countryCode = countryCode
        self.paymentNetworks = paymentNetworks
        self.paymentItems = paymentItems
        self.paymentAmount = paymentAmount
        self.currencyCode = currencyCode
        self.merchantID = merchantID
        configureApplePayRequest()
    }
    
    
    internal func configureApplePayRequest() {
        appleRequest = .init()
        appleRequest.countryCode = countryCode.rawValue
        appleRequest.currencyCode = currencyCode.rawValue
        appleRequest.paymentSummaryItems = paymentItems
        appleRequest.supportedNetworks = paymentNetworks.map{ $0.applePayNetwork! }
        appleRequest.merchantIdentifier = merchantID
    }
}
