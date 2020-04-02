//
//  TapApplePay.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 01/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import class PassKit.PKPaymentAuthorizationViewController
import class PassKit.PKPayment
import protocol PassKit.PKPaymentAuthorizationViewControllerDelegate
import class PassKit.PKPaymentAuthorizationResult
import class PassKit.PKPassLibrary
import class UIKit.UIViewController

/// This is the Tap provided class that provides the Tap-ApplePay functionalities
@objcMembers public class TapApplePay:NSObject {
    
    internal var tokenizedBlock:((TapApplePayToken)->())?
    
    /**
        This static interface is used if Pay is available as per the device capability!
     - Parameter tapPaymentNetworks: If the payment should be done through certain payment networks, please pass them here to check if the current user has valid cards added to his wallet belongs to at least one of the needed payment networks. Default is Empty
     - Parameter shouldOpenSetupDirectly: If set, then if the user is eligble for Apple pay but he didn't add a valid card that belongs to the given payment networks, the wallet will show up for him to add valid cards. PLEASE note, it is the not the responsibility for the interface to check again when the user comes back after adding a card. Default is false
     */
    public static func applePayStatus(for tapPaymentNetworks:[TapApplePayPaymentNetwork] = [], shouldOpenSetupDirectly:Bool = false) -> TapApplePayStatus {
        
        if   PKPaymentAuthorizationViewController.canMakePayments() {
            // Pay is available as per the device capability!
            // Check if the caller wants to determine for certain payments networks
            if !tapPaymentNetworks.isEmpty {
                if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: tapPaymentNetworks.map { $0.applePayNetwork! }) {
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
    public func authorizePayment(in presenter:UIViewController, for tapApplePayRequest:TapApplePayRequest, tokenized:((TapApplePayToken)->())) {
        
        let paymentController = PKPaymentAuthorizationViewController.init(paymentRequest: tapApplePayRequest.appleRequest)
        paymentController?.delegate = self
        
    }
    
    
    /// This will trigger the provided Apple pay official method for starting the wallet app
    public static func startApplePaySetupProcess() {
        
        PKPassLibrary().openPaymentSetup()
    }
    
}

extension TapApplePay:PKPaymentAuthorizationViewControllerDelegate {
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void){
        completion(PKPaymentAuthorizationResult(status: .success,errors: nil))
        
        if let nonNullTokenizedBlock = tokenizedBlock {
            nonNullTokenizedBlock(TapApplePayToken.init(with:payment.token))
        }
    }
}
