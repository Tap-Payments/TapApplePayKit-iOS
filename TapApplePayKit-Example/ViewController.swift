//
//  ViewController.swift
//  TapApplePayKit-Example
//
//  Created by Osama Rabie on 31/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit
import TapApplePayKit_iOS
import enum CommonDataModelsKit_iOS.TapCountryCode
import enum CommonDataModelsKit_iOS.TapCurrencyCode
import PassKit

class ViewController: UIViewController {
    
    @IBOutlet weak var featuresTableView: UITableView!
    
    @IBOutlet weak var tapApplePayButton:TapApplePayButton!
    let myTapApplePayRequest:TapApplePayRequest = .init()
    let tapApplePay:TapApplePay = .init()
    
    let dataSource = [["Currency Code","Payment Networks","Transaction Amount"],["Check Apple Pay Status","Try Apple Pay Setup","Authorize Payment"],["Tap Apple Pay Button Type","Tap Apple Pay Button Outline"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myTapApplePayRequest.build(paymentAmount: 0.1, applePayMerchantID: "merchant.tap.gosell")
        myTapApplePayRequest.build(paymentNetworks: [.Visa,.MasterCard], paymentItems: [], paymentAmount:0.1, currencyCode: .KWD,applePayMerchantID:"merchant.tap.gosell", merchantCapabilities: [.threeDSecure,.credit,.debit,.emv])
        featuresTableView.dataSource = self
        featuresTableView.delegate = self
        
        var _args:[String:Any] = [:]
        
        var allowedCapabilities:PKMerchantCapability = []
        
        if let passedCapabilities:[String] = _args[""] as? [String] {
            passedCapabilities.forEach({ capabilityString in
                if capabilityString.lowercased() == "threeds" {
                    allowedCapabilities.insert(.threeDSecure)
                }else if capabilityString.lowercased() == "credit" {
                    allowedCapabilities.insert(.credit)
                }else if capabilityString.lowercased() == "debit" {
                    allowedCapabilities.insert(.debit)
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tapApplePayButton.setup()
        
        tapApplePayButton?.dataSource = self
        tapApplePayButton?.delegate = self
        //tapApplePayButton?.setup(buttonType: .DonateWithApplePay,buttonStyle: .WhiteOutline)
    }
    
    func selectCountryCode() {
        
    }
    
    
    func selectCurrencyCode() {
        
        showPicker(with: "Select currency", placeHolder: "Search currency", dataSource: TapCurrencyCode.allCases.map{$0.appleRawValue},preselect: [myTapApplePayRequest.currencyCode.appleRawValue],onSelected:{
            [weak self] (selectedValues,selectedIndices) in
            
            DispatchQueue.main.async {
                self?.myTapApplePayRequest.currencyCode =  TapCurrencyCode.allCases[selectedIndices[0]]
                self?.featuresTableView.reloadData()
            }
        })
    }
    
    func selectPaymentNetworks() {
        
        showPicker(with: "Select Network(s)", placeHolder: "Search networks", dataSource: TapApplePayPaymentNetwork.allCases.map{$0.rawValue},allowMultipleSelection: true,preselect: myTapApplePayRequest.paymentNetworks.map{ $0.rawValue },onSelected:{
            [weak self] (selectedValues,selectedIndices) in
            
            DispatchQueue.main.async {
                self?.myTapApplePayRequest.paymentNetworks =  selectedValues.map{TapApplePayPaymentNetwork.init(rawValue: $0)!}
                self?.featuresTableView.reloadData()
            }
        })
    }
    
    
    func selectButtonType() {
        
        showPicker(with: "Select type", placeHolder: "Search type", dataSource: TapApplePayButtonType.allCases.map{$0.rawValue},preselect: [(tapApplePayButton?.buttonType.rawValue)!],onSelected:{
            [weak self] (selectedValues,selectedIndices) in
            
            DispatchQueue.main.async {
                self?.tapApplePayButton?.buttonType = TapApplePayButtonType.allCases[selectedIndices[0]]
            }
        })
    }
    
    func selectButtonStyle() {
        showPicker(with: "Select style", placeHolder: "Search style", dataSource: TapApplePayButtonStyleOutline.allCases.map{$0.rawValue},preselect: [(tapApplePayButton?.buttonStyle.rawValue)!],onSelected:{
            [weak self] (selectedValues,selectedIndices) in
            
            DispatchQueue.main.async {
                self?.tapApplePayButton?.buttonStyle = TapApplePayButtonStyleOutline.allCases[selectedIndices[0]]
            }
        })
    }
    
    
    func showPicker(with title:String, placeHolder:String, dataSource:[String],allowMultipleSelection:Bool = false,preselect:[String] = [],onSelected:(([String],[Int])->())? = nil) {
        let regularFont = UIFont.systemFont(ofSize: 16)
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        let blueColor = UIColor.black
        var titleColor = UIColor.black
        if #available(iOS 13, *) {
            if UITraitCollection.current.userInterfaceStyle == UIUserInterfaceStyle.dark {
                titleColor = .white
            }
        }
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
            itemColor           : titleColor,
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
        let applePayStatus:TapApplePayStatus = TapApplePay.applePayStatus(for: myTapApplePayRequest.paymentNetworks, shouldOpenSetupDirectly: false)
        
        let alertControl = UIAlertController(title: "Apple Pay Status for \(myTapApplePayRequest.paymentNetworks.map{$0.rawValue}.joined(separator: " , "))", message: applePayStatus.ApplePayStatusRawValue(), preferredStyle: .alert)
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
        
        tapApplePay.authorizePayment(for: myTapApplePayRequest) { [weak self] (token) in
            self?.showTokenizedData(with: token)
        } onErrorOccured: { error in
            let alertControl = UIAlertController(title: "Invalid data passed", message: error.TapApplePayRequestValidationErrorRawValue(), preferredStyle: .alert)
            alertControl.addAction(.init(title: "OK", style: .cancel))
            self.present(alertControl, animated: true)
        }
    }
    
    func showTokenizedData(with token:TapApplePayToken) {
        let alertControl = UIAlertController(title: "Token", message: token.stringAppleToken, preferredStyle: .alert)
        let copyAction = UIAlertAction(title: "Copy", style: .default) { (_) in
            DispatchQueue.main.async { [weak self] in
                let vc = UIActivityViewController(activityItems: [token.stringAppleToken!], applicationActivities: [])
                self?.present(vc, animated: true)
            }
        }
        let tapTokenAction = UIAlertAction(title: "Generate Tap Token", style: .default) { [weak self] _ in
            DispatchQueue.main.async {
                self?.tapApplePay.createTapToken(for: token, onTokenReady: { tapToken in
                    let alert:UIAlertController = .init(title: "Tap Token Success", message: tapToken.identifier, preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .cancel))
                    self?.present(alert, animated: true)
                }, onErrorOccured: { (session, result, error) in
                    
                    let alert:UIAlertController = .init(title: "Tap Token Failed", message: error.debugDescription, preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .cancel))
                    self?.present(alert, animated: true)
                })
            }
        }
        alertControl.addAction(copyAction)
        alertControl.addAction(tapTokenAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        alertControl.addAction(cancelAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertControl, animated: true, completion: nil)
        }
    }
}


extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Transaction Data Attributes"
        case 1:
            return "Features Testing"
        case 2:
            return "Tap Apple Pay Button"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row]
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = "Selected \(myTapApplePayRequest.currencyCode.appleRawValue)"
                break
            case 1:
                cell.detailTextLabel?.text = "Selected \(myTapApplePayRequest.paymentNetworks.map{ $0.rawValue }.joined(separator:" , "))"
                break
            case 2:
                cell.detailTextLabel?.text = "Selected \(myTapApplePayRequest.paymentAmount)"
                break
            default:
                break
            }
        }else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = "Selected \(tapApplePayButton?.buttonType.rawValue ?? "")"
                break
            case 1:
                cell.detailTextLabel?.text = "Selected \(tapApplePayButton?.buttonStyle.rawValue ?? "")"
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
                selectCurrencyCode()
            case 1:
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
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                selectButtonType()
            case 1:
                selectButtonStyle()
            default:
                return
            }
        }
    }
}


extension ViewController:TapApplePayButtonDataSource,TapApplePayButtonDelegate {
    func tapApplePayValidationError(error: TapApplePayKit_iOS.TapApplePayRequestValidationError) {
        let alertControl = UIAlertController(title: "Invalid data passed", message: error.TapApplePayRequestValidationErrorRawValue(), preferredStyle: .alert)
        alertControl.addAction(.init(title: "OK", style: .cancel))
        self.present(alertControl, animated: true)
    }
    
    var tapApplePayRequest: TapApplePayRequest {
        return myTapApplePayRequest
    }
    
    func tapApplePayFinished(with tapAppleToken: TapApplePayToken) {
        showTokenizedData(with: tapAppleToken)
    }
}
