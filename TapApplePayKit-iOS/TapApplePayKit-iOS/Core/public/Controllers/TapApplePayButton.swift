//
//  TapApplePayButton.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 01/04/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
import PassKit

@objcMembers public class TapApplePayButton: UIView {
    
    var tapApplePayButtonClicked:((TapApplePayButton)->())?
    internal lazy var buttonWidth:CGFloat = 140
    internal lazy var buttonHeight:CGFloat = 40
    var buttonType:TapApplePayButtonType = .AppleLogoOnly {
        didSet{
            configureApplePayButton()
        }
    }
    var applePayButton:PKPaymentButton?
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    public func setup(tapApplePayButtonClicked:((TapApplePayButton)->())? = nil,buttonType:TapApplePayButtonType = .AppleLogoOnly) {
        
        self.tapApplePayButtonClicked = tapApplePayButtonClicked
        self.buttonWidth = (frame.width >= 140) ? frame.width : 140
        self.buttonHeight = (frame.height >= 40) ? frame.height : 40
        self.buttonType = buttonType
        configureApplePayButton()
        //(paymentButtonType: self.buttonType.applePayButtonType!, paymentButtonStyle: .black)
        
    }
    
    
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
            if let nonNullApplePayButtonClickBlock = tapApplePayButtonClicked {
                nonNullApplePayButtonClickBlock(self)
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
