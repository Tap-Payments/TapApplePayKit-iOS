//
//  PaymentOption.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 6/15/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
import struct PassKit.PKPaymentNetwork
import TapCardVlidatorKit_iOS
/// Payment Option model.
public struct PaymentOption: IdentifiableWithString {
    
    public init(identifier: String, brand: CardBrand, title: String,  titleAr: String, displayableTitle:String? = nil, backendImageURL: URL, isAsync: Bool, paymentType: TapPaymentType, sourceIdentifier: String? = nil, supportedCardBrands: [CardBrand], supportedCurrencies: [TapCurrencyCode], orderBy: Int, threeDLevel: ThreeDSecurityState, savedCard: SavedCard? = nil, extraFees: [ExtraFee] = [], paymentOptionsLogos:PaymentOptionLogos? = nil, buttonStyle: PaymentOptionButtonStyle? = nil) {
        self.identifier = identifier
        self.brand = brand
        self.title = title
        self.titleAr = titleAr
        self.displayableTitle = displayableTitle ?? title
        self.backendImageURL = backendImageURL
        self.isAsync = isAsync
        self.paymentType = paymentType
        self.sourceIdentifier = sourceIdentifier
        self.supportedCardBrands = supportedCardBrands
        self.supportedCurrencies = supportedCurrencies
        self.orderBy = orderBy
        self.threeDLevel = threeDLevel
        self.savedCard = savedCard
        self.extraFees = extraFees
        self.paymentOptionsLogos = paymentOptionsLogos
        self.buttonStyle = buttonStyle
    }
    
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Unique identifier for the object.
    public let identifier: String
    
    /// Payment option card brand.
    public var brand: CardBrand
    
    /// Name of the payment option.
    public var title: String
    
    /// Arabic name of the payment option.
    public var titleAr: String
    
    /// The title to be displayed inside the currency widget
    public var displayableTitle: String
    
    /// Image URL of the payment option.
    public let backendImageURL: URL
    
    /// If the payment option is async or not
    public let isAsync: Bool
    
    /// Payment type.
    public var paymentType: TapPaymentType
    
    /// Source identifier.
    public private(set) var sourceIdentifier: String?
    
    /// Supported card brands.
    public let supportedCardBrands: [CardBrand]
    
    
    /// List of supported currencies.
    public let supportedCurrencies: [TapCurrencyCode]
    
    /// Ordering parameter.
    public let orderBy: Int
    
    /// Decide if the 3ds should be disabled, enabled or set by user for this payment option
    public let threeDLevel: ThreeDSecurityState
    
    /// Will hold the related saved card if the user selected saved card to pay with
    public var savedCard:SavedCard? = nil
    
    /// Will hold the related extra fees in case of saved card payment
    public var extraFees:[ExtraFee] = []
    
    /// Will hold the list of urls to support different themes for the icons
    public let paymentOptionsLogos:PaymentOptionLogos?
    
    /// Will hold the ui to be displayed in the action button if any
    public var buttonStyle:PaymentOptionButtonStyle?
    
    
    /// Will do the correct fetching of which display name to use according to language selected
    /// - Parameter lang: Indicates whether to show arabic text or english text
    public func displayableTitle(for lang:String) -> String {
        switch lang.lowercased() {
        case "ar": return titleAr
        default  : return title
        }
    }
    
    /// Will do the correct fetching of which image to use, the default backend url or the correct light-dark cdn hosted url
    /// - Parameter showMonoForLightMode: Indicates whether to show the light or the light mono
    /// - Parameter showColoredForDarkMode: Indicates whether to show the dark or the dark colored
    public func correctBackEndImageURL(showMonoForLightMode:Bool = false, showColoredForDarkMode:Bool) -> URL {
        // Check if we have right values passed in the cdn logos options
        guard let logos = paymentOptionsLogos,
              let lightModePNGString = logos.light?.png,
              let darkModePNGString  = logos.dark?.png,
              let lightMonoModePNGString = logos.lightMono?.png,
              let darkColoredModePNGString = logos.darkColored?.png,
              let lightModePNGUrl    = URL(string: lightModePNGString),
              let darkModePNGUrl     = URL(string: darkModePNGString),
              let lightMonoModePNGUrl    = URL(string: lightMonoModePNGString),
              let darkColoredModePNGUrl     = URL(string: darkColoredModePNGString) else { return backendImageURL }
        
        
        // we will return based on the theme
        if #available(iOS 12.0, *) {
            return UIScreen.main.traitCollection.userInterfaceStyle == .light ? showMonoForLightMode ? lightMonoModePNGUrl : lightModePNGUrl : showColoredForDarkMode ? darkColoredModePNGUrl : darkModePNGUrl
        } else {
            // Fallback on earlier versions
            return lightModePNGUrl
        }
        
    }
    
    
    /// Will do the correct fetching of which disabled image to use, the default backend url or the correct light-dark cdn hosted url
    /// - Parameter showMonoForLightMode: Indicates whether to show the light or the light mono
    /// - Parameter showColoredForDarkMode: Indicates whether to show the dark or the dark colored
    public func correctDisabledImageURL(showMonoForLightMode:Bool = false, showColoredForDarkMode:Bool) -> URL {
        // Check if we have right values passed in the cdn logos options
        guard let logos = paymentOptionsLogos,
              let lightModePNGString = logos.light?.disabled?.png,
              let darkModePNGString  = logos.dark?.disabled?.png,
              let lightMonoModePNGString = logos.lightMono?.disabled?.png,
              let darkColoredModePNGString = logos.darkColored?.disabled?.png,
              let lightModePNGUrl    = URL(string: lightModePNGString),
              let darkModePNGUrl     = URL(string: darkModePNGString),
              let lightMonoModePNGUrl    = URL(string: lightMonoModePNGString),
              let darkColoredModePNGUrl     = URL(string: darkColoredModePNGString) else { return backendImageURL }  // TODO:- need url for disabled also to fallback
        
        
        // we will return based on the theme
        if #available(iOS 12.0, *) {
            return UIScreen.main.traitCollection.userInterfaceStyle == .light ? showMonoForLightMode ? lightMonoModePNGUrl : lightModePNGUrl : showColoredForDarkMode ? darkColoredModePNGUrl : darkModePNGUrl
        } else {
            // Fallback on earlier versions
            return lightModePNGUrl
        }
        
        
    }
    
    /// Will do the correct fetching of which currency widget image to use, the default backend url or the correct light-dark cdn hosted url
    /// - Parameter showMonoForLightMode: Indicates whether to show the light or the light mono
    /// - Parameter showColoredForDarkMode: Indicates whether to show the dark or the dark colored
    public func correctCurrencyWidgetImageURL(showMonoForLightMode:Bool = false, showColoredForDarkMode:Bool) -> URL {
        // Check if we have right values passed in the cdn logos options
        guard let logos = paymentOptionsLogos,
              let lightModePNGString = logos.light?.currencyWidget?.png,
              let darkModePNGString  = logos.dark?.currencyWidget?.png,
              let lightMonoModePNGString = logos.lightMono?.currencyWidget?.png,
              let darkColoredModePNGString = logos.darkColored?.currencyWidget?.png,
              let lightModePNGUrl    = URL(string: lightModePNGString),
              let darkModePNGUrl     = URL(string: darkModePNGString),
              let lightMonoModePNGUrl    = URL(string: lightMonoModePNGString),
              let darkColoredModePNGUrl     = URL(string: darkColoredModePNGString) else { return backendImageURL }  // TODO:- need url for currency Widget also to fallback
        
        
        // we will return based on the theme
        if #available(iOS 12.0, *) {
            return UIScreen.main.traitCollection.userInterfaceStyle == .light ? showMonoForLightMode ? lightMonoModePNGUrl : lightModePNGUrl : showColoredForDarkMode ? darkColoredModePNGUrl : darkModePNGUrl
        } else {
            // Fallback on earlier versions
            return lightModePNGUrl
        }
        
        
    }
    
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier             = "id"
        case title                  = "name"
        case titleAr                = "name_ar"
        case backendImageURL        = "image"
        case paymentType            = "payment_type"
        case sourceIdentifier       = "source_id"
        case supportedCardBrands    = "supported_card_brands"
        case supportedCurrencies    = "supported_currencies"
        case orderBy                = "order_by"
        case isAsync                = "asynchronous"
        case threeDLevel            = "threeDS"
        case paymentoptionsLogos    = "logos"
        case buttonStyle            = "button_style"
        case displayableTitle       = "display_name"
    }
    
    private static func mapThreeDLevel(with threeD:String) -> ThreeDSecurityState
    {
        if threeD.lowercased() == "n"
        {
            return .never
        }else if threeD.lowercased() == "y"
        {
            return .always
        }else
        {
            return .definedByMerchant
        }
    }
    
    /// Converts the payment option from Tap format to the acceptable format by Apple pay kit
    public func applePayNetworkMapper() -> [PKPaymentNetwork]
    {
        var applePayMappednNetworks:[PKPaymentNetwork] = []
        
        // Check if the original brand is in the supported, otherwise add it to the list we need to search
        var toBeCheckedCardBrands:[CardBrand] = supportedCardBrands
        
        if !toBeCheckedCardBrands.contains(brand)
        {
            toBeCheckedCardBrands.insert(brand, at: 0)
        }
        for cardBrand:CardBrand in toBeCheckedCardBrands
        {
            if cardBrand == .visa
            {
                applePayMappednNetworks.append(PKPaymentNetwork.visa)
            }else if cardBrand == .masterCard
            {
                applePayMappednNetworks.append(PKPaymentNetwork.masterCard)
            }else if cardBrand == .americanExpress
            {
                applePayMappednNetworks.append(PKPaymentNetwork.amex)
            }else if cardBrand == .maestro
            {
                if #available(iOS 12.0, *) {
                    applePayMappednNetworks.append(PKPaymentNetwork.maestro)
                }
            }else if cardBrand == .visaElectron
            {
                if #available(iOS 12.0, *) {
                    applePayMappednNetworks.append(PKPaymentNetwork.electron)
                }
            }else if cardBrand == .mada
            {
                if #available(iOS 12.1.1, *) {
                    applePayMappednNetworks.append(PKPaymentNetwork.mada)
                }
            }
        }
        
        return applePayMappednNetworks.removingDuplicates()
    }
    
    /// Creates a copy of self by deleting the provided currencies
    /// - Parameter without currencies: The list of currencies you want to remove from the supported currencies
    /// - Returns: The same payment option with the supported currencies doesn't have the ones needed to be deleted
    public func copyPaymentOption(without currencies:[TapCurrencyCode]) -> PaymentOption {
        // Remove the selected currency from payment option list
        var updatedSupportedCurrencies = supportedCurrencies
        updatedSupportedCurrencies.removeAll {
            currencies.contains($0)
        }
        
        let updatedPaymentOption = PaymentOption(identifier: identifier,
                                                 brand: brand,
                                                 title: title,
                                                 titleAr: titleAr,
                                                 displayableTitle: displayableTitle,
                                                 backendImageURL: backendImageURL,
                                                 isAsync: isAsync,
                                                 paymentType: paymentType,
                                                 sourceIdentifier: sourceIdentifier,
                                                 supportedCardBrands: supportedCardBrands,
                                                 supportedCurrencies: updatedSupportedCurrencies,
                                                 orderBy: orderBy,
                                                 threeDLevel: threeDLevel,
                                                 savedCard: savedCard,
                                                 extraFees: extraFees,
                                                 paymentOptionsLogos:paymentOptionsLogos,
                                                 buttonStyle: buttonStyle)
        return updatedPaymentOption
    }
}

// MARK: - Decodable
extension PaymentOption: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container           = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier          = try container.decode          (String.self,                   forKey: .identifier)
        let brand               = try container.decode          (CardBrand.self,                forKey: .title)
        let title               = try container.decode          (String.self,                   forKey: .title)
        let titleAr             = try container.decode          (String.self,                   forKey: .titleAr)
        let displayableTitle    = try container.decodeIfPresent (String.self,                   forKey: .displayableTitle) ?? title
        let imageURL            = try container.decode          (URL.self,                      forKey: .backendImageURL)
        let paymentType         = try container.decode          (TapPaymentType.self,           forKey: .paymentType)
        let sourceIdentifier    = try container.decodeIfPresent (String.self,                   forKey: .sourceIdentifier)
        var supportedCardBrands = try container.decode          ([CardBrand].self,              forKey: .supportedCardBrands)
        let supportedCurrencies = try container.decode          ([TapCurrencyCode].self,        forKey: .supportedCurrencies)
        let orderBy             = try container.decode          (Int.self,                      forKey: .orderBy)
        let isAsync             = try container.decode          (Bool.self,                     forKey: .isAsync)
        let threeDLevel         = try container.decodeIfPresent (String.self,                   forKey: .threeDLevel) ?? "U"
        let paymentOptionsLogos = try container.decodeIfPresent (PaymentOptionLogos.self,       forKey: .paymentoptionsLogos)
        let buttonStyle         = try container.decodeIfPresent (PaymentOptionButtonStyle.self, forKey: .buttonStyle)
        
        supportedCardBrands = supportedCardBrands.filter { $0 != .unknown }
        
        self.init(identifier: identifier,
                  brand: brand,
                  title: title,
                  titleAr: titleAr,
                  displayableTitle: displayableTitle,
                  backendImageURL: imageURL,
                  isAsync: isAsync, paymentType: paymentType,
                  sourceIdentifier: sourceIdentifier,
                  supportedCardBrands: supportedCardBrands,
                  supportedCurrencies: supportedCurrencies,
                  orderBy: orderBy,
                  threeDLevel: PaymentOption.mapThreeDLevel(with: threeDLevel),
                  paymentOptionsLogos: paymentOptionsLogos,
                  buttonStyle: buttonStyle)
    }
}
// MARK: - ThreeDSecurityState enum to provide different levels of 3ds transaction
public enum ThreeDSecurityState {
    /// This means all transactions will pass through 3ds
    case always
    /// This means no transactions will pass through 3ds
    case never
    /// This means it depends on the merchant's configuration passed when starting the checkout
    case definedByMerchant
}

// MARK: - FilterableByCurrency
extension PaymentOption: FilterableByCurrency {}

// MARK: - SortableByOrder
extension PaymentOption: SortableByOrder {}

// MARK: - Equatable
extension PaymentOption: Equatable {
    
    /// Checks if 2 objects are equal.
    ///
    /// - Parameters:
    ///   - lhs: First object.
    ///   - rhs: Second object.
    /// - Returns: `true` if 2 objects are equal, `false` otherwise.
    public static func == (lhs: PaymentOption, rhs: PaymentOption) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
}

/// Payment Option Logo model.
public struct PaymentOptionLogo: Codable {
    /// The SVG url
    public let svg: String?
    /// The PNG url
    public let png: String?
    /// The disabled logo
    public let disabled: PaymentOptionExtraLogo?
    /// The currency_widget logo
    public let currencyWidget: PaymentOptionExtraLogo?
    
    // MARK: - Private -
    
    private enum CodingKeys : String, CodingKey {
        case svg, currencyWidget = "currency_widget", png, disabled
    }
}

///// Payment Option extra Logos model.
public struct PaymentOptionExtraLogo: Codable {
    /// The SVG url
    public let svg: String?
    /// The PNG url
    public let png:String?
}


/// Payment Option Logos model.
public struct PaymentOptionLogos: Codable {
    /// The light icons urls
    public let light: PaymentOptionLogo?
    /// The dark icons urls
    public let dark: PaymentOptionLogo?
    /// The light_mono icons urls
    public let lightMono: PaymentOptionLogo?
    /// dark_colored icons urls
    public let darkColored: PaymentOptionLogo?
    
    
    // MARK: - Private -
    
    private enum CodingKeys : String, CodingKey {
        case light, lightMono = "light_mono", dark, darkColored = "dark_colored"
    }
}
