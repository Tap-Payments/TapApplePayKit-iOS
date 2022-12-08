//
//  TapModeEnum.swift
//  TapApplePayKit-iOS
//
//  Created by Osama Rabie on 08/12/2022.
//  Copyright © 2022 Tap Payments. All rights reserved.
//

import Foundation

/// Defines which mode will the apple pay sdk work with.
@objc public enum TapModeEnum:Int {
    
    /// The sdk will just process Apple pay and return back the raw apple pay token for further processing
    @objc(ApplePayToken)    case ApplePayToken
    /// The sdk will generate Tap token for the apple pay token for further processing
    @objc(TapToken)         case TapToken
    /// The sdk will perform an actual charge through Tap with the generated apple pay token
    @objc(Charge)           case Charge
    
}
