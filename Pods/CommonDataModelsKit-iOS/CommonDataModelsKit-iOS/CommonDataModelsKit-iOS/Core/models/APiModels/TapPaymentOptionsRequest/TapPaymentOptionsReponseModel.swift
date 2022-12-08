//
//  TapPaymentOptionsReponseModel.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 6/15/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
import TapCardVlidatorKit_iOS

/// Payment Options Response model.
public struct TapPaymentOptionsReponseModel: IdentifiableWithString {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Object identifier.
    public let identifier: String
    
    /// Object type.
    internal let object: String
    
    /// List of available payment options.
    public var paymentOptions: [PaymentOption]
    
    /// Transaction currency.
    public let currency: TapCurrencyCode
    
    /// Merchant iso country code.
    internal let merchantCountryCode: String?
    
    /// Amount for different currencies.
    public let supportedCurrenciesAmounts: [AmountedCurrency]
    
    /// Saved cards.
    public var savedCards: [SavedCard]?
    
    /// Order data
    public var order: Order?
    
    /// The dummy loyalty view model
    public var loyaltyModel: TapLoyaltyModel?
    
    /// The dummy customer data fields to be collected models
    public var saveCardForTapCollectionFields: SaveCardRequiredFields?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case currency                   = "currency"
        case identifier                 = "id"
        case object                     = "object"
        case paymentOptions             = "payment_methods"
        case supportedCurrenciesAmounts = "supported_currencies"
        
        
        case savedCards                 = "cards"
        
        case merchantCountryCode        = "country"
        
        case order                      = "order"
    }
    
    // MARK: Methods
    
    public init(identifier:                        String,
                object:                            String,
                paymentOptions:                    [PaymentOption],
                currency:                          TapCurrencyCode,
                supportedCurrenciesAmounts:        [AmountedCurrency],
                savedCards:                        [SavedCard]?,
                merchantCountryCode:               String?,
                order:                             Order?,
                loyalty:                           TapLoyaltyModel?,
                saveCardForTapCollectionFields:    SaveCardRequiredFields?) {
        
        self.identifier                     = identifier
        self.object                         = object
        self.paymentOptions                 = paymentOptions
        self.currency                       = currency
        self.supportedCurrenciesAmounts     = supportedCurrenciesAmounts
        self.savedCards                     = savedCards
        self.merchantCountryCode            = merchantCountryCode
        self.order                          = order
        self.loyaltyModel                   = loyalty
        self.saveCardForTapCollectionFields = saveCardForTapCollectionFields
    }
}

// MARK: - Decodable
extension TapPaymentOptionsReponseModel: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier                      = try container.decode(String.self, forKey: .identifier)
        let object                          = try container.decode(String.self, forKey: .object)
        var paymentOptions                  = try container.decode([PaymentOption].self, forKey: .paymentOptions)
        let currency                        = try container.decode(TapCurrencyCode.self, forKey: .currency)
        let supportedCurrenciesAmounts      = try container.decode([AmountedCurrency].self, forKey: .supportedCurrenciesAmounts)
        var savedCards                      = try container.decodeIfPresent([SavedCard].self, forKey: .savedCards)
        let merchantCountryCode             = try container.decodeIfPresent(String.self, forKey: .merchantCountryCode)
        let order                           = try container.decodeIfPresent(Order.self, forKey: .order)
        
        
        paymentOptions = paymentOptions.sorted(by: { $0.orderBy < $1.orderBy })
        
        for i in 0...paymentOptions.count-1 {
            if paymentOptions[i].brand == .unknown {
                if paymentOptions[i].paymentType == .Web {
                    paymentOptions[i].brand = CardBrand.aiywaLoyalty
                }
            }
        }
        
        paymentOptions = paymentOptions.filter { ($0.brand != .unknown || $0.paymentType == .ApplePay) }
        paymentOptions = paymentOptions.sorted(by: { $0.orderBy < $1.orderBy })
        
        // Filter saved cards based on allowed card types passed by the user when loading the SDK session
        let merchnantAllowedCards = SharedCommongDataModels.sharedCommongDataModels.allowedCardTypes
        savedCards = savedCards?.filter { (merchnantAllowedCards.contains($0.cardType ?? CardType(cardType: .All))) }
        
        self.init(identifier:                   identifier,
                  object:                       object,
                  paymentOptions:               paymentOptions,
                  currency:                     currency,
                  supportedCurrenciesAmounts:   supportedCurrenciesAmounts,
                  savedCards:                   savedCards,
                  merchantCountryCode:          merchantCountryCode,
                  order:                        order,
                  loyalty:                      .init(id: "", bankName: "ADCB", bankLogo: "https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/78/00/ed/7800edd0-5854-b6ce-458f-dfcf75caa495/AppIcon-0-0-1x_U007emarketing-0-0-0-5-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/1024x1024.jpg", loyaltyProgramName: "ADCB TouchPoints", loyaltyPointsName: "TouchPoints", termsConditionsLink: "https://www.adcb.com/en/personal/adcb-for-you/touchpoints/touchpoints-rewards.aspx", supportedCurrencies: [.init(currency: AmountedCurrency.init(.AED, 1000, "", 2, 50), balanceAmount: 1000, minimumAmount: 100),.init(currency: AmountedCurrency.init(.EGP, 5000, "", 2, 10), balanceAmount: 5000, minimumAmount: 500)], transactionsCount: "50.000"),
                  saveCardForTapCollectionFields: .init(contactDetails: [.email,.phone], shippingDetails: [.flat,.additionalLine,.city,.country]))
    }
}

/// Responsible for helpers method to access data inside the model
extension TapPaymentOptionsReponseModel {
    
    /**
     Gets a specific payment option by id
     - Parameter with: The id of the needed payment option
     - Returns: Payment option if found with the specified id, else nil
     */
    public func fetchPaymentOption(with id:String) -> PaymentOption? {
        var requiredPaymentOption:PaymentOption?
        
        // Let us get the needed payment option if any
        let filteredPaymentOptions:[PaymentOption] = paymentOptions.filter{ $0.identifier == id }
        // Make sure at least one option met the requirement
        guard !filteredPaymentOptions.isEmpty else { return requiredPaymentOption }
        // That is it..
        requiredPaymentOption = filteredPaymentOptions.first
        
        return requiredPaymentOption
    }
}
