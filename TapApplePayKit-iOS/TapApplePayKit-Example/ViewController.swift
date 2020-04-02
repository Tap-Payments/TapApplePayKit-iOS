//
//  ViewController.swift
//  TapApplePayKit-Example
//
//  Created by Osama Rabie on 31/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit
import TapApplePayKit_iOS

class ViewController: UIViewController {

    @IBOutlet weak var featuresTableView: UITableView!
    
    let tapApplePayRequest:TapApplePayRequest = .init()
    
    let dataSource = [["Country Code","Currency Code","Payment Networks","Transaction Amount"],["Check Apple Pay Status","Try Apple Pay Setup","Authorize Payment"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tapApplePayRequest.build(paymentAmount: 10, merchantID: "merchant.tap.gosell")
        
        featuresTableView.dataSource = self
        featuresTableView.delegate = self
    }
    
    
    func checkApplePayStats() {
        let applePayStatus:TapApplePayStatus = TapApplePay.applePayStatus()
        
        let alertControl = UIAlertController(title: "Apple Pay Status", message: applePayStatus.rawValue(), preferredStyle: .alert)
        if applePayStatus == .NeedSetup {
            let setupAction = UIAlertAction(title: "Setup?", style: .default) { (_) in
                TapApplePay.startApplePaySetupProcess()
            }
            alertControl.addAction(setupAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default,handler: nil)
        alertControl.addAction(cancelAction)
        present(alertControl, animated: true, completion: nil)
    }
}


extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Transaction Data Attributes" : "Features Testing"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row]
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = "Selected \(tapApplePayRequest.countryCode.rawValue)"
                break
            case 1:
                cell.detailTextLabel?.text = "Selected \(tapApplePayRequest.currencyCode.rawValue)"
                break
            case 2:
                cell.detailTextLabel?.text = "Selected \(tapApplePayRequest.paymentNetworks.map{ $0.rawValue }.joined(separator:" , "))"
                break
            case 4:
                cell.detailTextLabel?.text = "Selected \(tapApplePayRequest.paymentAmount)"
                break
            default:
                break
            }
        }else{
            cell.detailTextLabel?.text = ""
        }
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            checkApplePayStats()
        default:
            return
        }
    }
    
}

