// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  AdType.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import SwiftUI

/// An enumeration of each advertisement type.
enum AdType: String, CaseIterable {
    case banner
    case interstitial
    case rewarded
}

extension AdType {
    /// A title for the ad type.
    var title: String {
        rawValue.capitalized
    }

    /// An icon that represents the ad type.
    var icon: Image {
        Image(title)
    }
}
