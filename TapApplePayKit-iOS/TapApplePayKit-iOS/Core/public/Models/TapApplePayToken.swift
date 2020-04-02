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
            stringAppleToken = "{\"version\":\"EC_v1\",\"data\":\"P4b0dVwlBbULo6RDUGb765/i5/lChVPhl6t1M2FqGlIlr6k+azXGsLkj+Bam1ZCPVDQ6Oy19iIqHrlo/6kkKb0gk+2qb/DM7jZuEWooHr+FT+lKN/Tel1622yIgqR3gA9KqbqNbJzWFuWkINEUrtk2rANJGYjLLqfaAq8vfLsrU+fAu1WfJy0pMyFiNGtD3H6woEl+yhhW8akFoZY7073Fg1TnXZ2buJXbViSgaTXYqoqrtPkunAN4y3/VSJzj/e5oiYclFK7zl0sYN2ZYml7w/QrbxVc5VxFdwcqaZ2BhqksNMSUZPwBqWEF+Yc/6+MHE47iYkybycGIo5J2J59mnhTVzv2FecZRky1+FPRDzorIe6klcFEg3MoDt0v7+XzbeqIj7F24yACLwxx\",\"signature\":\"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\",\"header\":{\"ephemeralPublicKey\":\"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEN9RokExCu/+w1aQ3OB49yGX98eqVfq/vBnrCiqwtq1bY3Gg2d5GaE+A1cm74LzsGbXjdG09+q34s60K2FVm7Ag==\",\"publicKeyHash\":\"LjAAyv6vb6jOEkjfG7L1a5OR2uCTHIkB61DaYdEWD+w=\",\"transactionId\":\"cb3e8c9e65d33efecbe0681fa77fd3857431653c485d5b68b50ab9590c394264\"}}"
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
