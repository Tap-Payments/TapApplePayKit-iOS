//
//  TapLoyaltyModel.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 13/09/2022.
//

import Foundation

/// Tap loyalty model.
public struct TapLoyaltyModel : Codable {
    
    /**
     Tap loyalty model.
     - Parameter id: The id of teh loyalty programe
     - Parameter bankName: The bank identifier to match it with the bin response
     - Parameter bankLogo: The icon of the loyalty program owner
     - Parameter loyaltyProgramName: The name of the loyalty programe to be used in the header title
     - Parameter loyaltyPointsName: The name of the used shceme (ADCB Points, Fawry Values, etc.)
     - Parameter termsConditionsLink: A link to open the T&C of the loyalty scheme
     - Parameter supportedCurrencies: The list of supported currencies each with the conversion rate
     - Parameter transactionsCount: The total number of availle points
     */
    
    public init(id: String?, bankName: String? = nil , bankLogo: String? = nil , loyaltyProgramName: String? = nil , loyaltyPointsName: String? = nil , termsConditionsLink: String? = nil, supportedCurrencies: [LoyaltySupportedCurrency]? = nil, transactionsCount: String? = nil) {
        self.id = id
        self.bankName = bankName
        self.bankLogo = bankLogo
        self.loyaltyProgramName = loyaltyProgramName
        self.loyaltyPointsName = loyaltyPointsName
        self.termsConditionsLink = termsConditionsLink
        self.supportedCurrencies = supportedCurrencies
        self.transactionsCount = transactionsCount
    }
    
    /// The id of teh loyalty programe
    public let id :String?
    /// The bank identifier to match it with the bin response
    public let bankName: String?
    /// The icon of the loyalty program owner
    public let bankLogo: String?
    /// The name of the loyalty programe to be used in the header title
    public let loyaltyProgramName: String?
    /// The name of the used shceme (ADCB Points, Fawry Values, etc.)
    public let loyaltyPointsName: String?
    /// A link to open the T&C of the loyalty scheme
    public let termsConditionsLink: String?
    /// The list of supported currencies each with the conversion rate
    public let supportedCurrencies: [LoyaltySupportedCurrency]?
    /// The total number of availle points as a string formatted as it comes from backend
    public let transactionsCount: String?
    /// The total number of availle points in a numeric format for numbers processing
    public var numericTransactionCount: Int {
        return Int(transactionsCount?.filter("0123456789".contains) ?? "0") ?? 0
    }
}

// MARK: Welcome convenience initializers and mutators

public extension TapLoyaltyModel {
    ///Tap loyalty model. from given Data
    /// - Parameter data: The data to decode it into the model
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TapLoyaltyModel.self, from: data)
    }
    
    ///Tap loyalty model. from given json string
    /// - Parameter string: The string  json to decode it into the modelParameter data: The data to decode it into the model
    /// - Parameter encoding: The encoding method. Default is UTF8
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    ///Tap loyalty model. from data/json in a given URL
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    /// Encodes the model into Data
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    
    /// Encodes the model into pretty formatted JSON string
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - SupportedCurrency
/// The model of the loyalty supported currencies. Each one will have the the rating + the currency itself
public struct LoyaltySupportedCurrency: Codable {
    
    /**
     The model of the loyalty supported currencies. Each one will have the the rating + the currency itself
     - Parameter currency: The currency itself
     - Parameter balance: The balane in this currency
     - Parameter minimumAmount: Minimum redemption value in this currency
     */
    
    public init(currency: AmountedCurrency?, balanceAmount: Double?, minimumAmount: Double?) {
        self.currency = currency
        self.balanceAmount = balanceAmount
        self.minimumAmount = minimumAmount
    }
    
    /// The currency itself
    public let currency: AmountedCurrency?
    /// Balance in this currency
    public let balanceAmount:Double?
    /// minimum redemption value in this currency
    public let minimumAmount:Double?
}

// MARK: SupportedCurrency convenience initializers and mutators

public extension LoyaltySupportedCurrency {
    /**
     The model of the loyalty supported currencies. Each one will have the the rating + the currency itself
     - Parameter data: The data to decode it into the model
     */
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LoyaltySupportedCurrency.self, from: data)
    }
    
    /**
     The model of the loyalty supported currencies. Each one will have the the rating + the currency itself
     - Parameter string: The string  json to decode it into the modelParameter data: The data to decode it into the model
     - Parameter encoding: The encoding method. Default is UTF8
     */
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    /**
     The model of the loyalty supported currencies. Each one will have the the rating + the currency itself
     */
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    /// Encodes the model into Data
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    /// Encodes the model into pretty formatted JSON string
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
