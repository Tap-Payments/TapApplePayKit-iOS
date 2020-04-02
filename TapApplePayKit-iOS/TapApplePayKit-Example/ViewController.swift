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
    let dataSource = ["Apple Pay Status","Try Apple Pay Setup","Try Apple Pay In Action"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.row]
        
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

