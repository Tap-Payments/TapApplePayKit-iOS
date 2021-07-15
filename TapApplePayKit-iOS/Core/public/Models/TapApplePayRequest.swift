//
//  TapApplePayRequest.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 01/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import PassKit
import enum CommonDataModelsKit_iOS.TapCountryCode
import enum CommonDataModelsKit_iOS.TapCurrencyCode

/// The class that represents the request details that identefies the transaction
@objc public class TapApplePayRequest:NSObject {
    
    /// The country code where the user transacts
    public lazy var countryCode:TapCountryCode = .US
    /// The currency code the transaction has
    public lazy var currencyCode:TapCurrencyCode = .USD
    /// The payment networks you  want to limit the payment to
    public lazy var paymentNetworks:[TapApplePayPaymentNetwork] = [.Amex,.Visa, .MasterCard]
    /// What are the items you want to show in the apple pay sheet
    public lazy var paymentItems:[PKPaymentSummaryItem] = []
    /// The total amount you want to collect
    public lazy var paymentAmount:Double = 0
    /// The apple pay merchant identefier
    public lazy var merchantID:String = ""
    
    /// The actual apple pay request
    public lazy var appleRequest:PKPaymentRequest = .init()
    
    /**
     Creates a Tap Apple Pay request that can be used afterards to make an apple pay request
     - Parameter countryCode: The country code where the user transacts default .US
     - Parameter currencyCode: The currency code the transaction has default .USD
     - Parameter paymentNetworks:  The payment networks you  want to limit the payment to default [.Amex,.Visa,.Mada,.MasterCard]
     - Parameter var paymentItems: What are the items you want to show in the apple pay sheet default  []
     - Parameter paymentAmount: The total amount you want to collect
     - Parameter merchantID: The apple pay merchant identefier default ""
     **/
    public func build(with countryCode:TapCountryCode = .US, paymentNetworks:[TapApplePayPaymentNetwork] = [.Amex,.Visa,.MasterCard], paymentItems:[PKPaymentSummaryItem] = [], paymentAmount:Double,currencyCode:TapCurrencyCode = .USD,merchantID:String,merchantCapabilities:PKMerchantCapability = [.capability3DS,.capabilityCredit,.capabilityDebit,.capabilityEMV]) {
        self.countryCode = countryCode
        self.paymentNetworks = paymentNetworks
        self.paymentItems = paymentItems
        self.paymentAmount = paymentAmount
        self.currencyCode = currencyCode
        self.merchantID = merchantID
        configureApplePayRequest()
    }
    
    internal func updateValues() {
        configureApplePayRequest()
    }
    
    internal func configureApplePayRequest() {
        appleRequest = .init()
        appleRequest.countryCode = countryCode.rawValue
        appleRequest.currencyCode = currencyCode.appleRawValue
        appleRequest.paymentSummaryItems = paymentItems
        appleRequest.paymentSummaryItems.append(.init(label: "", amount: NSDecimalNumber(value: paymentAmount)))
        appleRequest.supportedNetworks = paymentNetworks.map{ $0.applePayNetwork! }
        appleRequest.merchantIdentifier = merchantID
        appleRequest.merchantCapabilities = [.capability3DS]
    }
    
    internal func asDictionary() -> [String:String] {
        
        let dictionary:[String:String] =
            ["countryCode":self.countryCode.rawValue,
             "paymentNetworks":self.paymentNetworks.map{$0.rawValue}.joined(separator: " , "),
             "paymentItems":self.paymentItems.map{$0.label}.joined(separator: " , "),
             "currencyCode":self.currencyCode.appleRawValue,
             "merchantID":self.merchantID,
             "paymentAmount":String(self.paymentAmount),
            ]
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted]) {
            
            if let _ = String(data: theJSONData, encoding: .utf8) {
                return dictionary
            }
        }
        
        return [:]
    }
}
