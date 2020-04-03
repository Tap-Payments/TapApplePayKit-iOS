//
//  TapCurrencyCode.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 02/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
///The Currency Code . The Currency Code should indicate the country in which the merchant transacts.
@objc public enum TapCurrencyCode: Int, RawRepresentable, CaseIterable {
    
    /// United Arab Emirates dirham currency code
    case AED
    /// Afghan afghani currency code
    case AFN
    /// Albanian lek currency code
    case ALL
    /// Armenian dram currency code
    case AMD
    /// Netherlands Antillean guilder currency code
    case ANG
    /// Angolan kwanza currency code
    case AOA
    /// Argentine peso currency code
    case ARS
    /// Australian dollar currency code
    case AUD
    /// Aruban florin currency code
    case AWG
    /// Azerbaijani manat currency code
    case AZN
    /// Bosnia and Herzegovina convertible mark currency code
    case BAM
    /// Barbados dollar currency code
    case BBD
    /// Bangladeshi taka currency code
    case BDT
    /// Bulgarian lev currency code
    case BGN
    /// Bahraini dinar currency code
    case BHD
    /// Burundian franc currency code
    case BIF
    /// Bermudian dollar currency code
    case BMD
    /// Brunei dollar currency code
    case BND
    /// Boliviano currency code
    case BOB
    /// Bolivian Mvdol (funds code) currency code
    case BOV
    /// Brazilian real currency code
    case BRL
    /// Bahamian dollar currency code
    case BSD
    /// Bhutanese ngultrum currency code
    case BTN
    /// Botswana pula currency code
    case BWP
    /// Belarusian ruble currency code
    case BYN
    /// Belize dollar currency code
    case BZD
    /// Canadian dollar currency code
    case CAD
    /// Congolese franc currency code
    case CDF
    /// WIR Euro (complementary currency) currency code
    case CHE
    /// Swiss franc currency code
    case CHF
    /// WIR Franc (complementary currency) currency code
    case CHW
    /// Unidad de Fomento (funds code) currency code
    case CLF
    /// Chilean peso currency code
    case CLP
    /// Renminbi (Chinese) yuan[7] currency code
    case CNY
    /// Colombian peso currency code
    case COP
    /// Unidad de Valor Real (UVR) (funds code)[8] currency code
    case COU
    /// Costa Rican colon currency code
    case CRC
    /// Cuban convertible peso currency code
    case CUC
    /// Cuban peso currency code
    case CUP
    /// Cape Verdean escudo currency code
    case CVE
    /// Czech koruna currency code
    case CZK
    /// Djiboutian franc currency code
    case DJF
    /// Danish krone currency code
    case DKK
    /// Dominican peso currency code
    case DOP
    /// Algerian dinar currency code
    case DZD
    /// Egyptian pound currency code
    case EGP
    /// Eritrean nakfa currency code
    case ERN
    /// Ethiopian birr currency code
    case ETB
    /// Euro currency code
    case EUR
    /// Fiji dollar currency code
    case FJD
    /// Falkland Islands pound currency code
    case FKP
    /// Pound sterling currency code
    case GBP
    /// Georgian lari currency code
    case GEL
    /// Ghanaian cedi currency code
    case GHS
    /// Gibraltar pound currency code
    case GIP
    /// Gambian dalasi currency code
    case GMD
    /// Guinean franc currency code
    case GNF
    /// Guatemalan quetzal currency code
    case GTQ
    /// Guyanese dollar currency code
    case GYD
    /// Hong Kong dollar currency code
    case HKD
    /// Honduran lempira currency code
    case HNL
    /// Croatian kuna currency code
    case HRK
    /// Haitian gourde currency code
    case HTG
    /// Hungarian forint currency code
    case HUF
    /// Indonesian rupiah currency code
    case IDR
    /// Israeli new shekel currency code
    case ILS
    /// Indian rupee currency code
    case INR
    /// Iraqi dinar currency code
    case IQD
    /// Iranian rial currency code
    case IRR
    /// Icelandic króna currency code
    case ISK
    /// Jamaican dollar currency code
    case JMD
    /// Jordanian dinar currency code
    case JOD
    /// Japanese yen currency code
    case JPY
    /// Kenyan shilling currency code
    case KES
    /// Kyrgyzstani som currency code
    case KGS
    /// Cambodian riel currency code
    case KHR
    /// Comoro franc currency code
    case KMF
    /// North Korean won currency code
    case KPW
    /// South Korean won currency code
    case KRW
    /// Kuwaiti dinar currency code
    case KWD
    /// Cayman Islands dollar currency code
    case KYD
    /// Kazakhstani tenge currency code
    case KZT
    /// Lao kip currency code
    case LAK
    /// Lebanese pound currency code
    case LBP
    /// Sri Lankan rupee currency code
    case LKR
    /// Liberian dollar currency code
    case LRD
    /// Lesotho loti currency code
    case LSL
    /// Libyan dinar currency code
    case LYD
    /// Moroccan dirham currency code
    case MAD
    /// Moldovan leu currency code
    case MDL
    /// Malagasy ariary currency code
    case MGA
    /// Macedonian denar currency code
    case MKD
    /// Myanmar kyat currency code
    case MMK
    /// Mongolian tögrög currency code
    case MNT
    /// Macanese pataca currency code
    case MOP
    /// Mauritian rupee currency code
    case MUR
    /// Maldivian rufiyaa currency code
    case MVR
    /// Malawian kwacha currency code
    case MWK
    /// Mexican peso currency code
    case MXN
    /// Mexican Unidad de Inversion (UDI) (funds code) currency code
    case MXV
    /// Malaysian ringgit currency code
    case MYR
    /// Mozambican metical currency code
    case MZN
    /// Namibian dollar currency code
    case NAD
    /// Nigerian naira currency code
    case NGN
    /// Nicaraguan córdoba currency code
    case NIO
    /// Norwegian krone currency code
    case NOK
    /// Nepalese rupee currency code
    case NPR
    /// New Zealand dollar currency code
    case NZD
    /// Omani rial currency code
    case OMR
    /// Panamanian balboa currency code
    case PAB
    /// Peruvian sol currency code
    case PEN
    /// Papua New Guinean kina currency code
    case PGK
    /// Philippine peso[13] currency code
    case PHP
    /// Pakistani rupee currency code
    case PKR
    /// Polish złoty currency code
    case PLN
    /// Paraguayan guaraní currency code
    case PYG
    /// Qatari riyal currency code
    case QAR
    /// Romanian leu currency code
    case RON
    /// Serbian dinar currency code
    case RSD
    /// Russian ruble currency code
    case RUB
    /// Rwandan franc currency code
    case RWF
    /// Saudi riyal currency code
    case SAR
    /// Solomon Islands dollar currency code
    case SBD
    /// Seychelles rupee currency code
    case SCR
    /// Sudanese pound currency code
    case SDG
    /// Swedish krona/kronor currency code
    case SEK
    /// Singapore dollar currency code
    case SGD
    /// Saint Helena pound currency code
    case SHP
    /// Sierra Leonean leone currency code
    case SLL
    /// Somali shilling currency code
    case SOS
    /// Surinamese dollar currency code
    case SRD
    /// South Sudanese pound currency code
    case SSP
    /// Salvadoran colón currency code
    case SVC
    /// Syrian pound currency code
    case SYP
    /// Swazi lilangeni currency code
    case SZL
    /// Thai baht currency code
    case THB
    /// Tajikistani somoni currency code
    case TJS
    /// Turkmenistan manat currency code
    case TMT
    /// Tunisian dinar currency code
    case TND
    /// Tongan paʻanga currency code
    case TOP
    /// Turkish lira currency code
    case TRY
    /// Trinidad and Tobago dollar currency code
    case TTD
    /// New Taiwan dollar currency code
    case TWD
    /// Tanzanian shilling currency code
    case TZS
    /// Ukrainian hryvnia currency code
    case UAH
    /// Ugandan shilling currency code
    case UGX
    /// United States dollar currency code
    case USD
    /// United States dollar (next day) (funds code) currency code
    case USN
    /// Uruguay Peso en Unidades Indexadas (URUIURUI) (funds code) currency code
    case UYI
    /// Uruguayan peso currency code
    case UYU
    /// Unidad previsional[15] currency code
    case UYW
    /// Uzbekistan som currency code
    case UZS
    /// Venezuelan bolívar soberano[13] currency code
    case VES
    /// Vietnamese đồng currency code
    case VND
    /// Vanuatu vatu currency code
    case VUV
    /// Samoan tala currency code
    case WST
    /// CFA franc BEAC currency code
    case XAF
    /// Silver (one troy ounce) currency code
    case XAG
    /// Gold (one troy ounce) currency code
    case XAU
    /// European Composite Unit (EURCO) (bond market unit) currency code
    case XBA
    /// European Monetary Unit (E.M.U.-6) (bond market unit) currency code
    case XBB
    /// European Unit of Account 9 (E.U.A.-9) (bond market unit) currency code
    case XBC
    /// European Unit of Account 17 (E.U.A.-17) (bond market unit) currency code
    case XBD
    /// East Caribbean dollar currency code
    case XCD
    /// Special drawing rights currency code
    case XDR
    /// CFA franc BCEAO currency code
    case XOF
    /// Palladium (one troy ounce) currency code
    case XPD
    /// CFP franc (franc Pacifique) currency code
    case XPF
    /// Platinum (one troy ounce) currency code
    case XPT
    /// SUCRE currency code
    case XSU
    /// Code reserved for testing currency code
    case XTS
    /// ADB Unit of Account currency code
    case XUA
    /// No currency currency code
    case XXX
    /// Yemeni rial currency code
    case YER
    /// South African rand currency code
    case ZAR
    /// Zambian kwacha currency code
    case ZMW
    /// Zimbabwean dollar currency code
    case ZWL
    
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .AED:
            return "AED"
        case .AFN:
            return "AFN"
        case .ALL:
            return "ALL"
        case .AMD:
            return "AMD"
        case .ANG:
            return "ANG"
        case .AOA:
            return "AOA"
        case .ARS:
            return "ARS"
        case .AUD:
            return "AUD"
        case .AWG:
            return "AWG"
        case .AZN:
            return "AZN"
        case .BAM:
            return "BAM"
        case .BBD:
            return "BBD"
        case .BDT:
            return "BDT"
        case .BGN:
            return "BGN"
        case .BHD:
            return "BHD"
        case .BIF:
            return "BIF"
        case .BMD:
            return "BMD"
        case .BND:
            return "BND"
        case .BOB:
            return "BOB"
        case .BOV:
            return "BOV"
        case .BRL:
            return "BRL"
        case .BSD:
            return "BSD"
        case .BTN:
            return "BTN"
        case .BWP:
            return "BWP"
        case .BYN:
            return "BYN"
        case .BZD:
            return "BZD"
        case .CAD:
            return "CAD"
        case .CDF:
            return "CDF"
        case .CHE:
            return "CHE"
        case .CHF:
            return "CHF"
        case .CHW:
            return "CHW"
        case .CLF:
            return "CLF"
        case .CLP:
            return "CLP"
        case .CNY:
            return "CNY"
        case .COP:
            return "COP"
        case .COU:
            return "COU"
        case .CRC:
            return "CRC"
        case .CUC:
            return "CUC"
        case .CUP:
            return "CUP"
        case .CVE:
            return "CVE"
        case .CZK:
            return "CZK"
        case .DJF:
            return "DJF"
        case .DKK:
            return "DKK"
        case .DOP:
            return "DOP"
        case .DZD:
            return "DZD"
        case .EGP:
            return "EGP"
        case .ERN:
            return "ERN"
        case .ETB:
            return "ETB"
        case .EUR:
            return "EUR"
        case .FJD:
            return "FJD"
        case .FKP:
            return "FKP"
        case .GBP:
            return "GBP"
        case .GEL:
            return "GEL"
        case .GHS:
            return "GHS"
        case .GIP:
            return "GIP"
        case .GMD:
            return "GMD"
        case .GNF:
            return "GNF"
        case .GTQ:
            return "GTQ"
        case .GYD:
            return "GYD"
        case .HKD:
            return "HKD"
        case .HNL:
            return "HNL"
        case .HRK:
            return "HRK"
        case .HTG:
            return "HTG"
        case .HUF:
            return "HUF"
        case .IDR:
            return "IDR"
        case .ILS:
            return "ILS"
        case .INR:
            return "INR"
        case .IQD:
            return "IQD"
        case .IRR:
            return "IRR"
        case .ISK:
            return "ISK"
        case .JMD:
            return "JMD"
        case .JOD:
            return "JOD"
        case .JPY:
            return "JPY"
        case .KES:
            return "KES"
        case .KGS:
            return "KGS"
        case .KHR:
            return "KHR"
        case .KMF:
            return "KMF"
        case .KPW:
            return "KPW"
        case .KRW:
            return "KRW"
        case .KWD:
            return "KWD"
        case .KYD:
            return "KYD"
        case .KZT:
            return "KZT"
        case .LAK:
            return "LAK"
        case .LBP:
            return "LBP"
        case .LKR:
            return "LKR"
        case .LRD:
            return "LRD"
        case .LSL:
            return "LSL"
        case .LYD:
            return "LYD"
        case .MAD:
            return "MAD"
        case .MDL:
            return "MDL"
        case .MGA:
            return "MGA"
        case .MKD:
            return "MKD"
        case .MMK:
            return "MMK"
        case .MNT:
            return "MNT"
        case .MOP:
            return "MOP"
        case .MUR:
            return "MUR"
        case .MVR:
            return "MVR"
        case .MWK:
            return "MWK"
        case .MXN:
            return "MXN"
        case .MXV:
            return "MXV"
        case .MYR:
            return "MYR"
        case .MZN:
            return "MZN"
        case .NAD:
            return "NAD"
        case .NGN:
            return "NGN"
        case .NIO:
            return "NIO"
        case .NOK:
            return "NOK"
        case .NPR:
            return "NPR"
        case .NZD:
            return "NZD"
        case .OMR:
            return "OMR"
        case .PAB:
            return "PAB"
        case .PEN:
            return "PEN"
        case .PGK:
            return "PGK"
        case .PHP:
            return "PHP"
        case .PKR:
            return "PKR"
        case .PLN:
            return "PLN"
        case .PYG:
            return "PYG"
        case .QAR:
            return "QAR"
        case .RON:
            return "RON"
        case .RSD:
            return "RSD"
        case .RUB:
            return "RUB"
        case .RWF:
            return "RWF"
        case .SAR:
            return "SAR"
        case .SBD:
            return "SBD"
        case .SCR:
            return "SCR"
        case .SDG:
            return "SDG"
        case .SEK:
            return "SEK"
        case .SGD:
            return "SGD"
        case .SHP:
            return "SHP"
        case .SLL:
            return "SLL"
        case .SOS:
            return "SOS"
        case .SRD:
            return "SRD"
        case .SSP:
            return "SSP"
        case .SVC:
            return "SVC"
        case .SYP:
            return "SYP"
        case .SZL:
            return "SZL"
        case .THB:
            return "THB"
        case .TJS:
            return "TJS"
        case .TMT:
            return "TMT"
        case .TND:
            return "TND"
        case .TOP:
            return "TOP"
        case .TRY:
            return "TRY"
        case .TTD:
            return "TTD"
        case .TWD:
            return "TWD"
        case .TZS:
            return "TZS"
        case .UAH:
            return "UAH"
        case .UGX:
            return "UGX"
        case .USD:
            return "USD"
        case .USN:
            return "USN"
        case .UYI:
            return "UYI"
        case .UYU:
            return "UYU"
        case .UYW:
            return "UYW"
        case .UZS:
            return "UZS"
        case .VES:
            return "VES"
        case .VND:
            return "VND"
        case .VUV:
            return "VUV"
        case .WST:
            return "WST"
        case .XAF:
            return "XAF"
        case .XAG:
            return "XAG"
        case .XAU:
            return "XAU"
        case .XBA:
            return "XBA"
        case .XBB:
            return "XBB"
        case .XBC:
            return "XBC"
        case .XBD:
            return "XBD"
        case .XCD:
            return "XCD"
        case .XDR:
            return "XDR"
        case .XOF:
            return "XOF"
        case .XPD:
            return "XPD"
        case .XPF:
            return "XPF"
        case .XPT:
            return "XPT"
        case .XSU:
            return "XSU"
        case .XTS:
            return "XTS"
        case .XUA:
            return "XUA"
        case .XXX:
            return "XXX"
        case .YER:
            return "YER"
        case .ZAR:
            return "ZAR"
        case .ZMW:
            return "ZMW"
        case .ZWL:
            return "ZWL"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue.uppercased() {
        case "AED":
            self = .AED
        case "AFN":
            self = .AFN
        case "ALL":
            self = .ALL
        case "AMD":
            self = .AMD
        case "ANG":
            self = .ANG
        case "AOA":
            self = .AOA
        case "ARS":
            self = .ARS
        case "AUD":
            self = .AUD
        case "AWG":
            self = .AWG
        case "AZN":
            self = .AZN
        case "BAM":
            self = .BAM
        case "BBD":
            self = .BBD
        case "BDT":
            self = .BDT
        case "BGN":
            self = .BGN
        case "BHD":
            self = .BHD
        case "BIF":
            self = .BIF
        case "BMD":
            self = .BMD
        case "BND":
            self = .BND
        case "BOB":
            self = .BOB
        case "BOV":
            self = .BOV
        case "BRL":
            self = .BRL
        case "BSD":
            self = .BSD
        case "BTN":
            self = .BTN
        case "BWP":
            self = .BWP
        case "BYN":
            self = .BYN
        case "BZD":
            self = .BZD
        case "CAD":
            self = .CAD
        case "CDF":
            self = .CDF
        case "CHE":
            self = .CHE
        case "CHF":
            self = .CHF
        case "CHW":
            self = .CHW
        case "CLF":
            self = .CLF
        case "CLP":
            self = .CLP
        case "CNY":
            self = .CNY
        case "COP":
            self = .COP
        case "COU":
            self = .COU
        case "CRC":
            self = .CRC
        case "CUC":
            self = .CUC
        case "CUP":
            self = .CUP
        case "CVE":
            self = .CVE
        case "CZK":
            self = .CZK
        case "DJF":
            self = .DJF
        case "DKK":
            self = .DKK
        case "DOP":
            self = .DOP
        case "DZD":
            self = .DZD
        case "EGP":
            self = .EGP
        case "ERN":
            self = .ERN
        case "ETB":
            self = .ETB
        case "EUR":
            self = .EUR
        case "FJD":
            self = .FJD
        case "FKP":
            self = .FKP
        case "GBP":
            self = .GBP
        case "GEL":
            self = .GEL
        case "GHS":
            self = .GHS
        case "GIP":
            self = .GIP
        case "GMD":
            self = .GMD
        case "GNF":
            self = .GNF
        case "GTQ":
            self = .GTQ
        case "GYD":
            self = .GYD
        case "HKD":
            self = .HKD
        case "HNL":
            self = .HNL
        case "HRK":
            self = .HRK
        case "HTG":
            self = .HTG
        case "HUF":
            self = .HUF
        case "IDR":
            self = .IDR
        case "ILS":
            self = .ILS
        case "INR":
            self = .INR
        case "IQD":
            self = .IQD
        case "IRR":
            self = .IRR
        case "ISK":
            self = .ISK
        case "JMD":
            self = .JMD
        case "JOD":
            self = .JOD
        case "JPY":
            self = .JPY
        case "KES":
            self = .KES
        case "KGS":
            self = .KGS
        case "KHR":
            self = .KHR
        case "KMF":
            self = .KMF
        case "KPW":
            self = .KPW
        case "KRW":
            self = .KRW
        case "KWD":
            self = .KWD
        case "KYD":
            self = .KYD
        case "KZT":
            self = .KZT
        case "LAK":
            self = .LAK
        case "LBP":
            self = .LBP
        case "LKR":
            self = .LKR
        case "LRD":
            self = .LRD
        case "LSL":
            self = .LSL
        case "LYD":
            self = .LYD
        case "MAD":
            self = .MAD
        case "MDL":
            self = .MDL
        case "MGA":
            self = .MGA
        case "MKD":
            self = .MKD
        case "MMK":
            self = .MMK
        case "MNT":
            self = .MNT
        case "MOP":
            self = .MOP
        case "MUR":
            self = .MUR
        case "MVR":
            self = .MVR
        case "MWK":
            self = .MWK
        case "MXN":
            self = .MXN
        case "MXV":
            self = .MXV
        case "MYR":
            self = .MYR
        case "MZN":
            self = .MZN
        case "NAD":
            self = .NAD
        case "NGN":
            self = .NGN
        case "NIO":
            self = .NIO
        case "NOK":
            self = .NOK
        case "NPR":
            self = .NPR
        case "NZD":
            self = .NZD
        case "OMR":
            self = .OMR
        case "PAB":
            self = .PAB
        case "PEN":
            self = .PEN
        case "PGK":
            self = .PGK
        case "PHP":
            self = .PHP
        case "PKR":
            self = .PKR
        case "PLN":
            self = .PLN
        case "PYG":
            self = .PYG
        case "QAR":
            self = .QAR
        case "RON":
            self = .RON
        case "RSD":
            self = .RSD
        case "RUB":
            self = .RUB
        case "RWF":
            self = .RWF
        case "SAR":
            self = .SAR
        case "SBD":
            self = .SBD
        case "SCR":
            self = .SCR
        case "SDG":
            self = .SDG
        case "SEK":
            self = .SEK
        case "SGD":
            self = .SGD
        case "SHP":
            self = .SHP
        case "SLL":
            self = .SLL
        case "SOS":
            self = .SOS
        case "SRD":
            self = .SRD
        case "SSP":
            self = .SSP
        case "SVC":
            self = .SVC
        case "SYP":
            self = .SYP
        case "SZL":
            self = .SZL
        case "THB":
            self = .THB
        case "TJS":
            self = .TJS
        case "TMT":
            self = .TMT
        case "TND":
            self = .TND
        case "TOP":
            self = .TOP
        case "TRY":
            self = .TRY
        case "TTD":
            self = .TTD
        case "TWD":
            self = .TWD
        case "TZS":
            self = .TZS
        case "UAH":
            self = .UAH
        case "UGX":
            self = .UGX
        case "USD":
            self = .USD
        case "USN":
            self = .USN
        case "UYI":
            self = .UYI
        case "UYU":
            self = .UYU
        case "UYW":
            self = .UYW
        case "UZS":
            self = .UZS
        case "VES":
            self = .VES
        case "VND":
            self = .VND
        case "VUV":
            self = .VUV
        case "WST":
            self = .WST
        case "XAF":
            self = .XAF
        case "XAG":
            self = .XAG
        case "XAU":
            self = .XAU
        case "XBA":
            self = .XBA
        case "XBB":
            self = .XBB
        case "XBC":
            self = .XBC
        case "XBD":
            self = .XBD
        case "XCD":
            self = .XCD
        case "XDR":
            self = .XDR
        case "XOF":
            self = .XOF
        case "XPD":
            self = .XPD
        case "XPF":
            self = .XPF
        case "XPT":
            self = .XPT
        case "XSU":
            self = .XSU
        case "XTS":
            self = .XTS
        case "XUA":
            self = .XUA
        case "XXX":
            self = .XXX
        case "YER":
            self = .YER
        case "ZAR":
            self = .ZAR
        case "ZMW":
            self = .ZMW
        case "ZWL":
            self = .ZWL
        default:
            return nil
        }
    }
}
