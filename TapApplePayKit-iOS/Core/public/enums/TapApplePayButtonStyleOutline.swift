//
//  TapApplePayButtonStyleOutline.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 02/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//


import Foundation
import PassKit.PKConstants
/// Enum to define  the style of the TapApplePayButton
@objc public enum TapApplePayButtonStyleOutline: Int, RawRepresentable, CaseIterable {
    /// Black bg with white title
    case Black
    /// White bg with black title
    case White
    /// No bg, black title and border
    case WhiteOutline
    /// Will use black in light theme and white in dark them
    case Auto
    /// Coming constcutors to spport creating enums from String in case of parsing it from JSON
    public init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "black":
            self = .Black
        case "white":
            self = .White
        case "whiteoutline":
            self = .WhiteOutline
        case "auto":
            self = .Auto
        default:
            return nil
        }
    }
    
    
    public init?(applePayButtonStyle: PKPaymentButtonStyle) {
        switch applePayButtonStyle {
        case .black:
            self = .Black
        case .white:
            self = .White
        case .whiteOutline:
            self = .WhiteOutline
        default:
            return nil
        }
    }
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .Black:
            return "Black"
        case .White:
            return "White"
        case .WhiteOutline:
            return "WhiteOutline"
        case .Auto:
            return "Auto"
        default:
            return ""
        }
    }
    
    public var applePayButtonStyle: PKPaymentButtonStyle? {
        switch self {
        case .Black:
            return .black
        case .White:
            return .white
        case .WhiteOutline:
            return .whiteOutline
        default:
            return nil
        }
    }
}

