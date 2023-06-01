//
//  WebViewTypeEnum.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 17/01/2023.
//

import Foundation

/// An enum to state all the possible ways to display a web view inside.
public enum WebViewTypeEnum {
    
    /// The web view will take over and be displayed as an overlat
    case FullScreen
    /// The web view will be displayed within the given screen
    case InScreen
    /// The web view will be displayed within the card view
    case InCard
}
