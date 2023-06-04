//
//  TapApplePayPaymentNetwork.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 01/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import struct PassKit.PKPaymentNetwork
import TapCardVlidatorKit_iOS
/// Enum to define  a payment network to be provided into Apple Pay request
@objc public enum TapApplePayPaymentNetwork: Int, RawRepresentable, CaseIterable {
   
    public typealias AllCases = [TapApplePayPaymentNetwork]
    
    public static var allCases: AllCases {
      get {
        var allCasesArray:[TapApplePayPaymentNetwork] = [.Amex,.CartesBancaires,.Discover,.Eftpos,.Electron,.idCredit,.Interac,.JCB,.Maestro,.MasterCard,.PrivateLabel,.QuicPay,.Suica,.Visa,.VPay]
        if #available(iOS 12.1.1, *) {
            allCasesArray.append(.Mada)
            allCasesArray.append(.Elo)
        }
        return allCasesArray
      }
    }
    
    
    case Amex
    case CartesBancaires
    case Discover
    case Eftpos
    case Electron
    @available(iOS 12.1.1, *)
    case Elo
    case idCredit
    case Interac
    case JCB
    @available(iOS 12.1.1, *)
    case Mada
    case Maestro
    case MasterCard
    case PrivateLabel
    case QuicPay
    case Suica
    case Visa
    case VPay

    
    
    
    /// Coming constcutors to spport creating enums from String in case of parsing it from JSON
    public init?(rawValue: String) {
        switch rawValue.lowercased() {
            case "amex":
                self = .Amex
            case "cartesbancaires":
            self = .CartesBancaires
            case "discover":
                self = .Discover
            case "eftpos":
                self = .Eftpos
            case "electron":
                self = .Electron
            case "idcredit":
                self = .idCredit
            case "interac":
                self = .Interac
            case "jcb":
                self = .JCB
            case "maestro":
                self = .Maestro
            case "mastercard":
                self = .MasterCard
            case "privatelabel":
                self = .PrivateLabel
            case "quicpay":
                self = .QuicPay
            case "suica":
                self = .Suica
            case "visa":
                self = .Visa
            case "vpay":
                self = .VPay
            default:
                if #available(iOS 12.1.1, *) {
                    switch rawValue.lowercased() {
                            case "elo":
                                self = .Elo
                            case "mada":
                                self = .Mada
                            default:
                                return nil
                        }
                }else { return nil }
        }
    }
    
    
    public init?(applePayNetwork: PKPaymentNetwork) {
        switch applePayNetwork {
        case .amex:
            self = .Amex
        case .cartesBancaires:
        self = .CartesBancaires
        case .discover:
            self = .Discover
        case .eftpos:
            self = .Eftpos
        case .electron:
            self = .Electron
        case .idCredit:
            self = .idCredit
        case .interac:
            self = .Interac
        case .JCB:
            self = .JCB
        case .maestro:
            self = .Maestro
        case .masterCard:
            self = .MasterCard
        case .privateLabel:
            self = .PrivateLabel
        case .quicPay:
            self = .QuicPay
        case .suica:
            self = .Suica
        case .visa:
            self = .Visa
        case .vPay:
            self = .VPay
            default:
                if #available(iOS 12.1.1, *) {
                    switch applePayNetwork {
                        case .elo:
                            self = .Elo
                        case .mada:
                            self = .Mada
                        default:
                            return nil
                    }
            }else {return nil}
        }
    }
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
            case .Amex:
                return "Amex"
            case .CartesBancaires:
            return "CartesBancaires"
            case .Discover:
                return "Discover"
            case .Eftpos:
                return "Eftpos"
            case .Electron:
                return "Electron"
            case .idCredit:
                return "idCredit"
            case .Interac:
                return "Interac"
            case .JCB:
                return "JCB"
            case .Maestro:
                return "Maestro"
            case .MasterCard:
                return "MasterCard"
            case .PrivateLabel:
                return "PrivateLabel"
            case .QuicPay:
                return "QuicPay"
            case .Suica:
                return "Suica"
            case .Visa:
                return "Visa"
            case .VPay:
                return "VPay"
        default:
            if #available(iOS 12.1.1, *) {
                    switch self {
                        case .Elo:
                            return "Elo"
                        case .Mada:
                            return "Mada"
                        default:
                            return ""
                    }
            }else {return ""}
        }
    }
    
    internal var applePayNetwork : PKPaymentNetwork? {
        switch self {
            case .Amex:
                return .amex
            case .CartesBancaires:
                return .cartesBancaires
            case .Discover:
                return .discover
            case .Eftpos:
                return .eftpos
            case .Electron:
                return .electron
            case .idCredit:
                return .idCredit
            case .Interac:
                return .interac
            case .JCB:
                return .JCB
            case .Maestro:
                return .maestro
            case .MasterCard:
                return .masterCard
            case .PrivateLabel:
                return .privateLabel
            case .QuicPay:
                return .quicPay
            case .Suica:
                return .suica
            case .Visa:
                return .visa
            case .VPay:
                return .vPay
        default:
            if #available(iOS 12.1.1, *) {
                    switch self {
                        case .Elo:
                            return .elo
                        case .Mada:
                            return .mada
                        default:
                            return nil
                    }
            }else {return nil}
        }
    }
    
    
    /// Converts the tap apple pay network to the cardbrand validator
    internal var tapCardBrand : CardBrand {
        switch self {
        case .Amex:
            return .americanExpress
        case .Discover:
            return .discover
        case .Electron:
            return .visaElectron
        case .Interac:
            return .interPayment
        case .JCB:
            return .jcb
        case .Maestro:
            return .maestro
        case .MasterCard:
            return .masterCard
        case .Visa:
            return .visa
        default:
            if #available(iOS 12.1.1, *) {
                switch self {
                case .Mada:
                    return .mada
                default:
                    return .unknown
                }
            }else {return .unknown}
        }
    }
}
