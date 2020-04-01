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
import struct UIKit.CGRect
import  PassKit

@objc public protocol TapApplePayButtonDataSource {
    var tapApplePayRequest:TapApplePayRequest { get set }
}

@objc public protocol TapApplePayButtonDelegate {
    func tapApplePayErrorOccured(error:Error)->()
    func tapApplePayAthorisationStatus(changed to:PKPaymentAuthorizationStatus)->()
    func tapApplePayFinished(with appleToken:Data)->()
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
    var buttonType:TapApplePayButtonType = .AppleLogoOnly {
        didSet{
            configureApplePayButton()
        }
    }
    /// The actaual apple pay button wrappd inside Tap Kit
    internal var applePayButton:PKPaymentButton?
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    /**
     Method to configure the tap apple pay button
     - Parameter tapApplePayButtonClicked: Inform when the apple pay button is clicked
     - Parameter buttonType: The type/title to show for the Apple pay button
     */
    public func setup(tapApplePayButtonClicked:((TapApplePayButton)->())? = nil,buttonType:TapApplePayButtonType = .AppleLogoOnly) {
        
        self.tapApplePayButtonClicked = tapApplePayButtonClicked
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
        }else{
            applePayButton = .init(paymentButtonType: self.buttonType.applePayButtonType!, paymentButtonStyle: .black)
        }
        applePayButton?.frame = CGRect(x: 0,y: 0,width: self.buttonWidth,height: self.buttonHeight)
        self.addSubview(applePayButton!)
        self.bringSubviewToFront(applePayButton!)
        applePayButton?.addTarget(self, action: #selector(applePayClicked), for: .touchUpInside)
    }
    
    
    @objc internal func applePayClicked(_ sender : UIButton) {
        // Check if the caller defined a block to listen to the handler, if so call it
        if let nonNullApplePayButtonClickBlock = tapApplePayButtonClicked {
            nonNullApplePayButtonClickBlock(self)
        }else {
            // We need to handle the apple pay authorization process ourselves
            authorizePayment()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
