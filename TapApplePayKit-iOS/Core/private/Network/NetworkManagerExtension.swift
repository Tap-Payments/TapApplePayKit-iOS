//
//  NetworkManagerExtensions.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 6/14/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
import CoreTelephony
import TapApplicationV2
import CommonDataModelsKit_iOS

/// Extension to the network manager when needed. To keep the network manager class itself clean and readable
internal extension NetworkManager {
    
    
    static var headersEncryptionPublicKey:String {
        if TapApplePay.sdkMode == .sandbox {
            return """
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8AX++RtxPZFtns4XzXFlDIxPB
h0umN4qRXZaKDIlb6a3MknaB7psJWmf2l+e4Cfh9b5tey/+rZqpQ065eXTZfGCAu
BLt+fYLQBhLfjRpk8S6hlIzc1Kdjg65uqzMwcTd0p7I4KLwHk1I0oXzuEu53fU1L
SZhWp4Mnd6wjVgXAsQIDAQAB
-----END PUBLIC KEY-----
"""
        }else{
            return  """
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC9hSRms7Ir1HmzdZxGXFYgmpi3
ez7VBFje0f8wwrxYS9oVoBtN4iAt0DOs3DbeuqtueI31wtpFVUMGg8W7R0SbtkZd
GzszQNqt/wyqxpDC9q+97XdXwkWQFA72s76ud7eMXQlsWKsvgwhY+Ywzt0KlpNC3
Hj+N6UWFOYK98Xi+sQIDAQAB
-----END PUBLIC KEY-----
"""
        }
    }
    
    /// Static HTTP headers sent with each request. including device info, language and SDK secret keys
    static var staticHTTPHeaders: [String: String] {
        
        let secretKey = NetworkManager.secretKey()
        
        guard secretKey.tap_length > 0 else {
            
            fatalError("Secret key must be set in order to use goSellSDK.")
        }
        
        let applicationValue = applicationHeaderValue
        
        var result = [
            
            Constants.HTTPHeaderKey.authorization: "\(secretKey)",
            Constants.HTTPHeaderKey.application: applicationValue,
            Constants.HTTPHeaderKey.contentTypeHeaderName: Constants.HTTPHeaderValueKey.jsonContentTypeHeaderValue,
            Constants.HTTPHeaderKey.mdn: Crypter.encrypt(TapApplicationPlistInfo.shared.bundleIdentifier ?? "", using: NetworkManager.headersEncryptionPublicKey) ?? ""
        ]
        
        /*if let sessionToken = TapCheckout.sharedCheckoutManager().dataHolder.transactionData.intitModelResponse?.data.sessionToken, !sessionToken.isEmpty {
            
            result[Constants.HTTPHeaderKey.sessionToken] = sessionToken
        }*/
        
        if let middleWareToken = TapApplePay.intitModelResponse?.session {
            
            result[Constants.HTTPHeaderKey.token] = "\(middleWareToken)"
        }
        
        return result
    }
    
    /// HTTP headers that contains the device and app info
    static private var applicationHeaderValue: String {
        
        var applicationDetails = NetworkManager.applicationStaticDetails()
        
        let localeIdentifier = "en"
        
        applicationDetails[Constants.HTTPHeaderValueKey.appLocale] = localeIdentifier
        
        if let deviceID = KeychainManager.deviceID {
            
            applicationDetails[Constants.HTTPHeaderValueKey.deviceID] = deviceID
        }
        
        let result = (applicationDetails.map { "\($0.key)=\($0.value)" }).joined(separator: "|")
        
        return result
    }
    
    /**
     Used to fetch the correct secret key based on the selected SDK mode
     - Returns: The sandbox or production secret key based on the SDK mode
     */
    static func secretKey() -> String {
        return (TapApplePay.sdkMode == .sandbox) ? TapApplePay.secretKey.sandbox : TapApplePay.secretKey.production
    }
    
    
    /// A computed variable that generates at access time the required static headers by the server.
    static private func applicationStaticDetails() -> [String: String] {
        
        /*guard let bundleID = TapApplicationPlistInfo.shared.bundleIdentifier, !bundleID.isEmpty else {
         
         fatalError("Application must have bundle identifier in order to use goSellSDK.")
         }*/
        
        let bundleID = TapApplicationPlistInfo.shared.bundleIdentifier ?? ""
        
        let sdkPlistInfo = TapBundlePlistInfo(bundle: Bundle(for: TapApplePay.self))
        
        guard let requirerVersion = sdkPlistInfo.shortVersionString, !requirerVersion.isEmpty else {
            
            fatalError("Seems like SDK is not integrated well.")
        }
        let networkInfo = CTTelephonyNetworkInfo()
        let providers = networkInfo.serviceSubscriberCellularProviders
        
        let osName = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
        let deviceName = UIDevice.current.name
        let deviceNameFiltered =  deviceName.tap_byRemovingAllCharactersExcept("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789")
        let deviceType = UIDevice.current.model
        let deviceModel = UIDevice.current.localizedModel
        var simNetWorkName:String? = ""
        var simCountryISO:String? = ""
        
        if providers?.values.count ?? 0 > 0, let carrier:CTCarrier = providers?.values.first {
            simNetWorkName = carrier.carrierName
            simCountryISO = carrier.isoCountryCode
        }
        
        
        let result: [String: String] = [
            Constants.HTTPHeaderValueKey.appID: Crypter.encrypt(bundleID, using: NetworkManager.headersEncryptionPublicKey) ?? "",
            Constants.HTTPHeaderValueKey.requirer: Crypter.encrypt(Constants.HTTPHeaderValueKey.requirerValue, using: NetworkManager.headersEncryptionPublicKey) ?? "",
            Constants.HTTPHeaderValueKey.requirerVersion: Crypter.encrypt(requirerVersion, using: NetworkManager.headersEncryptionPublicKey) ?? "",
            Constants.HTTPHeaderValueKey.requirerOS: Crypter.encrypt(osName, using: NetworkManager.headersEncryptionPublicKey) ?? "",
            Constants.HTTPHeaderValueKey.requirerOSVersion: Crypter.encrypt(osVersion, using: NetworkManager.headersEncryptionPublicKey) ?? "",
            Constants.HTTPHeaderValueKey.requirerDeviceName: Crypter.encrypt(deviceNameFiltered, using: NetworkManager.headersEncryptionPublicKey) ?? "",
            Constants.HTTPHeaderValueKey.requirerDeviceType: Crypter.encrypt(deviceType, using: NetworkManager.headersEncryptionPublicKey) ?? "",
            Constants.HTTPHeaderValueKey.requirerDeviceModel: Crypter.encrypt(deviceModel, using: NetworkManager.headersEncryptionPublicKey) ?? "",
            Constants.HTTPHeaderValueKey.requirerSimNetworkName: Crypter.encrypt(simNetWorkName ?? "", using: NetworkManager.headersEncryptionPublicKey) ?? "",
            Constants.HTTPHeaderValueKey.requirerSimCountryIso: Crypter.encrypt(simCountryISO ?? "", using: NetworkManager.headersEncryptionPublicKey) ?? ""
        ]
        
        return result
    }
    
    
    
    struct Constants {
        
        internal static let authenticateParameter = "authenticate"
        
        fileprivate static let timeoutInterval: TimeInterval            = 60.0
        fileprivate static let cachePolicy:     URLRequest.CachePolicy  = .reloadIgnoringCacheData
        
        fileprivate static let successStatusCodes = 200...299
        
        fileprivate struct HTTPHeaderKey {
            
            fileprivate static let authorization            = "Authorization"
            fileprivate static let application              = "application"
            fileprivate static let sessionToken             = "session_token"
            fileprivate static let contentTypeHeaderName    = "Content-Type"
            fileprivate static let token                    = "session"
            fileprivate static let mdn                      = "mdn"
            
            //@available(*, unavailable) private init() { }
        }
        
        fileprivate struct HTTPHeaderValueKey {
            
            fileprivate static let appID                    = "cu"
            fileprivate static let appLocale                = "al"
            fileprivate static let appType                  = "at"
            fileprivate static let deviceID                 = "device_id"
            fileprivate static let requirer                 = "aid"
            fileprivate static let requirerOS               = "ro"
            fileprivate static let requirerOSVersion        = "rov"
            fileprivate static let requirerValue            = "iOS-checkout-sdk"
            fileprivate static let requirerVersion          = "av"
            fileprivate static let requirerDeviceName       = "rn"
            fileprivate static let requirerDeviceType       = "rt"
            fileprivate static let requirerDeviceModel      = "rm"
            fileprivate static let requirerSimNetworkName   = "rsn"
            fileprivate static let requirerSimCountryIso    = "rsc"
            
            fileprivate static let jsonContentTypeHeaderValue   = "application/json"
            
            //@available(*, unavailable) private init() { }
        }
    }
}
