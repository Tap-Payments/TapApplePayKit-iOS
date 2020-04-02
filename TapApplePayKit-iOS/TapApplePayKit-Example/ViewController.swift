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
    let tapApplePay:TapApplePay = .init()
    
    let dataSource = [["Country Code","Currency Code","Payment Networks","Transaction Amount"],["Check Apple Pay Status","Try Apple Pay Setup","Authorize Payment"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tapApplePayRequest.build(paymentAmount: 10, merchantID: "merchant.tap.gosell")
        
        featuresTableView.dataSource = self
        featuresTableView.delegate = self
    }
    
    
    func selectCountryCode() {
        
        showPicker(with: "Select country", placeHolder: "Search country", dataSource: TapCountryCode.allCases.map{$0.rawValue},preselect: [tapApplePayRequest.countryCode.rawValue],onSelected:{
            [weak self] (selectedValues,selectedIndices) in
            
            DispatchQueue.main.async {
                self?.tapApplePayRequest.countryCode =  TapCountryCode.allCases[selectedIndices[0]]
                self?.featuresTableView.reloadData()
            }
        })
    }
    
    
    func selectCurrencyCode() {
        
        showPicker(with: "Select currency", placeHolder: "Search currency", dataSource: TapCurrencyCode.allCases.map{$0.rawValue},preselect: [tapApplePayRequest.currencyCode.rawValue],onSelected:{
            [weak self] (selectedValues,selectedIndices) in
            
            DispatchQueue.main.async {
                self?.tapApplePayRequest.currencyCode =  TapCurrencyCode.allCases[selectedIndices[0]]
                self?.featuresTableView.reloadData()
            }
        })
    }
    
    func selectPaymentNetworks() {
        
        showPicker(with: "Select Network(s)", placeHolder: "Search networks", dataSource: TapApplePayPaymentNetwork.allCases.map{$0.rawValue},allowMultipleSelection: true,preselect: tapApplePayRequest.paymentNetworks.map{ $0.rawValue },onSelected:{
            [weak self] (selectedValues,selectedIndices) in
            
            DispatchQueue.main.async {
                self?.tapApplePayRequest.paymentNetworks =  selectedValues.map{TapApplePayPaymentNetwork.init(rawValue: $0)!}
                self?.featuresTableView.reloadData()
            }
        })
    }
    
    
    func showPicker(with title:String, placeHolder:String, dataSource:[String],allowMultipleSelection:Bool = false,preselect:[String] = [],onSelected:(([String],[Int])->())? = nil) {
        let regularFont = UIFont.systemFont(ofSize: 16)
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        let blueColor = UIColor.black
        
        let blueAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : title,
            titleFont           : boldFont,
            titleTextColor      : .black,
            titleBackground     : .clear,
            searchBarFont       : regularFont,
            searchBarPlaceholder: placeHolder,
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Done",
            doneButtonColor     : blueColor,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : UIImage(named:"blue_ic_checked"),
            itemUncheckedImage  : UIImage(),
            itemColor           : .black,
            itemFont            : regularFont
        )
        
        let picker = YBTextPicker.init(with: dataSource, appearance: blueAppearance,
                                       onCompletion: { (selectedIndexes, selectedValues) in
                                        if selectedValues.count > 0{
                                            
                                            if let nonNullBlock = onSelected {
                                                nonNullBlock(selectedValues,selectedIndexes)
                                            }
                                        }else{
                                            //self.btnFruitsPicker.setTitle("Select Fruits", for: .normal)
                                        }
        },
                                       onCancel: {
                                        print("Cancelled")
        }
        )
        picker.preSelectedValues = preselect
        picker.allowMultipleSelection = allowMultipleSelection
        picker.show(withAnimation: .Fade)
    }
    
    func checkApplePayStats() {
        let applePayStatus:TapApplePayStatus = TapApplePay.applePayStatus(for: tapApplePayRequest.paymentNetworks, shouldOpenSetupDirectly: false)
        
        let alertControl = UIAlertController(title: "Apple Pay Status for \(tapApplePayRequest.paymentNetworks.map{$0.rawValue}.joined(separator: " , "))", message: applePayStatus.rawValue(), preferredStyle: .alert)
        if applePayStatus == .NeedSetup {
            let setupAction = UIAlertAction(title: "Setup?", style: .default) { [weak self] (_) in
                self?.startApplePaySetup()
            }
            alertControl.addAction(setupAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        alertControl.addAction(cancelAction)
        present(alertControl, animated: true, completion: nil)
    }
    
    func startApplePaySetup() {
        TapApplePay.startApplePaySetupProcess()
    }
    
    func authorisePayment() {
        
        /*if let paymentController = PKPaymentAuthorizationViewController.init(paymentRequest: tapApplePayRequest.appleRequest) {
            paymentController.delegate = self
            present(paymentController, animated: true, completion: nil)
        }*/
        
        tapApplePay.authorizePayment(in: self, for: tapApplePayRequest) { [weak self] (token) in
            let alertControl = UIAlertController(title: "Token", message: token.stringAppleToken, preferredStyle: .alert)
            let copyAction = UIAlertAction(title: "Copy", style: .default) { (_) in
                UIPasteboard.general.string = token.stringAppleToken
            }
            alertControl.addAction(copyAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
            alertControl.addAction(cancelAction)
            DispatchQueue.main.async {
                self?.present(alertControl, animated: true, completion: nil)
            }
            }
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
            case 3:
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
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                selectCountryCode()
            case 1:
                selectCurrencyCode()
            case 2:
                selectPaymentNetworks()
            default:
                return
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                checkApplePayStats()
            case 1:
                startApplePaySetup()
            case 2:
                authorisePayment()
            default:
                return
            }
        }
    }
}
