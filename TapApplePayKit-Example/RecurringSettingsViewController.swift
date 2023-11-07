//
//  RecurringSettingsViewController.swift
//  TapApplePayKit-Example
//
//  Created by Osama Rabie on 07/11/2023.
//  Copyright © 2023 Tap Payments. All rights reserved.
//

import UIKit
import Eureka

protocol RecurringSettinfsDelegate {
    func updateRecurringWith(paymentDescription:String, billingInterval:NSCalendar.Unit, billingFrequency:Int, endDate:Date, agreement:String, token:URL, manage:URL)
}

class RecurringSettingsViewController: FormViewController {

    var paymentDescriptio:String = "Recugging Payment Description"
    var billingInterval:UInt = NSCalendar.Unit.day.rawValue
    var billingIntervalString:[UInt:String] = [NSCalendar.Unit.day.rawValue:"Day",NSCalendar.Unit.month.rawValue:"Month",NSCalendar.Unit.year.rawValue:"Year"]
    var billingFrequency:Int = 1
    var billindDateComponents:Date = .init().addingTimeInterval(24*60*60)
    var billingAgreement:String = ""
    var tokenNotifUrl:String = ""
    var managementUrl:String = ""
    var delegate:RecurringSettinfsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        form +++ Section("Recurring Data")
        <<< TextRow("paymentDescription"){ row in
            row.title = "paymentDescriptio"
            row.value = paymentDescriptio
            row.onChange { row in
                self.paymentDescriptio = row.value ?? self.paymentDescriptio
            }
        }
        
        <<< SegmentedRow<String>("billingInterval") { row in
            row.title = "Billing interval"
            row.value = billingIntervalString[billingInterval]
            row.options = billingIntervalString.values.map{ return $0 }
            row.onChange { row in
                let unit:UInt = self.billingIntervalString.tap_allKeys.first { key in
                    self.billingIntervalString[key] == row.value ?? "Month"
                } ?? NSCalendar.Unit.month.rawValue
                self.billingInterval = unit
                var dateComponent = DateComponents()
                if self.billingInterval == NSCalendar.Unit.day.rawValue {
                    dateComponent.day = 5
                }else if self.billingInterval == NSCalendar.Unit.month.rawValue {
                    dateComponent.day = 5
                }else if self.billingInterval == NSCalendar.Unit.year.rawValue {
                    dateComponent.year = 5
                }
                self.billindDateComponents = Calendar.current.date(byAdding: dateComponent, to: Date())!
            }
        }
        
        <<< SegmentedRow<Int>("billingFreq") { row in
            row.title = "Billing Frequency"
            row.value = self.billingFrequency
            row.options = [1,2,3,4,5]
            row.onChange { row in
                self.billingFrequency = row.value ?? 1
            }
        }
        
        
        <<< TextRow("billingAgreement"){ row in
            row.title = "billing agreement"
            row.value = self.billingAgreement
            row.onChange { row in
                self.billingAgreement = row.value ?? ""
            }
        }
        
        
        <<< TextRow("tokenNotificationURL"){ row in
            row.title = "token notif url"
            row.value = self.tokenNotifUrl
            row.onChange { row in
                self.tokenNotifUrl = row.value ?? ""
            }
        }
        
        
        <<< TextRow("managUrl"){ row in
            row.title = "manage url"
            row.value = self.managementUrl
            row.onChange { row in
                self.managementUrl = row.value ?? ""
            }
        }
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateRecurringWith(paymentDescription: paymentDescriptio, billingInterval: NSCalendar.Unit(rawValue: self.billingInterval), billingFrequency: billingFrequency, endDate: billindDateComponents, agreement: billingAgreement, token: URL(string: tokenNotifUrl)!, manage: URL(string: managementUrl)!)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
