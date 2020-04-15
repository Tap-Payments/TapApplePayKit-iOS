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
