//
//  TapApplePayToken.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 02/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import class PassKit.PKPaymentToken

/// A class to represent TapApplePayToken model
@objcMembers public class TapApplePayToken:NSObject {
    
    /// This holds the raw apple token as PKPaymentToken, once set all other values are defined
    public var rawAppleToken:PKPaymentToken? {
        didSet{
            convertTokenToString()
            convertTokenToJson()
        }
    }
    /// This holds a string representation of the apple payment token
    public var stringAppleToken:String?
    
    /// This holds a dictionary representation of the apple payment token
    public var jsonAppleToken:[String: Any] = [:]
    
    /**
     Create TapApplePayToken object with an apple payment token
     - Parameter rawAppleToken: This is the raw apple token you want to wrap. All other representations will be converted automatically
     */
    public init(with rawAppleToken:PKPaymentToken) {
        super.init()
        
        self.rawAppleToken = rawAppleToken
        /// THis is for testing purposes only so it will show something on simulator and testing dvices for the team who has no Apple pay
        if self.rawAppleToken == nil || self.rawAppleToken?.paymentData.count == 0 {
            convertTokenToString()
            convertTokenToJson()
        }
        
    }
    
    
    /// Convert Apple pay token data to a string format
    internal func convertTokenToString(){
        /// Double check there is an Apple token to convert fist
        stringAppleToken = nil
        if let nonNullAppleToken = self.rawAppleToken {
            stringAppleToken = String(data: nonNullAppleToken.paymentData, encoding: .utf8) ?? nil
        }
        
        if stringAppleToken == nil || stringAppleToken == "" {
            // This is added for testing only
            stringAppleToken = """
{"version":"EC_v1","data":"D/LdKnlcYlgS/fzLRr6SdP1GlVAo2Dn8l+GJPyjyDhobBUzfIqVVXJws26NPG8F5Nor1d11pN40I9Dj2VW3PB9V3d2RiRI7EoMRJDiX+bZEccvkB2J8HV+2A/wgTP94qitwIn10AZ4Z2utO+q6UpW8ZBbncxDniE/4zqwgA/YYM8YnxhXQ/IzupRxD1JaAcj6mVue1XxWpw12zhqQgnCo59QSEPysCxVQoIbDnSUFd6eIj649oNLxkOztauZG0KZiK6UZjUnlRfN5Rq1ooCSPgi1gSLXyWiCAoEaQUuE/9VI1nNVhA5LBsDA96PGoQTxoXsklOFIhO+ZliwU8IMu8NMv+Q4APahmRZUHCcKYVhKcFnsyMgi6HYnNuQjWX7iLXCbbPI92HsXcF5p5XfSCcY2DG2qN190qDpUKBJwHjg==","signature":"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","header":{"ephemeralPublicKey":"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE2kfjdvQLxcfRS7rXFBI0vPKjL/qBOUNUgkN/JXcvpq0ACHbPWlgogvm5YZh/GBecVCu1AU1i+TSCaZ0VTnBWeg==","publicKeyHash":"LjAAyv6vb6jOEkjfG7L1a5OR2uCTHIkB61DaYdEWD+w=","transactionId":"1c072b6b9bdac6fb0757a8da8851eb1308a23a224b64b23bfb52f87e7ba6a81a"}}
"""
        }
    }
    
    /// Convert Apple pay token data to a dict format
    internal func convertTokenToJson(){
        convertTokenToString()
        /// Double check there is an Apple token to convert fist
        if let nonNullString = self.stringAppleToken,
           let jsonData = nonNullString.data(using: .utf8){
            do {
                self.jsonAppleToken = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
