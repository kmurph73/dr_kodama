//
//  File.swift
//  Dr. Kodama
//
//  Created by Kyle Murphy on 9/19/20.
//  Copyright © 2020 Kyle Murphy. All rights reserved.
//

import Foundation
import UIKit

// https://stackoverflow.com/a/29622324/548170

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && (ScreenSize.SCREEN_MAX_LENGTH == 1024.0 || ScreenSize.SCREEN_MAX_LENGTH == 1080.0)
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && (ScreenSize.SCREEN_MAX_LENGTH == 1366.0 || ScreenSize.SCREEN_MAX_LENGTH == 1194.0)
    static let IS_IPAD_AIR          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1180.0
}

