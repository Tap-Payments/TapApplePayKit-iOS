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
    
    
    /**
     This method will be called if you passed invalid data while creating apple pay request
     - Parameter appleToken: The correctly and authorized tokenized payment data from Apple Pay kit
     */
    func tapApplePayValidationError(error:TapApplePayRequestValidationError)->()
}
/// Class represents the UIView that has Apple pay button wrapped inside Tap Kit
@objcMembers public class TapApplePayButton: UIView {
    
    @IBOutlet var conentView: UIView!
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
            if oldValue != buttonStyle {
                configureApplePayButton()
            }
        }
    }
    /// The actaual apple pay button wrappd inside Tap Kit
    internal var applePayButton:PKPaymentButton?
    
    /// The delegate to get action notifications from the Tap apple pay button
    public var delegate:TapApplePayButtonDelegate?
    
    /// The delegate to get action notifications from the Tap apple pay button
    public var dataSource:TapApplePayButtonDataSource?
    
    // Mark:- Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        self.conentView = setupXIB()
        conentView.backgroundColor = .clear
    }
    
    
    /**
     Method to configure the tap apple pay button
     - Parameter tapApplePayButtonClicked: Inform when the apple pay button is clicked
     - Parameter buttonType: The type/title to show for the Apple pay button
     */
    public func setup(tapApplePayButtonClicked:((TapApplePayButton)->())? = nil,buttonType:TapApplePayButtonType = .PayWithApplePay, buttonStyle:TapApplePayButtonStyleOutline = .Black) {
        
        self.tapApplePayButtonClicked = tapApplePayButtonClicked
        self.buttonStyle = buttonStyle
        // The minimum size accepted by Apple
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0)) {
            self.buttonWidth = self.frame.width//(self.frame.width >= 140) ? self.frame.width : 140
            self.buttonHeight = self.frame.height//(self.frame.height >= 40) ? self.frame.height : 40
            self.buttonType = buttonType
            self.configureApplePayButton()
        }
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
        
        applePayButton?.translatesAutoresizingMaskIntoConstraints = false
        applePayButton?.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        applePayButton?.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        applePayButton?.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        applePayButton?.layoutIfNeeded()
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
            }) { error in
                self.delegate?.tapApplePayValidationError(error: error)
                return
            }
        }else {
            fatalError("Tap Apple Pay Button must have a valid data source that pass a valid TapApplePayRequest")
        }
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



fileprivate extension UIView {
    // MARK:- Loading a nib dynamically
    /**
     Load a XIB file into a UIView
     - Parameter bundle: The bundle to load the XIB from, default is the XIB containing the UIView
     - Parameter identefier: The name of the XIB, default is the name of the UIView
     - Parameter addAsSubView: Indicates whether the method should add the loaded XIB into the UIView, default is true
     */
    func setupXIB(from bundle:Bundle? = nil, with identefier: String? = nil, then addAsSubView:Bool = true) -> UIView {
        
        // Whether we use the passed bundle if any, or by default we use the bundle that contains the caller UIView
        let bundle = bundle ?? Bundle(for: Self.self)
        // Whether we use the passed identefier if any, or by default we use the default identefier for self
        let identefier = identefier ??  String(describing: type(of: self))
        
        // Load the XIB file
        guard let nibs = bundle.loadNibNamed(identefier, owner: self, options: nil),
              nibs.count > 0, let loadedView:UIView = nibs[0] as? UIView else { fatalError("Couldn't load Xib \(identefier)") }
        
        let newContainerView = loadedView
        
        //Set the bounds for the container view
        newContainerView.frame = bounds
        newContainerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        // Check if needed to add it as subview
        if addAsSubView {
            addSubview(newContainerView)
        }
        //newContainerView.semanticContentAttribute = TapLocalisationManager.shared.localisationLocale == "ar" ? .forceRightToLeft : .forceLeftToRight
        return newContainerView
    }
}
