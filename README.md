# TapApplePayKit-iOS

A SDK that provides an interface to show, process and authorize Pay in your app.

[![Platform](https://img.shields.io/cocoapods/p/TapThemeManager2020.svg?style=flat)](https://github.com/Tap-Payments/TapThemeManger-iOS)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TapApplePayKit-iOS.svg?style=flat)](https://img.shields.io/Tap-Payments/v/TapApplePayKit-iOS)



## Requirements

To use the SDK the following requirements must be met:

1. **Xcode 11.0** or newer
2. **Swift 4.2** or newer (preinstalled with Xcode)
3. Deployment target SDK for the app: **iOS 12.0** or later



## Installation

------

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager, which automates and simplifies the process of using 3rd-party libraries in your projects.
You can install it with the following command:

```
$ gem install cocoapods
```

### Podfile

To integrate goSellSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
platform :ios, '12.0'
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'MyApp' do
    
    pod 'TapApplePayKit-iOS'

end
```

Then, run the following command:

```
$ pod update
```



## Features

------

`TapApplePayKit` provides extensive ways for utilising Pay in your application with ease:

- Using Tap Apple Pay Button:

  - On the shelf customisble Apple pay button.
  - Handles Apple payment authorization and processing.
  - Theme and title are customisable.
  - <img src="https://i.ibb.co/2t4x2YV/Simulator-Screen-Shot-i-Phone-11-2020-04-15-at-09-50-17.png" alt="Simulator-Screen-Shot-i-Phone-11-2020-04-15-at-09-50-17" style="zoom:50%;" />

- Using your UI:

  - You can start `TapApplePayKit`  from your own UI at the point you see convient.

  - Will handle Apple pay authorization.

  - Will delegate back the Apple Pay processing result.

    

  Making it one of the most inclusive pods in the market, yet one of the easiest to integrate with.

## Models

This section will descripe the models used within the kit. This is an important introduction to understand how to utilise and use the kit.



### TapApplePayPaymentNetwork

This an expressive enum to wrap PKPaymentNetwork. Following are the supported cases stating if any of them require a minimum iOS version

*Swift*:

```swift
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

```



### TapApplePayStatus

This enum is a wrapper to indicate the current device/user status to deal with Apple Pay.

*Swift*:

```swift
 /// This means the current device/user has Apple pay activated and a card belongs to the given payment networks
    case Eligible
    /// This means the current device/user has Apple pay activated but has no card belongs to the given payment networks
    case NeedSetup
    /// This means the current device/user cannot use Apple pay from Apple
    case NotEligible
```



### TapApplePayButtonType

This enum is an expresive wrapper of PKPaymentButtonType to define the type/context of the TapApplePayButton, this will effect the title on the button

*Swift*:

```swift
 /// Title : Pay
    case AppleLogoOnly
 /// Title : Buy with Pay
    case BuyWithApplePay
 /// Title : Setup Pay
    case SetupApplePay
 /// Title : Pay with Pay
    case PayWithApplePay
 /// Title : Donate with Pay
    case DonateWithApplePay
 /// Title : Checkout with Pay
    case CheckoutWithApplePay
 /// Title : Book with Pay
    case BookWithApplePay
 /// Title : Subscribe with Pay
    case SubscribeWithApplePay
```



### TapApplePayButtonType

This enum is an expresive wrapper of PKPaymentButtonStyle to define the style of the TapApplePayButton

*Swift*:

```swift
 /// Full black with white title
    case Black
/// Full white with black title
    case White
/// Full white with black border and black title
    case WhiteOutline
```



### TapApplePayToken

A class to represent TapApplePayToken model. This wraps the PKPaymentToken and will be used in the DataSource for `TapApplePayKit` . 

Also, it converts the raw  PKPaymentToken data to string and json and are publically accessible.

*Swift*:

```swift
 /**
     Create TapApplePayToken object with an apple payment token
     - Parameter rawAppleToken: This is the raw apple token you want to wrap. All other representations will be converted automatically
     */
    public init(with rawAppleToken:PKPaymentToken)
```



### TapApplePayRequest

The class that represents the request details that identefies the transaction and to be filled by the datasource of `TapApplePayKit` .  The app will have to pass mandatory information to fulfil Pay requirements.



*Swift*:

```swift
/**
     Creates a Tap Apple Pay request that can be used afterards to make an apple pay request
     - Parameter countryCode: The country code where the user transacts default .US
     - Parameter currencyCode: The currency code the transaction has default .USD
     - Parameter paymentNetworks:  The payment networks you  want to limit the payment to default [.Amex,.Visa,.Mada,.MasterCard]
     - Parameter var paymentItems: What are the items you want to show in the apple pay sheet default  []
     - Parameter paymentAmount: The total amount you want to collect
     - Parameter merchantID: The apple pay merchant identefier default ""
     **/
    public func build(with countryCode:TapCountryCode = .US, paymentNetworks:[TapApplePayPaymentNetwork] = [.Amex,.Visa,.MasterCard], paymentItems:[PKPaymentSummaryItem] = [], paymentAmount:Double,currencyCode:TapCurrencyCode = .USD,merchantID:String)
```

