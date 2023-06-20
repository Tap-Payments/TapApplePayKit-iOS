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
    
    /// Defines the recurring payment request Please check [Apple Pay docs](https://developer.apple.com/documentation/passkit/pkrecurringpaymentrequest). NOTE: This will only be availble for iOS 16+ and subscripion parameter is on.
    public lazy var recurringPaymentRequest:Any? = nil
    
    /**
     Creates a Tap Apple Pay request that can be used afterards to make an apple pay request
     - Parameter currencyCode: The currency code the transaction has default .USD
     - Parameter paymentNetworks:  The payment networks you  want to limit the payment to default [.Amex,.Visa,.Mada,.MasterCard]
     - Parameter var paymentItems: What are the items you want to show in the apple pay sheet default  []
     - Parameter paymentAmount: The total amount you want to collect
     - Parameter merchantID: The apple pay merchant identefier default ""
     - Parameter recurringPaymentRequest: Defines the recurring payment request Please check [Apple Pay docs](https://developer.apple.com/documentation/passkit/pkrecurringpaymentrequest). NOTE: This will only be availble for iOS 16+ and subscripion parameter is on.
     **/
    public func build(paymentNetworks:[TapApplePayPaymentNetwork] = [.Amex,.Visa,.MasterCard], paymentItems:[PKPaymentSummaryItem] = [], paymentAmount:Double,currencyCode:TapCurrencyCode = .USD,merchantID:String,merchantCapabilities:PKMerchantCapability = [.capability3DS,.capabilityCredit,.capabilityDebit,.capabilityEMV], recurringPaymentRequest:Any? = nil) {
        self.paymentNetworks = paymentNetworks
        self.paymentItems = paymentItems
        self.paymentAmount = paymentAmount
        self.currencyCode = currencyCode
        self.merchantID = merchantID
        
        // Correctly define the recurring request
        if #available(iOS 16.0, *),
           let correctRecurring:PKRecurringPaymentRequest = recurringPaymentRequest as? PKRecurringPaymentRequest {
            correctRecurring.regularBilling.amount = NSDecimalNumber(decimal: Decimal(paymentAmount))
            self.recurringPaymentRequest = correctRecurring
        } else {
            // Fallback on earlier versions
            self.recurringPaymentRequest = nil
        }
        
        configureApplePayRequest()
    }
    
    internal func updateValues() {
        configureApplePayRequest()
    }
    
    internal func configureApplePayRequest() {
        appleRequest = .init()
        if let countryCode:String = TapApplePay.intitModelResponse?.data.merchant?.countryCode {
            appleRequest.countryCode = countryCode.uppercased()
        }
        appleRequest.currencyCode = currencyCode.appleRawValue
        appleRequest.paymentSummaryItems = paymentItems
        appleRequest.paymentSummaryItems.append(.init(label: "\(TapApplePay.intitModelResponse?.data.merchant?.name ?? "")", amount: NSDecimalNumber(value: paymentAmount)))
        appleRequest.supportedNetworks = paymentNetworks.map{ $0.applePayNetwork! }
        appleRequest.merchantIdentifier = merchantID
        appleRequest.merchantCapabilities = [.capability3DS]
        // Check subscription details
        if #available(iOS 16.0, *),
           let correctRecurring:PKRecurringPaymentRequest = recurringPaymentRequest as? PKRecurringPaymentRequest {
            appleRequest.recurringPaymentRequest = correctRecurring
            appleRequest.paymentSummaryItems = [correctRecurring.regularBilling]
        }
    }
    
    internal func asDictionary() -> [String:String] {
        
        let countryCode:String = TapApplePay.intitModelResponse?.data.merchant?.countryCode?.uppercased() ?? ""
        
        let dictionary:[String:String] =
        ["countryCode":countryCode,
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
