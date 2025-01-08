//
//  EssentialSetupViewController.swift
//  TapApplePayKit-Example
//
//  Created by Osama Rabie on 01/06/2023.
//  Copyright © 2023 Tap Payments. All rights reserved.
//

import UIKit
import TapApplePayKit_iOS

class EssentialSetupViewController: UIViewController {

    @IBOutlet weak var merchantIDTextField: UITextField!
    @IBOutlet weak var productionKeyTextFied: UITextField!
    @IBOutlet weak var sandboxKeyTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var myTapApplePayRequest:TapApplePayRequest = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = true
        // First define your environment
        TapApplePay.sdkMode = .sandbox
        // Second define your transaction & merchant details
        setupApplePayRequest()
        // Do any additional setup after loading the view.
    }
   
    /// Call this to first define your transaction & merchant details
    func setupApplePayRequest() {
        myTapApplePayRequest.build(paymentAmount: 0.1, applePayMerchantID: "merchant.tap.gosell")
        myTapApplePayRequest.build(paymentNetworks: [.Visa,.MasterCard], paymentItems: [], paymentAmount:0.1, currencyCode: .KWD,applePayMerchantID:"merchant.tap.gosell", merchantCapabilities: [.threeDSecure,.credit,.debit,.emv])
    }
    
    
    
    @IBAction func setupButtonClicked(_ sender: Any) {
        loadingIndicator.isHidden = false
        
        TapApplePay.setupTapMerchantApplePay(merchantKey: .init(sandbox: sandboxKeyTextField.text ?? "", production: productionKeyTextFied.text ?? ""), merchantID: merchantIDTextField.text ?? "", onSuccess:  {
            DispatchQueue.main.async {
                self.loadingIndicator.isHidden = true
                self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "ViewController"))!, animated: true)
            }
        }, onErrorOccured: { error in
            DispatchQueue.main.async {
                let alertView:UIAlertController = .init(title: "Error occured", message: "We couldn't process your request. \(error ?? "")", preferredStyle: .alert)
                alertView.addAction(.init(title: "Cancel", style: .cancel))
                self.present(alertView, animated: true)
                self.loadingIndicator.isHidden = true
            }
        }, tapApplePayRequest: myTapApplePayRequest)

    }
    
    @IBAction func resetDataClicked(_ sender: Any) {
        sandboxKeyTextField.text    = "pk_test_Vlk842B1EA7tDN5QbrfGjYzh"
        productionKeyTextFied.text  = "pk_live_UYnihb8dtBXm9fDSw1kFlPQA"
    }
    
    
    
}
