//
//  TapApplePayRequest.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 01/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import PassKit

@objc public class TapApplePayRequest:NSObject {
    
    lazy var countryCode:TapCountryCode = .US
    lazy var currencyCode:TapCurrencyCode = .USD
    var paymentNetworks:[TapApplePayPaymentNetwork] = []
    lazy var paymentItems:[PKPaymentSummaryItem] = []
    lazy var paymentAmount:Double = 0
    lazy var merchantID:String = ""
    internal lazy var appleRequest:PKPaymentRequest = .init()
    
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
