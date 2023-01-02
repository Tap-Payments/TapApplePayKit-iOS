//
//  TapApplePay.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 01/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import PassKit
import UIKit
import CommonDataModelsKit_iOS
import TapNetworkKit_iOS

/// This is the Tap provided class that provides the Tap-ApplePay functionalities
@objcMembers public class TapApplePay:NSObject {
    
    //MARK: Global shared values
    /// Indicates the mode the merchant wants to run the sdk with. Default is sandbox mode
    @objc public static var sdkMode:SDKMode = .sandbox
    /// Inidcates the tap provided keys for this merchant to use for his transactions. If not set, any transaction will fail. Please if you didn't get a tap key yet, refer to https://www.tap.company/en/sell
    @objc public static var secretKey:SecretKey = .init(sandbox: "sk_test_cvSHaplrPNkJO7dhoUxDYjqA",
                                                        production: "sk_live_QglH8V7Fw6NPAom4qRcynDK2")
    
    //MARK: Internal values
    
    /// The apple pay tokenization block. it will be called once we get an apple pay token from the apple pay system itself.
    internal var tokenizedBlock:((TapApplePayToken)->())?
    
//    var paymentController = PKPaymentAuthorizationController.init()
    
    
    //MARK: Public methods
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
    @objc public func authorizePayment(in presenter:UIViewController, for tapApplePayRequest:TapApplePayRequest, tokenized:@escaping ((TapApplePayToken)->())) {
        
        
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
    
    /**
     Create a  tap token wrapper for the raw apple pay token. This tap token can be used in further tap api calls (e.g. charge)
     - Parameter for applePayToken: The native iOS Apple Pay token
     - Parameter onTokenReady: The block to call whenever the Tap token was successfully generated
     - Parameter onErrorOccured: The block to call whenever the tap token failed for any reason
     */
    @objc public func createTapToken(for applePayToken:TapApplePayToken, onTokenReady: @escaping (Token) -> (), onErrorOccured: @escaping(TapNetworkManager.RequestCompletionClosure)) {
        // First create a tap tokenization for apple pay api request
        guard let applePayTokenRequestModel:TapCreateTokenWithApplePayRequest = createApplePayTokenRequestModel(for: applePayToken) as? TapCreateTokenWithApplePayRequest else { return }
        
        // Second Let us make the call to the tokenization api with the apple pay token data
        callCardTokenAPI(cardTokenRequestModel: applePayTokenRequestModel) { (token) in
            DispatchQueue.main.async{
                // Process the token we got from the server
                onTokenReady(token)
            }
        } onErrorOccured: { (session, result, error) in
            // Inform the caller abou the error for his own convience
            onErrorOccured(session, result, error)
        }
        
    }
    
    //MARK: private methods
    /**
     Create a card token api request
     - Parameter for applePayToken: The native iOS Apple Pay token
     - Returns: The Tokenize apple pay token api request model
     */
    internal func createApplePayTokenRequestModel(for applePayToken:TapApplePayToken) -> TapCreateTokenRequest? {
        do {
            return TapCreateTokenWithApplePayRequest.init(appleToken: try TapApplePayTokenModel.init(dictionary: applePayToken.jsonAppleToken))
        }catch{
            return nil
        }
    }
    
    
    /**
     Respinsiboe for calling create token for a card api
     - Parameter cardTokenRequest: The cardToken request model to be called with
     - Parameter onResponseReady: A block to call when getting the response
     - Parameter onErrorOccured: A block to call when an error occured
     */
    internal func callCardTokenAPI(cardTokenRequestModel:TapCreateTokenRequest, onResponeReady: @escaping (Token) -> () = {_ in}, onErrorOccured: @escaping(TapNetworkManager.RequestCompletionClosure)) {
        
        // Change the model into a dictionary
        guard let bodyDictionary = TapApplePay.convertModelToDictionary(cardTokenRequestModel, callingCompletionOnFailure: { error in
            onErrorOccured(nil,nil,error.debugDescription)
            return
        }) else { return }
        
        // Call the corresponding api based on the transaction mode
        // Perform the retrieve request with the computed data
        NetworkManager.shared.makeApiCall(routing: TapNetworkPath.token, resultType: Token.self, body: .init(body: bodyDictionary),httpMethod: .POST, urlModel: .none) { (session, result, error) in
            // Double check all went fine
            guard let parsedResponse:Token = result as? Token else {
                onErrorOccured(session, result, "Unexpected error parsing into token")
                return
            }
            // Execute the on complete block
            onResponeReady(parsedResponse)
        } onError: { (session, result, errorr) in
            // In case of an error we execute the on error block
            onErrorOccured(session, result, errorr.debugDescription)
        }
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

//MARK: Static methods
extension TapApplePay {
    
    
    /// Converts Encodable model into its dictionary representation. Calls completion closure in case of failure.
    ///
    /// - Parameters:
    ///   - model: Model to encode.
    ///   - completion: Failure completion closure.
    ///   - response: Response object in case of success. Here - always nil.
    ///   - error: Error in case of failure. If the closure is called it will never become nil.
    /// - Returns: Dictionary.
    static func convertModelToDictionary(_ model: Encodable, callingCompletionOnFailure completion: CompletionOnFailure) -> [String: Any]? {
        
        var modelDictionary: [String: Any]
        
        do {
            modelDictionary = try model.tap_asDictionary()
        }
        catch let error {
            
            completion(TapSDKKnownError(type: .serialization, error: error, response: nil, body: model))
            return nil
        }
        
        return modelDictionary
    }
    
    
    /// This will trigger the provided Apple pay official method for starting the wallet app
    @objc public static func startApplePaySetupProcess() {
        //FlurryLogger.logEvent(with: "Apple_Pay_Setup_Called")
        PKPassLibrary().openPaymentSetup()
    }
    
    
    typealias CompletionOnFailure = (TapSDKError?) -> Void
    
}
