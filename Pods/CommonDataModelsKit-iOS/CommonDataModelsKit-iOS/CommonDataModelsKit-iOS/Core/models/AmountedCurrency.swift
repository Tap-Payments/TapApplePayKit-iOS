//
//  AmountedCurrency.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//
import UIKit
/// Structure holding currency and the amount.
@objc public class AmountedCurrency: NSObject,Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Currency.
    public var currency: TapCurrencyCode
    
    /// The decimal digits.
    public var decimalDigits: Int
    
    /// Amount.
    public var amount: Double
    
    /// Currency symbol.
    public var currencySymbol: String
    
    /// Currency flag icon url.
    public var flag: String
    
    /// Will hold the list of urls to support different themes for the icons
    public var currencyLogos:CurrencyLogos? = nil
    
    
    /// Will do the correct fetching of which image to use, the default backend url or the correct light-dark cdn hosted url
    /// - Parameter showMonoForLightMode: Indicates whether to show the light or the light colored
    public func correctBackEndImageURL(showMonoForLightMode:Bool = false) -> URL {
        // Check if we have right values passed in the cdn logos options
        guard let logos = currencyLogos,
              let lightModePNGString = logos.light?.png,
              let darkModePNGString  = logos.dark?.png,
              let lightModePNGUrl    = URL(string: lightModePNGString),
              let darkModePNGUrl     = URL(string: darkModePNGString) else { return URL(string: flag) ?? URL(string: "")! }
        
        
        // we will return based on the theme
        if #available(iOS 12.0, *) {
            if UIScreen.main.traitCollection.userInterfaceStyle == .light {
                if showMonoForLightMode {
                    guard let lightMonoModePNGString = logos.light_colored?.png,
                          let lightMonoModePNGUrl    = URL(string: lightMonoModePNGString) else { return lightModePNGUrl }
                    return lightMonoModePNGUrl
                }
                return lightModePNGUrl
            } else {
                return darkModePNGUrl
            }
        } else {
            // Fallback on earlier versions
            return lightModePNGUrl
        }
        
    }
    
    /// Conversion factor to transaction currency from baclend
    public var rate: Double?
    
    /// Computes the displayble symbol. If backend provides a Symbol we use it, otherwise we use the provided currency code
    public var displaybaleSymbol:String {
        return currencySymbol
        //return currencySymbol.count == 1 ? currencySymbol : currency.appleRawValue
    }
    // MARK: Methods
    
    @objc public convenience init(_ currency: TapCurrencyCode, _ amount: Double, _ flag: String, _ decimalDigits: Int = 2, _ rate: Double = 1, currencyLogos:CurrencyLogos? = nil) {
        self.init(currency, amount, currency.symbolRawValue, flag, decimalDigits, rate, currencyLogos: currencyLogos)
    }
    
    @objc public init(_ currency: TapCurrencyCode, _ amount: Double, _ currencySymbol: String, _ flag: String, _ decimalDigits: Int = 2, _ rate: Double = 1, currencyLogos:CurrencyLogos? = nil) {
        
        self.currency       = currency
        self.amount         = amount
        self.currencySymbol = currencySymbol
        self.flag           = flag
        self.decimalDigits  = decimalDigits
        self.rate           = rate
        self.currencyLogos  = currencyLogos
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case currency       = "currency"
        case amount         = "amount"
        case currencySymbol = "symbol"
        case rate           = "rate"
        case flag           = "flag"
        case currencyLogos  = "logos"
        case decimalDigits  = "decimal_digit"
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        return currency.appleRawValue == (object as? AmountedCurrency)?.currency.appleRawValue
    }
}


/// Currency Logo model.
@objc public class CurrencyLogo: NSObject, Codable {
    /// The SVG url
    public let svg: String?
    /// The PNG url
    public let png:String?
}




/// Currency Logos model.
@objc public class CurrencyLogos: NSObject, Codable {
    /// The light icons urls
    public let light: CurrencyLogo?
    /// The dark icons urls
    public let dark: CurrencyLogo?
    /// The light_colored icons urls
    public let light_colored: CurrencyLogo?
}
