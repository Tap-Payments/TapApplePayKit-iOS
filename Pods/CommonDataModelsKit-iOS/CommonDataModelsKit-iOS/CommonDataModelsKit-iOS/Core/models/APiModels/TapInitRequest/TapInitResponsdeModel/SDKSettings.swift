//
//  TapInitResponseModel.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 6/14/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
/// goSell SDK Settings model.
public struct SDKSettings {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Payments mode.
    internal let isLiveMode: Bool?
    
    /// Permissions.
    public let permissions: Permissions?
    
    /// Encryption key.
    public let encryptionKey: String?
    
    /// Unique device ID.
    // FIXME: Remove optionality here once backend is ready.
    internal let deviceID: String?
    
    /// Merchant information.
    public let merchant: Merchant?
    
    /// Internal SDK settings.
    internal let internalSettings: InternalSDKSettings?
    
    /// Session token.
    public private(set) var sessionToken: String?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case isLiveMode             = "live_mode"
        case permissions            = "permissions"
        case merchantLogo           = "logo"
        case merchantName           = "name"
        case merchantCountry        = "country_code"
        case encryptionKey          = "encryption_key"
        case deviceID               = "device_id"
        case merchant               = "merchant"
        case internalSettings       = "sdk_settings"
        case sessionToken           = "session_token"
    }
}

// MARK: - Decodable
extension SDKSettings: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isLiveMode              = try container.decode(Bool.self,                   forKey: .isLiveMode)
        let encryptionKey           = try container.decode(String.self,                 forKey: .encryptionKey)
        let merchantName            = try container.decode(String.self,                 forKey: .merchantName)
        let merchantLogo            = try container.decode(String.self,                 forKey: .merchantLogo)
        let merchantCountry         = try container.decode(String.self,                 forKey: .merchantCountry)
        let merchant                = Merchant(logoURL: merchantLogo, name: merchantName, countryCode: merchantCountry)
        let internalSettings        = try container.decode(InternalSDKSettings.self,    forKey: .internalSettings)
        
        let permissions             = try container.decodeIfPresent(Permissions.self,   forKey: .permissions) ?? .tap_none
        let deviceID                = try container.decodeIfPresent(String.self,        forKey: .deviceID)
        let sessionToken            = try container.decodeIfPresent(String.self,        forKey: .sessionToken)
        
        
        if encryptionKey == "" {
            throw "TAP SDK ERROR : Empty Encryption Key"
        }
        
        SharedCommongDataModels.sharedCommongDataModels.encryptionKey = encryptionKey
        
        self.init(isLiveMode:           isLiveMode,
                  permissions:          permissions,
                  encryptionKey:        encryptionKey,
                  deviceID:             deviceID,
                  merchant:             merchant,
                  internalSettings:     internalSettings,
                  sessionToken:         sessionToken)
    }
}


/// goSell SDK settings data model.
public struct TapInitResponseModel:Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Data.
    public var data: SDKSettings
    /// Payment options.
    public var paymentOptions: TapPaymentOptionsReponseModel
    /// session token.
    public var session: String
    /// The model for fetching the default assets urls for themes and localisations
    public var assets: TapAssetsModel
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case data               = "merchant"
        case paymentOptions     = "payment_options"
        case session            = "session"
        case assets             = "assests"
    }
}

/// The model for fetching the default assets urls for themes and localisations
public struct TapAssetsModel:Codable {
    
    /// The theme model
    public let theme:TapThemeAssetsModel
    
    /// The loclisation model
    public let localisation:TapLocalisationAssetsModel
    
}

/// The model for fetching the default assets urls for the light and dark themes
public struct TapThemeAssetsModel:Codable {
    
    /// The light mode theme url
    public let light:String
    
    /// The dark mode theme url
    public let dark:String
    
    /// A path to the mobile only theme, helps in reducing the KB loaded. The default url contents has themes for mobile & web
    public var lighMobileOnly:String {
        var mutatingLight = light
        return mutatingLight.tap_replaceFirstOccurrence(of: "TapThemeMobile", with: "TapThemeMobileOnly")
    }
    
    /// A path to the mobile only theme, helps in reducing the KB loaded. The default url contents has themes for mobile & web
    public var darkMobileOnly:String {
        var mutatingDark = dark
        return mutatingDark.tap_replaceFirstOccurrence(of: "TapThemeMobile", with: "TapThemeMobileOnly")
    }
    
    /// The card theme model
    public var card:TapCardThemeAssetsModel?
    
}


/// The model for fetching the default assets urls for the localisations
public struct TapLocalisationAssetsModel:Codable {
    /// The localisation url
    public let url:String
    /// The card loclisation model
    public let card:TapCardLocalisationAssetsModel?
}



/// The model for fetching the default assets urls for the light and dark themes
public struct TapCardThemeAssetsModel:Codable {
    
    /// The light mode theme url
    public let light:String
    
    /// The dark mode theme url
    public let dark:String
    
}


/// The model for fetching the default assets urls for the localisations
public struct TapCardLocalisationAssetsModel:Codable {
    /// The localisation url
    public let url:String
}
