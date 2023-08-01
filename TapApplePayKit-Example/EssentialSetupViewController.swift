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

    @IBOutlet weak var productionKeyTextFied: UITextField!
    @IBOutlet weak var sandboxKeyTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = true
        // Do any additional setup after loading the view.
    }
   
    
    
    @IBAction func setupButtonClicked(_ sender: Any) {
        loadingIndicator.isHidden = false
        TapApplePay.sdkMode = .production
        
        TapApplePay.setupTapMerchantApplePay(merchantKey: .init(sandbox: sandboxKeyTextField.text ?? "", production: productionKeyTextFied.text ?? "")) {
            DispatchQueue.main.async {
                self.loadingIndicator.isHidden = true
                self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "ViewController"))!, animated: true)
            }
        } onErrorOccured: { error in
            let alertView:UIAlertController = .init(title: "Error occured", message: "We couldn't process your request. \(error ?? "")", preferredStyle: .alert)
            alertView.addAction(.init(title: "Cancel", style: .cancel))
            self.present(alertView, animated: true)
            self.loadingIndicator.isHidden = true
        }

    }
    
    @IBAction func resetDataClicked(_ sender: Any) {
        sandboxKeyTextField.text    = "pk_test_Vlk842B1EA7tDN5QbrfGjYzh"
        productionKeyTextFied.text  = "pk_live_UYnihb8dtBXm9fDSw1kFlPQA"
    }
    
    
    
}
