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
    
    case Black
    case White
    case WhiteOutline
    
    /// Coming constcutors to spport creating enums from String in case of parsing it from JSON
    public init?(rawValue: String) {
        switch rawValue.lowercased() {
            case "black":
                self = .Black
            case "white":
                self = .White
            case "whiteoutline":
                self = .WhiteOutline
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

