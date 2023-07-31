//
//  PaymentOptionButtonStyle.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 19/04/2023.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let paymentOptionButtonStyle = try PaymentOptionButtonStyle(json)

import Foundation
import UIKit
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let paymentOptionButtonStyle = try PaymentOptionButtonStyle(json)


// MARK: - PaymentOptionButtonStyle
public struct PaymentOptionButtonStyle: Codable {
    public var background: Background?
    public var titlesAssets: String?
    
    enum CodingKeys: String, CodingKey {
        case background
        case titlesAssets = "title_asset"
    }
}

// MARK: PaymentOptionButtonStyle convenience initializers and mutators

extension PaymentOptionButtonStyle {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PaymentOptionButtonStyle.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    /// Returns and computes the list of colors for the ingredients passed to this style.
    /// Also, it auto computes whether we need to display the dark or light colors based on the device interface
    /// - Parameter showMonoForLightMode: Indicates whether to show the light or the light mono
    /// - Parameter showColoredForDarkMode: Indicates whether to show the dark or the dark colored
    public func backgroundColors(showMonoForLightMode:Bool = false, showColoredForDarkMode:Bool) -> [UIColor] {
        guard let lightBackgroundColors:[String] = background?.light?.backgroundColors,
              let darkBackgroundColors:[String] = background?.dark?.backgroundColors,
              let lightMonoBackgroundColors:[String] = background?.lightMono?.backgroundColors,
              let darkColoredBackgroundColors:[String] = background?.darkColored?.backgroundColors else { return [.black] }
        
        // We decide which theme object to user based on the current userInterfaceStyle
        if #available(iOS 12.0, *) {
            return (UIView().traitCollection.userInterfaceStyle == .dark) ? showColoredForDarkMode ? darkColoredBackgroundColors.compactMap{ UIColor(tap_hex: $0) } : darkBackgroundColors.compactMap{ UIColor(tap_hex: $0) } : showMonoForLightMode ? lightMonoBackgroundColors.compactMap{ UIColor(tap_hex: $0) } : lightBackgroundColors.compactMap{ UIColor(tap_hex: $0) }
        } else {
            // Fallback on earlier versions
            return showMonoForLightMode ? lightMonoBackgroundColors.compactMap{ UIColor(tap_hex: $0) } : lightBackgroundColors.compactMap{ UIColor(tap_hex: $0) }
        }
    }
    
    /// Returns and computes the loading base solid color
    /// - Parameter showMonoForLightMode: Indicates whether to show the light or the light mono
    /// - Parameter showColoredForDarkMode: Indicates whether to show the dark or the dark colored
    public func loadingBasebackgroundColor(showMonoForLightMode:Bool = false, showColoredForDarkMode:Bool) -> UIColor? {
        guard let lightBackgroundColor:String       = background?.light?.baseColor,
              let darkBackgroundColor:String        = background?.dark?.baseColor,
              let lightMonoBackgroundColor:String   = background?.lightMono?.baseColor,
              let darkColoredBackgroundColor:String   = background?.darkColored?.baseColor else { return nil }
        
        // We decide which theme object to user based on the current userInterfaceStyle
        if #available(iOS 12.0, *) {
            return (UIView().traitCollection.userInterfaceStyle == .dark) ?  showColoredForDarkMode ? UIColor(tap_hex: darkColoredBackgroundColor) : UIColor(tap_hex: darkBackgroundColor) : showMonoForLightMode ? UIColor(tap_hex: lightMonoBackgroundColor) : UIColor(tap_hex: lightBackgroundColor)
        } else {
            // Fallback on earlier versions
            return showMonoForLightMode ? UIColor(tap_hex: lightMonoBackgroundColor) : UIColor(tap_hex: lightBackgroundColor)
        }
    }
    
    /**
     Generates the correct url to access the image to be displayed on the action button when valid, using the attached payment option
     - Parameter for displayMode : To indicate whether you need the dark or light
     - Parameter and locale: To indicate which locale you want to show for example en,ar etc.
     - Parameter with fileFxtension: The assets extension to append to fetch the correct image from the url
     */
    public func paymentOptionImageUrl(for displayMode:String, and locale:String, with fileFxtension:String) -> String {
        // make sure we already have a string representing the base url for this payment option
        guard var nonNullTitleAsset = titlesAssets else { return "" }
        // let us replace the url parts with the given parameters
        nonNullTitleAsset = nonNullTitleAsset.replacingOccurrences(of: "{theme}", with: displayMode)
        nonNullTitleAsset = nonNullTitleAsset.replacingOccurrences(of: "{lang}",  with: locale)
        // let us append the extension
        nonNullTitleAsset = "\(nonNullTitleAsset)\(fileFxtension)"
        // let us return now
        return nonNullTitleAsset
    }
    
    /// Returns the solid color the button should show after shrinking while loading
    /// Also, it auto computes whether we need to display the dark or light colors based on the device interface
    /// - Parameter showMonoForLightMode: Indicates whether to show the light or the light mono
    /// - Parameter showColoredForDarkMode: Indicates whether to show the dark or the dark colored
    func baseColor(showMonoForLightMode:Bool = false, showColoredForDarkMode:Bool) -> UIColor {
        guard let lightBackgroundColor:String = background?.light?.baseColor,
              let darkBackgroundColor:String = background?.dark?.baseColor,
              let lightMonoBackgroundColor:String = background?.lightMono?.baseColor,
              let darkColoredBackgroundColor:String = background?.darkColored?.baseColor else { return .black }
        
        // We decide which theme object to user based on the current userInterfaceStyle
        if #available(iOS 12.0, *) {
            return (UIView().traitCollection.userInterfaceStyle == .dark) ? showColoredForDarkMode ? UIColor(tap_hex: darkColoredBackgroundColor)! : UIColor(tap_hex: darkBackgroundColor)! : showMonoForLightMode ? UIColor(tap_hex: lightMonoBackgroundColor)! : UIColor(tap_hex: lightBackgroundColor)!
        } else {
            // Fallback on earlier versions
            return UIColor(tap_hex: lightBackgroundColor)!
        }
    }
    
    func with(
        background: Background?? = nil,
        titlesAssets: String?? = nil
    ) -> PaymentOptionButtonStyle {
        return PaymentOptionButtonStyle(
            background: background ?? self.background,
            titlesAssets: titlesAssets ?? self.titlesAssets
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Background
public struct Background: Codable {
    var light, dark, lightMono, darkColored: BackgroundDark?
    // MARK: - Private -
    
    private enum CodingKeys : String, CodingKey {
        case light, lightMono = "light_mono", dark, darkColored = "dark_colored"
    }
}

// MARK: Background convenience initializers and mutators

extension Background {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Background.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        light: BackgroundDark?? = nil,
        dark: BackgroundDark?? = nil,
        lightMono: BackgroundDark?? = nil
    ) -> Background {
        return Background(
            light: light ?? self.light,
            dark: dark ?? self.dark,
            lightMono: lightMono ?? self.lightMono
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - BackgroundDark
struct BackgroundDark: Codable {
    var baseColor: String?
    var backgroundColors: [String]?
    
    enum CodingKeys: String, CodingKey {
        case baseColor = "base_color"
        case backgroundColors = "background_colors"
    }
}

// MARK: BackgroundDark convenience initializers and mutators

extension BackgroundDark {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(BackgroundDark.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        baseColor: String?? = nil,
        backgroundColors: [String]?? = nil
    ) -> BackgroundDark {
        return BackgroundDark(
            baseColor: baseColor ?? self.baseColor,
            backgroundColors: backgroundColors ?? self.backgroundColors
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders


@propertyWrapper public struct NilOnFail<T: Codable>: Codable {
    
    public let wrappedValue: T?
    public init(from decoder: Decoder) throws {
        wrappedValue = try? T(from: decoder)
    }
    public init(_ wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
}
