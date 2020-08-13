//
//  TapApplePay.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 01/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import class PassKit.PKPaymentAuthorizationController
import class PassKit.PKPayment
import protocol PassKit.PKPaymentAuthorizationControllerDelegate
import class PassKit.PKPaymentAuthorizationResult
import class PassKit.PKPassLibrary
import class UIKit.UIViewController

/// This is the Tap provided class that provides the Tap-ApplePay functionalities
@objcMembers public class TapApplePay:NSObject {
    
    internal var tokenizedBlock:((TapApplePayToken)->())?
//    var paymentController = PKPaymentAuthorizationController.init()
    
    /**
        This static interface is used if Pay is available as per the device capability!
     - Parameter tapPaymentNetworks: If the payment should be done through certain payment networks, please pass them here to check if the current user has valid cards added to his wallet belongs to at least one of the needed payment networks. Default is Empty
     - Parameter shouldOpenSetupDirectly: If set, then if the user is eligble for Apple pay but he didn't add a valid card that belongs to the given payment networks, the wallet will show up for him to add valid cards. PLEASE note, it is the not the responsibility for the interface to check again when the user comes back after adding a card. Default is false
     */
    public static func applePayStatus(for tapPaymentNetworks:[TapApplePayPaymentNetwork] = [], shouldOpenSetupDirectly:Bool = false) -> TapApplePayStatus {
        
        //FlurryLogger.logEvent(with: "Apple_Pay_Status_Called", timed:false , params: ["forPaymentNetworks":tapPaymentNetworks.map{$0.rawValue}.joined(separator: " , ")])
        
        if   PKPaymentAuthorizationController.canMakePayments() {
            // Pay is available as per the device capability!
            // Check if the caller wants to determine for certain payments networks
            if !tapPaymentNetworks.isEmpty {
                if PKPaymentAuthorizationController.canMakePayments(usingNetworks: tapPaymentNetworks.map { $0.applePayNetwork! }) {
                    // The device can make payments using the provided payment networks
                    return .Eligible
                }else {
                    // The user needs to add at least one card from the given payment networks
                    // Check if the caller wants to start adding cards right away now
                    if shouldOpenSetupDirectly {
                        startApplePaySetupProcess()
                    }
                    return .NeedSetup
                }
            }
            
            return .Eligible
        }
        
        return .NotEligible
        
    }
    
    /**
     Public interface to be used to start Apple pay athprization process without the need to include out Tap APple Pay button
     - Parameter presenter: The UIViewcontroller you want to show the native Apple Pay sheet in
     - Parameter tapApplePayRequest: The Tap apple request wrapper that has the valid data of your transaction
     - Parameter tokenized: The block to be called once the user successfully authorize the payment
     */
    public func authorizePayment(in presenter:UIViewController, for tapApplePayRequest:TapApplePayRequest, tokenized:@escaping ((TapApplePayToken)->())) {
        
        
        //FlurryLogger.logEvent(with: "Apple_Pay_Authorize_Payment_Called", timed:false , params:tapApplePayRequest.asDictionary())
        
        self.tokenizedBlock = tokenized
        tapApplePayRequest.updateValues()
        
        let paymentController = PKPaymentAuthorizationController.init(paymentRequest: tapApplePayRequest.appleRequest)
        paymentController.delegate = self//presenter as? PKPaymentAuthorizationControllerDelegate
        paymentController.present { (done) in
            //FlurryLogger.logEvent(with: "Apple_Pay_Sheet_Presented")
            print("PRESENTED : \(done)")
        }
        
    }
    
    
    /// This will trigger the provided Apple pay official method for starting the wallet app
    public static func startApplePaySetupProcess() {
        //FlurryLogger.logEvent(with: "Apple_Pay_Setup_Called")
        PKPassLibrary().openPaymentSetup()
    }
    
}

extension TapApplePay:PKPaymentAuthorizationControllerDelegate {
   
    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            //FlurryLogger.logEvent(with: "Apple_Pay_Sheet_Dismissed")
            print("DISMISSED")
        }
    }
    
    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        print("FINISHED")
        
        let tapAppleToken = TapApplePayToken.init(with:payment.token)
        
       /* if let jsonToken:[String:String] = tapAppleToken.jsonAppleToken as? [String:String] {
            //FlurryLogger.logEvent(with: "Apple_Pay_Sheet_Authorized", timed:false , params:jsonToken)
        }else if let stringToken:String = tapAppleToken.stringAppleToken {
            //FlurryLogger.logEvent(with: "Apple_Pay_Sheet_Authorized", timed:false , params:["AppleStringToken":stringToken])
        }else {
            //FlurryLogger.logEvent(with: "Apple_Pay_Sheet_Authorized", timed:false , params:["AppleStringToken":""])
        }*/
        
        completion(PKPaymentAuthorizationResult(status: .success,errors: nil))
        
        if let nonNullTokenizedBlock = tokenizedBlock {
            nonNullTokenizedBlock(tapAppleToken)
        }
    }
}
