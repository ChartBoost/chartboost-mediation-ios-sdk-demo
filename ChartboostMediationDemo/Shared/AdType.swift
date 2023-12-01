//
//  AdType.swift
//  ChartboostMediationDemo
//
//  Created by Alexander Rice on 9/25/23.
//  Copyright © 2023 Chartboost. All rights reserved.
//

import UIKit

/// An enumeration of each advertisement type.
enum AdType: String, CaseIterable {
    case banner
    case interstitial
    case rewarded

    var title: String {
        rawValue.capitalized
    }
}
