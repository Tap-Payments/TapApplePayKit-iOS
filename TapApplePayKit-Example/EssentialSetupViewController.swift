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
        TapApplePay.setupTapMerchantApplePay(merchantKey: .init(sandbox: sandboxKeyTextField.text ?? "", production: productionKeyTextFied.text ?? "")) {
            let alertView:UIAlertController = .init(title: "DONE", message: "Start testing Apple pay sdk", preferredStyle: .alert)
            alertView.addAction(.init(title: "Sandbox", style: .destructive,handler: { _ in
                DispatchQueue.main.async {
                    TapApplePay.sdkMode = .sandbox
                    self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "ViewController"))!, animated: true)
                }
            }))
            
            alertView.addAction(.init(title: "Production", style: .destructive,handler: { _ in
                DispatchQueue.main.async {
                    TapApplePay.sdkMode = .production
                    self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "ViewController"))!, animated: true)
                }
            }))
            self.present(alertView, animated: true)
            self.loadingIndicator.isHidden = true
        } onErrorOccured: { error in
            let alertView:UIAlertController = .init(title: "Error occured", message: "We couldn't process your request. \(error ?? "")", preferredStyle: .alert)
            alertView.addAction(.init(title: "Cancel", style: .cancel))
            self.present(alertView, animated: true)
            self.loadingIndicator.isHidden = true
        }

    }
    
    @IBAction func resetDataClicked(_ sender: Any) {
        sandboxKeyTextField.text    = "pk_test_Vlk842B1EA7tDN5QbrfGjYzh"
        productionKeyTextFied.text  = "sk_live_QglH8V7Fw6NPAom4qRcynDK2"
    }
    
    
    
}
