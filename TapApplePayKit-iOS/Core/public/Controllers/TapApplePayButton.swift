//
//  TapApplePayButton.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 01/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import class UIKit.UIView
import class UIKit.UIButton
import struct UIKit.CGFloat
import class UIKit.UIViewController
import struct UIKit.CGRect
import  class PassKit.PKPaymentButton

/// Data source to provide needed data for the apple pay button to start the apple authorization process
@objc public protocol TapApplePayButtonDataSource {
    /// This s the Tap wrapper of Apple pay request and it is a must to be correctly filled before firing Apple pay request
    var tapApplePayRequest:TapApplePayRequest { get }
}

/// Delegate of methods Tap Apple Pay will use to pass back the results of the authorization process
@objc public protocol TapApplePayButtonDelegate {
    /**
     This method will be called once the authprization happened
     - Parameter appleToken: The correctly and authorized tokenized payment data from Apple Pay kit
     */
    func tapApplePayFinished(with tapAppleToken:TapApplePayToken)->()
}
/// Class represents the UIView that has Apple pay button wrapped inside Tap Kit
@objcMembers public class TapApplePayButton: UIView {
    
    /// Click handler block, if this is set, then the caller determines that he will handle the click on the Apple Pay button himself.
    var tapApplePayButtonClicked:((TapApplePayButton)->())?
    /// Apple pay button width
    internal lazy var buttonWidth:CGFloat = 140
    /// Apple pay button height
    internal lazy var buttonHeight:CGFloat = 40
    /// Button type, which will define the title printed on Apple Pay button. If not provided, then Plain button will be shown.
    public var buttonType:TapApplePayButtonType = .AppleLogoOnly {
        didSet{
            configureApplePayButton()
        }
    }
    internal let tapApplePay = TapApplePay()
    
    /// Button type, which will define the style of the Tap Apple Pay Button
    public var buttonStyle:TapApplePayButtonStyleOutline = .Black {
        didSet{
            configureApplePayButton()
        }
    }
    /// The actaual apple pay button wrappd inside Tap Kit
    internal var applePayButton:PKPaymentButton?
    
    /// The delegate to get action notifications from the Tap apple pay button
    public var delegate:TapApplePayButtonDelegate?
    
    /// The delegate to get action notifications from the Tap apple pay button
    public var dataSource:TapApplePayButtonDataSource?
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        //FlurryLogger.logEvent(with: "Apple_Pay_Button_Created")
    }
    
    /**
     Method to configure the tap apple pay button
     - Parameter tapApplePayButtonClicked: Inform when the apple pay button is clicked
     - Parameter buttonType: The type/title to show for the Apple pay button
     */
    public func setup(tapApplePayButtonClicked:((TapApplePayButton)->())? = nil,buttonType:TapApplePayButtonType = .AppleLogoOnly, buttonStyle:TapApplePayButtonStyleOutline = .Black) {
        
        self.tapApplePayButtonClicked = tapApplePayButtonClicked
        self.buttonStyle = buttonStyle
        // The minimum size accepted by Apple
        self.buttonWidth = (frame.width >= 140) ? frame.width : 140
        self.buttonHeight = (frame.height >= 40) ? frame.height : 40
        self.buttonType = buttonType
        configureApplePayButton()
        
    }
    
    /// This holds the logic that will create the actual apple pay button, setting the size, the type, the color and the handler
    internal func configureApplePayButton() {
        if let nonNullApplePayButton = applePayButton {
            nonNullApplePayButton.removeFromSuperview()
            applePayButton?.removeTarget(self, action: #selector(applePayClicked), for: .touchUpInside)
        }
        applePayButton = .init(paymentButtonType: self.buttonType.applePayButtonType!, paymentButtonStyle: buttonStyle.applePayButtonStyle!)
        applePayButton?.frame = CGRect(x: 0,y: 0,width: self.buttonWidth,height: self.buttonHeight)
        self.addSubview(applePayButton!)
        self.bringSubviewToFront(applePayButton!)
        applePayButton?.addTarget(self, action: #selector(applePayClicked), for: .touchUpInside)
        
        //FlurryLogger.logEvent(with: "Apple_Pay_Button_Configured", timed:false , params:["type":self.buttonType.rawValue,"style":buttonStyle.rawValue])
    }
    
    
    @objc internal func applePayClicked(_ sender : UIButton) {
        // Check if the caller defined a block to listen to the handler, if so call it
        if let nonNullApplePayButtonClickBlock = tapApplePayButtonClicked {
            nonNullApplePayButtonClickBlock(self)
        }else {
            // We need to handle the apple pay authorization process ourselves
            startApplePaymentAuthorization()
        }
    }
    
    /// This will start the native Apple Pay authprization process
    internal func startApplePaymentAuthorization() {
        // It is a must to have a data source, henc the payment request itself
        if let nonNullDataSource = dataSource {
            
            // Initiate the authorization and wait for the feedback from Apple
            tapApplePay.authorizePayment(in: self.findViewController()!, for: nonNullDataSource.tapApplePayRequest , tokenized: { [weak self] (token) in
                if let nonNullDelegate = self?.delegate {
                    // If there is alistener, let him know that the authorization is done with the provided tokem
                    nonNullDelegate.tapApplePayFinished(with: token)
                }
            })
        }else {
            fatalError("Tap Apple Pay Button must have a valid data source that pass a valid TapApplePayRequest")
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}


internal extension UIView {
    /**
     An extension method to detect the viewcontroller which the current view is embedded in
     - Returns: UIViewcontroller that holds the current view or nil if not found for any case
 **/
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
